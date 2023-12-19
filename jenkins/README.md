# Jenkins in kubernetes
Plugin website: https://plugins.jenkins.io/kubernetes/
Tutorial: https://www.youtube.com/watch?v=vMlUVDcriww&t=29s

## steps
1. install kubernetes plugin in Manage Jenkins > Plugins
1. in Manage Setting create Cloud(with name kubernetes)
1. create pod template(with name kaniko-pod-template)
    1. labels - kaniko-pod
    1. create first container - kaniko-container
        1. name - kaniko-container
        1. docker image - gcr.io/kaniko-project/executor:v1.7.0-debug
        1. Command to run - /busybox/sleep
        1. Arguments to pass to the command - infinity
        1. Allocate pseudo-TTY - checked
    1. create second container - git-container
        1. name - git-container
        1. Command to run - sleep
        1. Arguments to pass to the command - 99999
1. create global env variable for docker registry endpoint
    1. Manage Jenkins > System > Environment variables
    1. name:DOCKER_REGISTRY_URL value:docker-registry.docker-registry.svc.cluster.local:5000
2. create credentials jenkins-kubernetes-credentials of type Username with password
2. create credentials docker-registry-credentials of type Username with password
    - docker registry credentials defined in docker-registry/base/volumes.yaml -> secrets.htpasswd
example plipeline:
```Groovy
pipeline {
  agent {
    kubernetes {
        inheritFrom 'kaniko-pod-template'
    }
  }
  stages {
      stage('Checkout') { 
        steps {
            container('git-container') {
                checkout(
                    [$class: 'GitSCM', 
                    branches: [[name: '*/main']], 
                    doGenerateSubmoduleConfigurations: false, 
                    extensions: [[$class: 'CleanBeforeCheckout']], 
                    submoduleCfg: [], 
                    userRemoteConfigs: [[url: 'https://github.com/demo125/mlops-platform.git']]]
                )
            }
        }
    }
    stage('build image') {
      steps {
        container('kaniko-container') {
            sh 'ls -la'
            sh "mkdir -p /kaniko/.docker"
            withCredentials([usernamePassword(credentialsId: 'docker-registry-credentials', passwordVariable: 'PASSWORD', usernameVariable: 'USER')]) {
                sh "echo '{\"auths\":{\"$DOCKER_REGISTRY_URL\":{\"username\":\"$USER\",\"password\":\"$PASSWORD\"}}}' > /kaniko/.docker/config.json"
                sh 'cat /kaniko/.docker/config.json'
                sh 'executor --context=dir://example-app --dockerfile Dockerfile --destination $DOCKER_REGISTRY_URL/$JOB_BASE_NAME:$BUILD_NUMBER'
            }
            
        }
      }
    }
  }
}

```

