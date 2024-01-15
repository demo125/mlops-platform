List repositories:
```
https://docker-registry.localhost:11443/v2/_catalog
```
List tags of a repositorh:
```
https://docker-registry.localhost:11443/v2/<repo_name>/tags/list
```
Pull:
```
docker pull docker-registry.localhost:11443/<repository>
```
Creating user name and secret:
```
htpasswd -Bc ./htpasswrd <user_name> 
```
then copy the contents of htpasswrd file to values.yaml
```
secrets:
    htpasswd: "<user>:<password_hash>"
```
Push to registry example:
```
docker tag python:3.8.6-slim-buster  docker-registry.localhost:11443/python:latest
docker push docker-registry.localhost:11443/python:latest
```
Pull from registry:
```
docker pull docker-registry.localhost:11443/python:latest
```