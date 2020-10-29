pipeline {
    agent { dockerfile true }
    stages {
        stage('First stage') {
            steps {
                echo "this is the first step"
                jq --version]
                jq '.build.product' buildConfig.json
            }
        }
        stage('Determine the environment') {
            steps {
                echo "this is the second step"
                jq '.build.product' buildConfig.json | sed -i 's/$environmentdir/release/g' buildConfig.json
                jq '.build.product' buildConfig.json
            }
        }
    }
}