#!/bin/bash
#set -x
printenv
echo $MANIFEST_BRANCH

export MANIFEST_BRANCH=naiad-master-p

repo_sync()
{
    echo $MANIFEST_BRANCH
    echo $CONFIG_FILE
    echo $BUILD
    #MANIFEST_BRANCH=$(jq -r .build.${BUILD}.manifest_branch ${CONFIG_FILE})
    echo $MANIFEST_BRANCH
}

create_version_file()
{
    echo "Creating the version file"
    ./versionnumber.sh ${VERSION_FILE} ${VERSION_MAJOR} ${VERSION_MINOR} ${BUILD_NUMBER} ${VERSION_MODEL} ${LUNCH_BUILD_TYPE}
}

while getopts c:n:rt opt
do
  case $opt in
    c)  # config file
        CONFIG_FILE=$OPTARG
        ;;
    n)  # create version file
        ACTION=create_version_file
        ;;
    r)  # repo sync
        repo_sync
        ;;
    t)
        echo "testing for t"
        ;;
  esac
done