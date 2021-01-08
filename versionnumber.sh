#!/bin/bash 
set -x
printenv

echo "\033[32m Green \033[0m"
	if [ "$2" != "" ]; then
		MAJOR_NUM=$2
	else
		#By default assume its Pre-release
		MAJOR_NUM="0"
	fi

	#Minor Number based on manifest branch
	if [ "$3" != "" ]; then
		MINOR_NUM=$3
	else
		#By default assume its 0
		MINOR_NUM="0"
	fi


	#Jenkins incremental build Number
	if [ "$4" != "" ]; then
		IN_JENKINS_BUILD_NUMBER=$4
	fi

	#Model of the build
	if [ "$5" != "" ]; then
		IN_BUILD_TARGET=$5
	else
		IN_BUILD_TARGET="NSX"
	fi

	#Build type(User or Userdebug or eng)
	if [ "$6" != "" ]; then
		BUILD_TYPE=$6
	else
		#By default assume its a developer build
		BUILD_TYPE="userdebug"
	fi

    # BuildType 1 -> User build, 2 -> Userdebug build
if [ $BUILD_TYPE == "user" ]; then
	BUILD_TYPE_NUM=0
elif [ $BUILD_TYPE == "userdebug" ]; then
	BUILD_TYPE_NUM=1
fi

# Create the overall version string
# Format the version string based on jenkins build number & check if it is number or not
if [ ! -z $IN_JENKINS_BUILD_NUMBER ] && [ "$IN_JENKINS_BUILD_NUMBER" -eq "$IN_JENKINS_BUILD_NUMBER" ] 2>/dev/null; then
    AOSP_BUILD_NUMBER="$IN_BUILD_TARGET-$MAJOR_NUM.$MINOR_NUM.$BUILD_TYPE_NUM.$IN_JENKINS_BUILD_NUMBER-$COMMIT_ID"
else
    AOSP_BUILD_NUMBER="$MAJOR_NUM.$MINOR_NUM.$PATCH_NUM.0"
fi

echo $AOSP_BUILD_NUMBER