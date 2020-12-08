#!/bin/bash
set -xeo pipefail
printenv
export MANIFEST_BRANCH=naiad-master-p

repo_sync()
{
    echo $MANIFEST_BRANCH
    echo $CONFIG_FILE
    MANIFEST_BRANCH=$(jq -r .build.${BUILD}.manifest_branch ${CONFIG_FILE})
    echo $MANIFEST_BRANCH
}

create_version_file()
{
    echo "Creating the version file"
    ./versionnumber.sh ${VERSION_FILE} ${VERSION_MAJOR} ${VERSION_MINOR} ${BUILD_NUMBER} ${VERSION_MODEL} ${LUNCH_BUILD_TYPE}
}

while getopts c:l:b:t:freaizvnpswkd opt; do
  case $opt in
    c)  # config file
        CONFIG_FILE=$OPTARG
        ;;
    n)  # create version file
        ACTION=create_version_file
        ;;
    r)  # repo sync
        ACTION=repo_sync
        ;;
    h)
      help
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      help
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      help
      exit 1
      ;;
  esac
done