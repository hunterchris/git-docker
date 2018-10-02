# git-docker
docker container that deals with git. This repository is also used to test the deployment of the jenkins test environment.

# build
```
docker build -t git-docker .
```

# run
In order to run this container you need to provide two values:
- SSH_PRIV_KEY: The private key from the git user
- The volume that contains the git repo to be used

```
docker run --name git-docker -d -v ${PWD}:/git -e SSH_PRIV_KEY=${SSH_PRIV_KEY} git-docker git status
```

# `Jenkins test environment`
The `git-docker` repository contains 
- a simple `docker` container,
- a silly `HelloWorld.java` that uses gradle,
- a silly `hello.js` that uses yarn.
- a `Jenkinsfile` with four stages that tests the credentials injected at deployment time.

#### Test coverage:
-    Validity of [`configureGithubPlugin.groovy.tpl`](https://github.com/medneo/jenkins-infrastructure/blob/developement/stacks/jenkins/files/jenkins-master-image/scripts/configureGithubPlugin.groovy.tpl)
-    Validity of [`configureGithubBranchSourcePlugin.tpl`](https://github.com/medneo/jenkins-infrastructure/blob/developement/stacks/jenkins/files/jenkins-master-image/scripts/configureGithubBranchSourcePlugin.groovy.tpl)
-    Validity of [`configureGlobalPipeline.groovy.tpl`](https://github.com/medneo/jenkins-infrastructure/blob/developement/stacks/jenkins/files/jenkins-master-image/scripts/configureGlobalPipelineLibrary.groovy.tpl)
#
### `stage('Test jFrog access by pushing a docker image)`
#
Here we're testing that the `git-docker` container can be built and pushed to our `jFrog docker registry`, it also checks that the Jenkins master can spawn slaves with label `'packer'`.

#### Test coverage:
-    Validity of [`configureEC2Plugin.groovy.tpl`](https://github.com/medneo/jenkins-infrastructure/blob/developement/stacks/jenkins/files/jenkins-master-image/scripts/configureEc2Plugin.groovy.tpl)
-    Validity of [`configureDockerRegistries.groovy.tpl`](https://github.com/medneo/jenkins-infrastructure/blob/developement/stacks/jenkins/files/jenkins-master-image/scripts/configureDockerRegistries.groovy.tpl)

 
#
### `stage('Test PyPI credentials to get dependencies')`
#
Here we're testing that we can pull an image from `jFrog docker regristry` and that we can access the `jFrog artifact registry` to download python dependencies. It also checks that the Jenkins master can spawn slaves with label `'20GB'`

#### Test coverage:

-    Validity of [`configureEC2Plugin.groovy.tpl`](https://github.com/medneo/jenkins-infrastructure/blob/developement/stacks/jenkins/files/jenkins-master-image/scripts/configureEc2Plugin.groovy.tpl)
-    Validity of [`configurePyPiCreds.groovy.tpl`](https://github.com/medneo/jenkins-infrastructure/blob/developement/stacks/jenkins/files/jenkins-master-image/scripts/configurePyPiCreds.groovy.tpl)
#
### `stage('Test MVN credentials')`
#

Here we're testing that we can access the `jFrog artifact registry` to download Java dependencies. We're also testing that the Jenkins Master can spawn slaves with label `'docker-compose'`

### Test coverage:

-   Validity of [`configureEC2Plugin.groovy.tpl`](https://github.com/medneo/jenkins-infrastructure/blob/developement/stacks/jenkins/files/jenkins-master-image/scripts/configureEc2Plugin.groovy.tpl)
-   Validity of [`configureJFrogMavenRepoAccess.groovy.tpl`](https://github.com/medneo/jenkins-infrastructure/blob/developement/stacks/jenkins/files/jenkins-master-image/scripts/configureJFrogMavenRepoAccess.groovy.tpl)

 
#
### `stage('Test NPM credentials')`
#
Here we're testing that we can access the `jFrog artifact registry` to download Node.js dependencies.

#### Test coverage:

-   Validity of [`configureNPMRegistry.groovy.tpl`](https://github.com/medneo/jenkins-infrastructure/blob/developement/stacks/jenkins/files/jenkins-master-image/scripts/configureNPMRegistry.groovy.tpl)

