pipeline {
    agent any
    stages {
        stage('First stage') {
            steps {
                echo "this is the first step"
                jq '.' buildConfig.json
            }
        }
        stage('Second stage') {
            steps {
                echo "this is the second step"
            }
        }
    }
}