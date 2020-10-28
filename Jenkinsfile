pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile'
            dir '.'
            registryUrl "https://hub.docker.com"
            registryCredentialsId 'dockershanem'
        }
        }
    stages {
        stage('First stage') {
            steps {
                echo "this is the first step"
                //jq --version
            }
        }
        stage('Second stage') {
            steps {
                echo "this is the second step"
            }
        }
    }
}