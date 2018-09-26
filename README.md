# git-docker
docker container that deals with git

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
