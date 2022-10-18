#! /bin/bash

# Copy generated test files to platform specific project folder(s)

get_constants() {
    # Import Global Variables from all files in './constants' folder
    for f in ./constants/*; do
        . "$f"
    done

    DIRECTORY_MOBILE_SOURCE=$1
    TARGET_PLATFORM=$2
    DIRECTORY_TEST_CASES=$3
}

copy_android() {
    cp $PATH_OUTPUT_ROOT/$TARGET_PLATFORM/* $DIRECTORY_MOBILE_SOURCE/$TARGET_PLATFORM/$PATH_ANDROID_PACKAGE_FOLDER
}

copy_ios() {
    echo "copying ios files..."
}

copy_test_files() {
    if [[ $TARGET_PLATFORM == 'android' ]]
    then
        copy_android
    fi

    if [[ $TARGET_PLATFORM == 'ios' ]]
    then
        copy_ios
    fi
}

# Begin Execution Logic

# DEBUGGING ONLY
# echo "Number of inputs is $(($#))"
# for i in $@; do
#     echo "$i"
# done

get_constants $@
copy_test_files