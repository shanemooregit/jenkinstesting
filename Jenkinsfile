pipeline {
    agent {
         docker {
             dir '.'
             args '-v /var/run/docker.sock:/var/run/docker.sock'
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