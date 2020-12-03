pipeline {
    agent { dockerfile true }
    parameters { 
        choice(name: 'BUILD_TARGET', choices: [ 'Banana', 'Apple', 'Orange'], description: 'Select a device to build, this is the name of the build option in buildConfig.json')  // first choice is default
        choice(name: 'BUILD_TYPE', choices: ['cln', 'inc'], description: 'Choose either a clean or incremental build, clean is the default')
    }
    environment {
        ENVIRONMENT_BUILD = "EMPTY_BUILD"
        VERSION_FILE = "blank"
        VERSION_MODEL = "TBCMODEL"
        VERSION_MAJOR = "1"
        VERSION_MINOR = "0"
        VERSION_NUMBER = "${BUILD_NUMBER}"
        VERSION_BUILDTYPE = ""
        LUNCH_BUILD_TYPE = "user"
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
                            currentBuild.displayName = "${params.BUILD_TARGET} #${BUILD_NUMBER}"
                            currentBuild.description = "${params.BUILD_TARGET}-#${BUILD_NUMBER}-${params.BUILD_TYPE}"
                        }
                    }
                }
                stage('Check and setup variables') {
                    steps {
                        echo "My branch name is ${BRANCH_NAME}"
                        echo "My environment build is ${ENVIRONMENT_BUILD}"
                        echo "My Build is ${BUILD_TARGET}"
                        echo "My type is ${BUILD_TYPE}"
                        sh "pwd"
                        sh "ls -lah"
                        script {
                            if ( env.BRANCH_NAME == 'main'){
                                ENVIRONMENT_BUILD = 'release'
                            } else if ("${BRANCH_NAME}" == 'develop'){
                                ENVIRONMENT_BUILD = 'staging'
                            }

                            if (( params.BUILD_TARGET == "Apple" ) || ( params.BUILD_TARGET == "Banana" )) {
                                env.VERSION_MODEL = 'NAIAD'
                            } else if (( params.BUILD_TARGET == "Orange" ) || ( params.BUILD_TARGET == "hubble_factory" )) {
                                env.VERSION_MODEL = 'Hubble'
                            }
                        }
                        echo "My branch name is now ${BRANCH_NAME}"
                        echo "My environment build is ${ENVIRONMENT_BUILD}"
                        echo "My version model is now ${VERSION_MODEL}"
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
                stage('Replacement buildconfig variables') {
                    steps {
                        sh label: "check versions",
                            script: """
                                jq --version
                                jq '.build.product' buildConfig.json | sed -i "s/ENVIRONMENT_BUILD/$ENVIRONMENT_BUILD/g" buildConfig.json
                            """
                    }
                }
                stage('Check the environment for change') {
                    steps {
                        //echo "this is the second step"
                        sh label: "look at buildconfig",
                            script: """
                                jq '.build.product' buildConfig.json
                            """
                    }
                }
                stage('Do the versioning numbering stuff') {
                    steps {
                        sh  label: "Create Version File",
                            script: """
                                ./versionnumber.sh ${VERSION_FILE} ${VERSION_MAJOR} ${VERSION_MINOR} ${BUILD_NUMBER} ${VERSION_MODEL} ${LUNCH_BUILD_TYPE}
                            """
                    }
                }
            }
        }
    }
}