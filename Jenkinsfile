pipeline {
    agent { dockerfile true }
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