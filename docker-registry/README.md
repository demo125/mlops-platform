test the registry
```
https://docker-registry.localhost:11443/v2/_catalog
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