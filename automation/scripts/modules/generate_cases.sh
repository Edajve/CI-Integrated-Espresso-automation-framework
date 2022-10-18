#! /bin/bash

# Generate Listing of Relevant TestLodge Cases tied to TestLodge Plan/Suites/Sections
#
#   Params: 

get_constants() {
    # Import Global Variables from all files in './constants' folder
    for f in ./constants/*; do
        . "$f"
    done

    # Grab Global Variables from Shell Script Parameters
    DIRECTORY_TEST_CASES=$1
    AUTOMATION_TYPE=$2
    USER_EMAIL=$3
    USER_API_KEY=$4 
    TESTLODGE_ACCOUNT_ID=$5 
    TESTLODGE_PROJECT_ID=$6 
    TESTLODGE_PLAN_ID=$7 
    AUTOMATION_IDS=$8
}

fetch_cases() {
    SUITE_ID=${@:1:1}
    SECTION_IDS=${@:2}

    # [0 -> N] = Test Cases attached to SectionsId
    CASE_IDS=()

    REQUEST_URL=${API_QUERIES[3]/ACCOUNT_ID/"$TESTLODGE_ACCOUNT_ID"}
    REQUEST_URL=${REQUEST_URL/PROJECT_ID/"$TESTLODGE_PROJECT_ID"}
    REQUEST_URL=${REQUEST_URL/SUITE_ID/$SUITE_ID}

    for i in ${SECTION_IDS[@]}; do
            TEST_CASE_URL=${REQUEST_URL/SUITE_SECTION_ID/$i}
            # echo $TEST_CASE_URL

            # API Calls
            LOG_CASE_IDS=( $("$MODULE_API_FETCH" $USER_EMAIL $USER_API_KEY $TEST_CASE_URL ${JSON_DATA_KEYS[5]}) )
            OUTPUT=$("$MODULE_API_FETCH" $USER_EMAIL $USER_API_KEY $TEST_CASE_URL ${JSON_DATA_KEYS[4]})

            # Data Transforms
            LOG_CASE_NAMES=( $OUTPUT )
            CASE_IDS+=( $OUTPUT )

            # Logging (for reporting - SuiteID, CaseID, CaseName)
            NUM_OF_CASES=${#LOG_CASE_IDS[@]}
            for i in $(seq 0 $((NUM_OF_CASES-1))); do
                CLEAN_TEST_NAME=$(echo "${LOG_CASE_NAMES[$i]}" | sed "s/\"//g")    # Remove "" around Test Case Name/ID
                $("$MODULE_LOG" $FILE_LOG_CASES $TESTLODGE_ACCOUNT_ID $TESTLODGE_PROJECT_ID $TESTLODGE_PLAN_ID $SUITE_ID "${LOG_CASE_IDS[$i]}" $CLEAN_TEST_NAME)
            done  
    done

    sh $MODULE_GENERATE_TEST_FILES $DIRECTORY_TEST_CASES $SUITE_ID ${CASE_IDS[@]}
}

fetch_suite_sections() {
    API_REQUEST_URL=${API_QUERIES[2]/ACCOUNT_ID/"$TESTLODGE_ACCOUNT_ID"}
    API_REQUEST_URL=${API_REQUEST_URL/PROJECT_ID/"$TESTLODGE_PROJECT_ID"}

    # [0 -> N] = Test Suites Sections attached to SuitesIds above
    SUITE_SECTION_IDS=()

    SUITE_REQUEST_URL=${API_REQUEST_URL/SUITE_ID/$1}

    # echo $SUITE_REQUEST_URL

    SUITE_SECTION_IDS=$("$MODULE_API_FETCH" $USER_EMAIL $USER_API_KEY $SUITE_REQUEST_URL ${JSON_DATA_KEYS[3]})
    fetch_cases $1 ${SUITE_SECTION_IDS[@]}
}

fetch_suites() {
    API_REQUEST_URL=${API_QUERIES[1]/ACCOUNT_ID/"$TESTLODGE_ACCOUNT_ID"}
    API_REQUEST_URL=${API_REQUEST_URL/PROJECT_ID/"$TESTLODGE_PROJECT_ID"}
    API_REQUEST_URL=${API_REQUEST_URL/plans.json/suites.json}

    # echo $API_REQUEST_URL

    SELECTED_PLAN_ID=$TESTLODGE_PLAN_ID
    SUITE_IDS=$("$MODULE_API_FETCH" $USER_EMAIL $USER_API_KEY $API_REQUEST_URL "${JSON_DATA_KEYS[2]/REPLACE_ID/$SELECTED_PLAN_ID}")

    for i in ${SUITE_IDS[@]}; do
        fetch_suite_sections $i
    done
    # fetch_suite_sections
}


# Begin Execution Logic

# DEBUGGING ONLY
# echo "Number of inputs is $(($#))"
# for i in $@; do
#     echo "$i"
# done

get_constants $@
fetch_suites