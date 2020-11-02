pipeline {
    agent { dockerfile true }
    parameters { 
        choice(name: 'BUILD_TARGET', choices: [ 'Apple', 'Banana', 'Orange'], description: 'Select a device to build, this is the name of the build option in buildConfig.json')  // first choice is default
        choice(name: 'BUILD_TYPE', choices: ['cln', 'inc'], description: 'Choose either a clean or incremental build, clean is the default')
    }
    environment {
        ENVIRONMENT_BUILD = "EMPTY_BUILD"
        BUILD_TARGET_LIST = 'Cat,Dog,Parrot,Bear'
    }

    stages {
        stage('Run only on master and develop') {
            when {
                anyOf {
                    branch 'main';
                    branch 'develop'
                }
            }
            stages {
                stage("Set build name") {
                    steps {
                        script {
                            for(int i=0; i<BUILD_TARGET_LIST.size(); i++) {
                                echo "${BUILD_TARGET_LIST}"
                            }
                            currentBuild.displayName = "${params.BUILD_TARGET} #${BUILD_NUMBER}"
                            currentBuild.description = "${params.BUILD_TARGET}-#${BUILD_NUMBER}-${params.BUILD_TYPE}"
                        }
                    }
                }
                stage('Check and setup variables') {
                    steps {
                        echo "My branch name is ${BRANCH_NAME}"
                        echo "My environment build is ${ENVIRONMENT_BUILD}"
                        sh "pwd"
                        sh "ls -lah"
                        script {
                            if ( env.BRANCH_NAME == 'main'){
                                ENVIRONMENT_BUILD = 'release'
                            } else if ("${BRANCH_NAME}" == 'develop'){
                                ENVIRONMENT_BUILD = 'staging'
                            }
                        }
                        echo "My branch name is now ${BRANCH_NAME}"
                        echo "My environment build is ${ENVIRONMENT_BUILD}"
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
                        //echo "this is the second step"
                        sh label: "look at buildconfig",
                            script: """
                                jq '.build.product' buildConfig.json | sed -i "s/environmentdir/$ENVIRONMENT_BUILD/g" buildConfig.json
                                jq '.build.product' buildConfig.json
                            """
                    }
                }
            }
        }
    }
}