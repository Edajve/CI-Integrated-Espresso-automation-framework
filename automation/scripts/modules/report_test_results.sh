#! /bin/bash

get_constants() {
    # Import Global Variables from all files in './constants' folder
    for f in ./constants/*; do
        . "$f"
    done

    DIRECTORY_MOBILE_SOURCE=$1
    TARGET_PLATFORM=$2
    ACCOUNT_ID=$3
    PROJECT_ID=$4
    PLAN_ID=$5
}

get_suites() {
    if [[ $TARGET_PLATFORM == 'android' ]]
    then
        FILE_RESULTS=$FILE_ESPRESSO_RESULTS
    else
        FILE_RESULTS=$FILE_XCUITEST_RESULTS
    fi

    SUITES_RUN=()
    while IFS= read -r RESULTS_LINE
    do
        # echo "$RESULTS_LINE"
        CASE=( $RESULTS_LINE )
        if [[ ! " ${SUITES_RUN[*]} " =~ " ${CASE[3]} " ]]; then
            SUITES_RUN[${#SUITES_RUN[@]}]="${CASE[3]}"
        fi
    done < "$FILE_RESULTS"

    printf -v SUITES_FOR_JSON ',%s' "${SUITES_RUN[@]}"
    SUITES_FOR_JSON=${SUITES_FOR_JSON:1}
    # echo $SUITES_FOR_JSON
}

start_run() {
    TIMESTAMP=`date +%Y-%m-%d_%H-%M-%S`
    RUN_NAME="$TARGET_PLATFORM@$TIMESTAMP"

    REQUEST_URL=${API_QUERIES[4]/REPLACE_ACCOUNT_ID/"$ACCOUNT_ID"}
    REQUEST_URL=${REQUEST_URL/REPLACE_PROJECT_ID/"$PROJECT_ID"}
    IFS=,
    SUITES_TO_REPLACE=$SUITES_FOR_JSON
    IFS=" "
    JSON_RAW_STRING='{"name":"REPLACE_RUN_NAME","plan_id":REPLACE_PLAN_ID,"suite_ids":[REPLACE_SUITE_IDS]}'
    JSON_WITH_RUN_NAME="${JSON_RAW_STRING/REPLACE_RUN_NAME/$RUN_NAME}"
    JSON_WITH_PLAN="${JSON_WITH_RUN_NAME/REPLACE_PLAN_ID/$PLAN_ID}"
    JSON_WITH_SUITES="${JSON_WITH_PLAN/REPLACE_SUITE_IDS/$SUITES_TO_REPLACE}"
    echo $JSON_WITH_SUITES
    echo $REQUEST_URL
    RUN_ID=$(curl -u ${USER_EMAIL}:${USER_API_KEY} -d $JSON_WITH_SUITES -H "Content-Type: application/json" -X POST ${REQUEST_URL}  | jq  '.id')
    echo $RUN_ID

    # curl -d "@./generated/json/run.json" -X POST http://localhost:3000/data
}

map_run_ids() {
    REQUEST_URL=${API_QUERIES[6]/REPLACE_ACCOUNT_ID/"$ACCOUNT_ID"}
    REQUEST_URL=${REQUEST_URL/REPLACE_PROJECT_ID/"$PROJECT_ID"}
    REQUEST_URL=${REQUEST_URL/REPLACE_RUN_ID/"$RUN_ID"}

    # echo $REQUEST_URL

    RUN_CASE_IDS=$("$MODULE_API_FETCH" $USER_EMAIL $USER_API_KEY $REQUEST_URL '.executed_steps[] | .step_number + ":::" + (.id|tostring)')

    # echo $RUN_CASE_IDS

    IFS=" "

    for i in ${RUN_CASE_IDS[@]}; do
        MAP_ENTRY=$(echo "$i" | sed "s/\"//g")
        IFS="::: "
        while IFS=":::" read -r CLEAN_MAP_ENTRY
        do
            # echo ${CLEAN_MAP_ENTRY[0]}
            echo ${CLEAN_MAP_ENTRY[@]} >>$FILE_RUN_MAPPING
        done <<< $MAP_ENTRY    
    done

    IFS=" "
}

converge_data() {
    if [[ $TARGET_PLATFORM == 'android' ]]
    then
        FILE_RESULTS=$FILE_ESPRESSO_RESULTS
    else
        FILE_RESULTS=$FILE_XCUITEST_RESULTS
    fi

    while IFS= read -r CONVERGE_LINE
    do
        # echo "$CONVERGE_LINE"
        RESULT_CASE=( $CONVERGE_LINE )
        RESULT_CASE_NAME=${RESULT_CASE[5]}

        while IFS= read -r RAW_MAPPING_LINE
        do
            # echo "$RAW_MAPPING_LINE"
            MAPPING_CASE=( $RAW_MAPPING_LINE )
            MAPPING_CASE_NAME=${MAPPING_CASE[0]}
            MAPPING_CASE_ID=${MAPPING_CASE[1]}

            if [[ "$RESULT_CASE_NAME" == "$MAPPING_CASE_NAME" ]]; then
                echo ${CONVERGE_LINE[@]} $MAPPING_CASE_ID >>$FILE_CONVERGED_DATA
            fi
        done < "$FILE_RUN_MAPPING"
    done < "$FILE_RESULTS"
}

report_results_from_platform() {
    while IFS= read -r line
    do
        # echo "$line"
        CASE=( $line )

        ACCOUNT_ID=${CASE[0]}
        PROJECT_ID=${CASE[1]}
        PLAN_ID=${CASE[2]}
        SUITE_ID=${CASE[3]}
        CASE_ID=${CASE[4]}
        CASE_NAME=${CASE[5]}
        CASE_STATUS=${CASE[6]}
        RUN_CASE_ID=${CASE[7]}

        REQUEST_URL=${API_QUERIES[5]/REPLACE_ACCOUNT_ID/"$ACCOUNT_ID"}
        REQUEST_URL=${REQUEST_URL/REPLACE_PROJECT_ID/"$PROJECT_ID"}
        REQUEST_URL=${REQUEST_URL/REPLACE_RUN_ID/"$RUN_ID"}
        REQUEST_URL=${REQUEST_URL/REPLACE_RUN_CASE_ID/"$RUN_CASE_ID"}

        JSON_RAW_STRING='{"executed_step":{"actual_result":"","passed":REPLACE_CASE_STATUS,"create_issue_tracker_ticket":0}}'
        JSON_WITH_STATUS="${JSON_RAW_STRING/REPLACE_CASE_STATUS/$CASE_STATUS}"

        echo $REQUEST_URL
        echo $JSON_WITH_STATUS
        UPDATE_STATUS=$(curl -u ${USER_EMAIL}:${USER_API_KEY} -d $JSON_WITH_STATUS -H "Content-Type: application/json" -X PATCH ${REQUEST_URL})
        # echo $UPDATE_STATUS
    done < "$FILE_CONVERGED_DATA"
}

# Begin Execution Logic

# DEBUGGING ONLY
# echo "Number of inputs is $(($#))"
# for i in $@; do
#     echo "$i"
# done

get_constants $@
get_suites
start_run
map_run_ids
converge_data
report_results_from_platform