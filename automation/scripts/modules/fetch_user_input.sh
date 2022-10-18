#! /bin/bash

get_constants() {
    # Import Global Variables from all files in './constants' folder
    for f in ./constants/*; do
        . "$f"
    done

    # Grab Global Variables from Shell Script Parameters
    USER_EMAIL=$1
    USER_API_KEY=$2
    TESTLODGE_ACCOUNT_ID=$3
}

select_from_output() {
    echo "Select from the following IDs:"
    for i in "${OUTPUT[@]}"; do
        echo "$i"
    done
    read -p "Enter ID: " TEMP_ID
    MANUAL_SELECTED_IDS+=( $TEMP_ID )
}

save_to_log() {
    echo ${MANUAL_SELECTED_IDS[@]} >>$FILE_USER_INPUT
}

select_plan() {
    API_REQUEST_URL=${API_QUERIES[1]/ACCOUNT_ID/"$TESTLODGE_ACCOUNT_ID"}
    API_REQUEST_URL=${API_REQUEST_URL/PROJECT_ID/"${MANUAL_SELECTED_IDS[0]}"}

    OUTPUT=$("$MODULE_API_FETCH" $USER_EMAIL $USER_API_KEY $API_REQUEST_URL ${JSON_DATA_KEYS[1]})
    select_from_output

    save_to_log
}

select_project() {
    echo "YO!!!"
    API_REQUEST_URL=${API_QUERIES[0]/ACCOUNT_ID/"$TESTLODGE_ACCOUNT_ID"}

    echo "B:::$API_REQUEST_URL"

    OUTPUT=$("$MODULE_API_FETCH" $USER_EMAIL $USER_API_KEY $API_REQUEST_URL ${JSON_DATA_KEYS[0]})
    select_from_output

    select_plan
}

# Begin Execution Logic

# DEBUGGING ONLY
# echo "Number of inputs is $(($#))"
# for i in $@; do
#     echo "$i"
# done

get_constants $@
select_project