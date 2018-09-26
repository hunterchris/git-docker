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
        stage('Test jFrog access by pushing a docker image') {
            agent { label 'packer' }
                steps {
                    script {
                        docker.withRegistry(
                            'https://' + env.REGISTRY,
                            'jfrogDockerRegistryCredentials',
                            {
                                build_image = docker.build(env.APP_NAME)
                                build_image.push('development')
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
    }
}