#! /bin/bash

##### CONSTANTS ##### 
CASE_FAILURE=0
CASE_PASSED=1
CASE_SKIPPED=2

# Script Dependancies
OUTPUT_ROOT=$(pwd)/generated
LOG_OUTPUT_PATH=$OUTPUT_ROOT/logs
LOG_CASES_PATH=$LOG_OUTPUT_PATH/cases.log
LOG_XCUITEST_PATH=$LOG_OUTPUT_PATH/xcuitest.log
XCUITEST_REPORT_PATH="./TEST_Pixel_6_Pro.xml"

get_cases_from_intermediate() {
    input=$LOG_CASES_PATH
    while IFS= read -r line
    do
        # echo "$line"
        CASE=( $line )

        SUITE_ID=${CASE[3]}
        CASE_ID=${CASE[4]}
        CASE_NAME=${CASE[5]}
        
        get_case_status ${CASE[5]}

        if [ -d "$LOG_OUTPUT_PATH" ]
        then
            echo ${CASE[@]} $CASE_STATUS >>$LOG_XCUITEST_PATH
        fi

    done < "$input"
}

get_case_status() {
    # XPATH_PARSING_STRING='/descendant::testcase[@name="REPLACE_ID"]'
    # CASE_OUTPUT=$(xpath -q -e "${XPATH_PARSING_STRING/REPLACE_ID/$1}" $ESPRESSO_REPORT_PATH)

    XPATH_PRESENT_PARSING_STRING='boolean(testsuite/testcase[@name="REPLACE_ID"])'
    CASE_PRESENT=$(xpath -q -e "${XPATH_PRESENT_PARSING_STRING/REPLACE_ID/$1}" $ESPRESSO_REPORT_PATH)

    CASE_STATUS=$CASE_SKIPPED

    if [[ "$CASE_PRESENT" == 1 ]]; then
        XPATH_FAILURE_PARSING_STRING='boolean(testsuite/testcase[@name="REPLACE_ID"]/failure)'
        CASE_FAILED=$(xpath -q -e "${XPATH_FAILURE_PARSING_STRING/REPLACE_ID/$1}" $ESPRESSO_REPORT_PATH)

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

parse