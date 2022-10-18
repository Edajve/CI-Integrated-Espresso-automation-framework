#! /bin/bash

get_constants() {
    # Import Global Variables from all files in './constants' folder
    for f in ./constants/*; do
        . "$f"
    done
}

os_command_check() {
    if ! command -v curl &> /dev/null
    then
        echo -e "\033[1;31mSCRIPT FAILURE - No curl command found!!! Install curl and rerun script!\033[0m\n" 
        exit 1
    fi

    if ! command -v jq &> /dev/null
    then
         echo -e "\033[1;31mSCRIPT FAILURE - No jq command found!!! Install jq and rerun script!\033[0m\n"
         exit 1 
    fi
}

os_folder_check() {
    for i in $@; do
        if [ ! -d "$i" ]
        then
            echo -e "\033[1;31mSCRIPT FAILURE - No directory found at $i!\033[0m\n"
            exit 1 
        fi 
    done
}

os_generate_output_folders() {
    for i in $@; do
        if [ ! -d "$i" ]
        then
            mkdir $i
        fi 
    done
}

# Begin Execution Logic

# DEBUGGING ONLY
# echo "Number of inputs is $(($#))"
# for i in $@; do
#     echo "$i"
# done

get_constants $@
os_command_check
os_folder_check ${@:1:2}
os_generate_output_folders $PATH_OUTPUT_ROOT $PATH_ANDROID_OUTPUT $PATH_IOS_OUTPUT $PATH_LOG_OUTPUT