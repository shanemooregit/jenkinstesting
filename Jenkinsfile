pipeline {
    agent { dockerfile true }
    parameters { 
        choice(name: 'BUILD_TARGET', choices: [ 'Apple', 'Banana', 'Orange'], description: 'Select a device to build, this is the name of the build option in buildConfig.json')  // first choice is default
        choice(name: 'ENVIRONMENT_BUILD', choices: [ 'release', 'staging'], description: 'Select your environment to build')
    }
    stages {
        stage('Check variables') {
            steps {
                    echo "My branch name is ${BRANCH_NAME}"
                    echo "My environment build is ${ENVIRONMENT_BUILD}"
                    sh "pwd"
                    sh "ls -lah"
                }
            }
        }
        stage('Setup build configuration') {
            steps {
                echo "build config setup"
                script {
                        sh "jq '.build.product' buildConfig.json"
                }
            }
        }
        stage('First stage') {
            steps {
                echo "this is the first step"
                sh label: "check versions",
                    script: """
                        jq --version
                        jq '.build.product' buildConfig.json
                    """
            }
        }
        stage('Determine the environment') {
            steps {
                echo "this is the second step"
                sh label: "look at buildconfig",
                    script: """
                        jq '.build.product' buildConfig.json | sed -i 's/environmentdir/release/g' buildConfig.json
                        jq '.build.product' buildConfig.json
                    """
            }
        }
    }
}