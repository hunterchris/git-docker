#!groovy
@Library("infra-deployment@development") _
def deployConfig = [
  appCommit : "latest",
  terraformProject : "internal-mgmt",
  stagingBranch : "development",
  releasePrefix : "release",
  productionBranch : "master",
  /* featureBranch : "feature/function" */
]

import com.deployment.GlobalVars
def Class GlobalVars_local = GlobalVars

pipeline {
    agent {
        label 'packer'
    }
    environment {
        APP_NAME = "git-docker"
        REGISTRY = "medneo-docker.jfrog.io"
        DOCKER_TAG = "${env.BRANCH_NAME}_v${env.BUILD_NUMBER}"
    }
    stages {
        stage('Do parallel testing') {
            //parallel {
                stage('Test jFrog access by pushing a docker image') {
                    agent { label 'packer' }
                        steps {
                            script {
                                docker.withRegistry(
                                    'https://' + env.REGISTRY,
                                    'jfrogDockerRegistryCredentials',
                                    {
                                        build_image = docker.build(env.APP_NAME)
                                        build_image.push('latest')
                                        build_image.push(env.DOCKER_TAG)
                                    }
                                )
                            }
                        }
                    }
                stage('Test PyPI credentials to get dependencies') {
                    agent { label '20GB' }
                    environment {
                        SOME_CREDS_FOR_PYPI_AUTH = credentials('JFROG-PYPI-PUBLISHER-CREDS')
                    }
                    steps {
                        script {
                            docker.withRegistry(
                                'https://medneo-docker.jfrog.io',
                                'jfrogDockerRegistryCredentials',
                                {
                                    build_image = docker.image("python:3.6-slim-jessie")
                                    build_image.inside("--user=root",
                                        {c->
                                            sh """
                                                mkdir -p pip-deps && \
                                                pip download \
                                                --dest pip-deps \
                                                --extra-index-url https://${SOME_CREDS_FOR_PYPI_AUTH_USR}:${SOME_CREDS_FOR_PYPI_AUTH_PSW}@medneo.jfrog.io/medneo/api/pypi/medneo-pypi/simple \
                                                django-cloudstore
                                            """    
                                        }
                                    )
                                }
                            )
                        }
                    }
                }
                stage('Test MVN credentials') {
                    agent {label 'docker-compose'}
                    steps {
                        script {
                            build_specific_tag = env.BRANCH_NAME.replace('/', '_') + env.BUILD_NUMBER
                            withCredentials([usernamePassword(credentialsId: 'jfrog-mvn-repository-publisher-creds', usernameVariable: 'JFROG_USR', passwordVariable: 'JFROG_PWD')]) {
                                configFileProvider([configFile(fileId: "jfrog-gradle-mvn-repo-config", variable: 'file', targetLocation: './local.properties', replaceTokens: true)]) {
                                    def text = readFile "${file}"
                                    def replaced = text.replace("jfrogUsername=", "jfrogUsername=" + "${JFROG_USR}").replace("jfrogPassword=", "jfrogPassword=" + "${JFROG_PWD}")
                                    writeFile file: "${file}", text: replaced
                                    docker.withRegistry(
                                        'https://medneo-docker.jfrog.io',
                                        'jfrogDockerRegistryCredentials',
                                        {
                                            build_image = docker.image(env.APP_NAME)
                                            build_image.inside('--user=root',
                                                { c ->
                                                    sh """
                                                        gradle wrapper --gradle-version 2.13 && \
                                                        ./gradlew build && \
                                                        ./gradlew --no-daemon --continue --rerun-tasks --stacktrace test
                                                        ./gradlew run
                                                    """
                                                }
                                            )
                                        }
                                    )
                                }
                            }
                        }
                    }
                }
                stage('Test NPM credentials') {
                    environment {
                        SOME_CREDS_FOR_BASIC_AUTH = credentials('jfrog-npm-registry-publisher-creds')
                    }   
                    steps {
                        script {
                            configFileProvider([configFile(fileId: "test-npm-2", variable: 'file', targetLocation: '.npmrc', replaceTokens: true)]) {
                                def text = readFile "${file}"
                                def replaced = text.replace("_auth =", "_auth = " + "${SOME_CREDS_FOR_BASIC_AUTH}")
                                writeFile file: "${file}", text: replaced
                                build_specific_tag = env.BRANCH_NAME.replace('/', '_') + env.BUILD_NUMBER
                                docker.withRegistry(
                                    'https://medneo-docker.jfrog.io',
                                    'jfrogDockerRegistryCredentials',
                                    {
                                        build_image = docker.image("npmbuilder104:1.0.0")
                                        build_image.inside('--user=root',
                                            { c ->
                                                sh "yarn install && yarn start"
                                            }
                                        )
                                    }
                                )    
                            }
                        }
                    }
                }
            //}
        }
    }
}