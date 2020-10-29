pipeline {
    agent {
        docker { image 'node:14-alpine' }
    }
    stages {
        stage('First stage') {
            steps {
                echo "this is the first step"
                sh 'node --version'
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