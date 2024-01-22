```
curl -LO https://github.com/jetstack/cert-manager/releases/download/v1.13.2/cert-manager.yaml
kubectl apply --validate=false -f cert-manager.yaml
```
https://github.com/ChristianLempa/videos/blob/main/self-signed-certificates-in-kubernetes/README.md

1. Create a Certificate Authority a. Create a CA private key
```
openssl genrsa -out ca.key 4096
```
1. Create a CA certificate
```
openssl req -new -x509 -sha256 -days 365 -key ca.key -out ca.crt
```
1. Import the CA certificate in the trusted Root Ca store of your clients
1. Convert the content of the key and crt to base64 oneline
```
cat ca.crt | base64 -w 0
cat ca.key | base64 -w 0
```
1. put to ca-secret.yaml - use sample
1. use sealed secret without -n option(namespace wide)
```
kubeseal --scope namespace-wide --controller-name sealed-secrets --controller-namespace=sealed-secrets -f ca-secret.yaml -w sealed-ca-secret.yaml 
```