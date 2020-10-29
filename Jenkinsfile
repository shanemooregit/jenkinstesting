pipeline {
    agent {
         docker {
            label 'neon-slave'
            image 'artifacts.navico.com/navico-docker/navico/docker-navico-aosp:latest'
            registryUrl "https://artifacts.navico.com/navico-docker/"
            registryCredentialsId '662c4d1e-f4c7-40da-a07c-5c429b9bec68	'
            alwaysPull true
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