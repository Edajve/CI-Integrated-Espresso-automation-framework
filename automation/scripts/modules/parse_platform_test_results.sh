#! /bin/bash

get_constants() {
    # Import Global Variables from all files in './constants' folder
    for f in ./constants/*; do
        . "$f"
    done

    DIRECTORY_MOBILE_SOURCE=$1
    TARGET_PLATFORM=$2
}

parse_results() {
    if [[ $TARGET_PLATFORM == 'android' ]]
    then
        PARSER=$FILE_ESPRESSO_PARSER
        FILES=$(ls $DIRECTORY_MOBILE_SOURCE/$TARGET_PLATFORM/$PATH_ANDROID_TEST_RESULTS_XML_FOLDER)
        for file in "${FILES[@]}"
        do
            echo $file
            sh $PARSER "$DIRECTORY_MOBILE_SOURCE/$TARGET_PLATFORM/$PATH_ANDROID_TEST_RESULTS_XML_FOLDER/$file"
        done
        
    else
        PARSER=$FILE_XCUITEST_PARSER
        FILE_RESULTS=$FILE_XCUITEST_RESULTS
    fi 
}


# Begin Execution Logic

# DEBUGGING ONLY
# echo "Number of inputs is $(($#))"
# for i in $@; do
#     echo "$i"
# done


get_constants $@
parse_results