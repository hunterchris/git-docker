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
        stage('Build, Push & Promote') {
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
        }
    }
