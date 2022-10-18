#! /bin/bash

get_constants() {
    # Import Global Variables from all files in './constants' folder
    for f in ./constants/*; do
        . "$f"
    done

    # ESPRESSO_REPORT_PATH="./mocks/TEST_Pixel_6_Pro.xml"
    ESPRESSO_REPORT_PATH=$@

    echo "ERP: $ESPRESSO_REPORT_PATH"

    ##### TESTLODGE CASE STATUS CONSTANTS ##### 
    CASE_FAILURE=0
    CASE_PASSED=1
    CASE_SKIPPED=2
}

get_cases_from_intermediate() {
    while IFS= read -r line
    do
        # echo "$line"
        CASE=( $line )

        SUITE_ID=${CASE[3]}
        CASE_ID=${CASE[4]}
        CASE_NAME=${CASE[5]}
        
        get_case_status ${CASE[5]}

        echo ${CASE[@]} $CASE_STATUS >>$FILE_ESPRESSO_RESULTS

    done < "$FILE_LOG_CASES"
}

get_case_status() {
    # XPATH_PARSING_STRING='/descendant::testcase[@name="REPLACE_ID"]'
    # CASE_OUTPUT=$(xpath -q -e "${XPATH_PARSING_STRING/REPLACE_ID/$1}" $ESPRESSO_REPORT_PATH)

    XPATH_PRESENT_PARSING_STRING='boolean(testsuite/testcase[@name="REPLACE_ID"])'
    CASE_PRESENT=$(xpath -q -e "${XPATH_PRESENT_PARSING_STRING/REPLACE_ID/$1}" "$ESPRESSO_REPORT_PATH")

    CASE_STATUS=$CASE_SKIPPED

    if [[ "$CASE_PRESENT" == 1 ]]; then
        XPATH_FAILURE_PARSING_STRING='boolean(testsuite/testcase[@name="REPLACE_ID"]/failure)'
        CASE_FAILED=$(xpath -q -e "${XPATH_FAILURE_PARSING_STRING/REPLACE_ID/$1}" "$ESPRESSO_REPORT_PATH")

        if [[ "$CASE_FAILED" == 1 ]]; then
            CASE_STATUS=$CASE_FAILURE
        else
            CASE_STATUS=$CASE_PASSED
        fi
    fi
}

parse() {
    # get_case_status TC234
    get_cases_from_intermediate
}

# Begin Execution Logic

# DEBUGGING ONLY
# echo "Number of inputs is $(($#))"
# for i in $@; do
#     echo "$i"
# done


get_constants $@
parse
