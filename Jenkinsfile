pipeline {
    agent {
        label 'slave'
        //label 'docker-agent'
        // dockerfile true
    }
    parameters { 
        choice(name: 'BUILD_TARGET', choices: [ 'Banana', 'Apple', 'Orange'], description: 'Select a device to build, this is the name of the build option in buildConfig.json')  // first choice is default
        choice(name: 'BUILD_TYPE', choices: ['cln', 'inc'], description: 'Choose either a clean or incremental build, clean is the default')
    }
    environment {
        ENVIRONMENT_BUILD = "EMPTY_BUILD"
        VERSION_FILE = "version.txt"
        VERSION_MAJOR = "1"
        VERSION_MINOR = "0"
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
                stage('Set the build agent') {
                    //agent { 
                    //    docker {
                    //        label 'docker-agent'
                    //        image 'artifacts.navico.com/navico-docker/navico/docker-navico-aosp:latest'
                    //        alwaysPull true
                    //        reuseNode true
                            // As the Agent is already a container the docker plugin adds the "--volumes-from <my-container id> so that the 
                            // workspace is shared to side containers.
                            //args "-u root:root  -v ${env.JENKINS_BUILD_DIR}:${env.JENKINS_BUILD_DIR} --privileged=true"
                    //    }
                    //}
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
                                    if ( BRANCH_NAME == 'master') {
                                        ENVIRONMENT_BUILD = 'release'
                                    } else if ( BRANCH_NAME == 'develop') {
                                        ENVIRONMENT_BUILD = 'staging'
                                    }
                                    echo "Build is running from the branch ${BRANCH_NAME}"
                                    echo "My environment build is set to ${ENVIRONMENT_BUILD}"

                                // if (( params.BUILD_TARGET == "Apple" ) || ( params.BUILD_TARGET == "Banana" )){
                                //     VERSION_MODEL = 'NSX'
                                    //} else if (( params.BUILD_TARGET == "Orange" ) || ( params.BUILD_TARGET == "anything" )){
                                    //    VERSION_MODEL = 'Nemesis'
                                    //}
                                    sleep 5
                                }
                                echo "My branch name is now ${BRANCH_NAME}"
                                echo "My environment build is ${ENVIRONMENT_BUILD}"
                                //echo "My version model is now ${VERSION_MODEL}"
                                
                            }
                        }
                        stage('JSON file testing') {
                            steps {
                                echo "Doing some testing"
                                script {
                                    def jsonObj = readJSON file: './buildConfig.json'
                                    print jsonObj

                                    // set device name
                                    env.DEVICE = jsonObj['build'][params.BUILD_TARGET]['device']
                                    echo "device is ${DEVICE}"
                                    // set manifest branch
                                    //env.MANIFEST_BRANCH = jsonObj['build'][params.BUILD_TARGET]['manifest_branch']
                                    //echo "manifest branch is ${MANIFEST_BRANCH}"
                                    // Set burn-in OTA file name
                                    env.BURNING_OTA_NAME = jsonObj['build'][params.BUILD_TARGET]['burning_OTA_name']
                                    echo "burning ota name is ${BURNING_OTA_NAME}"
                                    // Version Model
                                    env.VERSION_MODEL = jsonObj['build'][params.BUILD_TARGET]['versionModel']
                                    echo "My version model is now ${VERSION_MODEL}"

                                    env.BUILD = "${BUILD_TARGET}"
                                    echo "My bulld is now ${BUILD}"
                                    echo "My environment build is ${ENVIRONMENT_BUILD}"
                                    sh "jq --version"
                                }
                            }
                        }
                        stage('Zip file testing') {
                            steps {
                                echo "zip file testing with flasher env"
                                sh label: "zip testy",
                                    script: """
                                        pwd
                                        ls -lah
                                    """
                            }
                        }
                        stage('Replacement buildconfig variables') {
                            steps {
                                sh label: "check versions",
                                    script: '''#! /bin/bash
                                        set -xeu
                                        ls -lah
                                        pwd
                                        jq '.build' buildConfig.json
                                        echo "$ENVIRONMENT_BUILD"
                                        jq --version
                                        jq '.build' buildConfig.json | sed -i "s/ENVIRONMENT_BUILD/$ENVIRONMENT_BUILD/g" buildConfig.json
                                    '''
                            }
                        }
                        stage('Check the environment for change') {
                            steps {
                                //echo "this is the second step"
                                sh label: "look at buildconfig",
                                    script: """
                                        jq '.build' buildConfig.json
                                    """
                            }
                        }
                        stage('BuildAOSP - Versioning') {
                            steps {
                                sh  label: "Create Version File",
                                    script: """
                                        ./buildAOSP.sh -c buildConfig.json -n
                                    """
                            }
                        }
                        stage('BuildAOSP - Repo Sync') {
                            steps {
                                sh  label: "Check repo sync and manifest",
                                    script: """
                                        ./buildAOSP.sh -c buildConfig.json -r
                                    """
                            }
                        }
                    }
                }
            }
        }
    }
}