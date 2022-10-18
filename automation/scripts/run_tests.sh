#! /bin/bash

#
# E2E Automation POC
#   
#   Params: $1 =TargetPlatform          'ios' or 'android' (Required)
#           $2 =MobileSourceDirectory   location of mobile projcet source directory (i.e., native-client) (Required),
#           $3 =TestCaseDirectory       location of espresso/xcuitest test case files (Required), 
#           $4 =ProjectID               projectID from Testlodge (Required for Automation), 
#           $5 =PlanID                  planID from Testlodge (Required for Automation),
#           $6 =AutomationType          'auto'(default), 'suite', or 'case' - type of automation used for $7-N parameters (optional for Automation)
#       
#           $7-N =SuiteIDs or CaseIDs   based on AutomationType (optional for Automation)
#
#
#   Defaults: TargetPlatform='android', MobileSourceDirectory='./source', TestCaseDirectory='./tests'
#
#   Use Case 1 - NO PARAMS (Manual Project/Plan Selection - with default platform/folder locations)
#   Use Case 2 - $1 (Manual Project/Plan Selection - with manual mobile source folder location)
#   Use Case 3 - $1, $2 (Manual Project/Plan Selection - with manual mobile source folder location and manual platform selection)
#   Use Case 4 - $1, $2, $3 (Manual Project/Plan Selection - with manal platform/folder locations)
#   Use Case 5 - $1, $2, $3, $4, $5 (Full Automation - all Suites in Plan - with manal platform/folder locations)
#   Use Case 6 - 1, $2, $3, $4, $5, $6, $7, $8, ... (Full Automation - all Suites/Cases in $7-N parameters - with manal platform/folder locations)
#

get_constants() {
    # Import Global Variables from all files in './constants' folder
    for f in ./constants/*; do
        . "$f"
    done

    # Grab Global Variables from Shell Script Parameters
    DIRECTORY_MOBILE_SOURCE="${1:-$DEFAULT_DIRECTORY_MOBILE_SOURCE}"
    TARGET_PLATFORM="${2:-$DEFAULT_TARGET_PLATFORM}"
    DIRECTORY_TEST_CASES="${3:-$DEFAULT_DIRECTORY_TEST_CASES}"

    if [ ! -z "$4" ]
    then
        TESTLODGE_PROJECT_ID=$4
    fi

    if [ ! -z "$5" ]
    then
        TESTLODGE_PLAN_ID=$5
        AUTOMATION_TYPE='auto'  # minimum required parameters for Full Automation!!!
    fi

    if [ ! -z "$6" ]
    then
        if [[ "$6" -eq 'case' || "$6" -eq 'suite' ]]
        then
            AUTOMATION_TYPE=$6  # want to only run specific suites or cases with IDs provided
            AUTOMATION_IDS=${@:7}
        fi
    fi
}

remove_generated_files() {
    rm -rf $PATH_OUTPUT_ROOT
}

remove_old_test_files() {
    if [[ $TARGET_PLATFORM == 'android' ]]
    then
        rm -rf $DIRECTORY_MOBILE_SOURCE/$TARGET_PLATFORM/$PATH_ANDROID_PACKAGE_FOLDER/TLS*.$EXTENSION
    fi
}

remove_old_files() {
    remove_generated_files
    remove_old_test_files
}

check_dependencies() {
    OUTPUT=$("$MODULE_CHECK_DEPENDENCIES" $DIRECTORY_MOBILE_SOURCE $DIRECTORY_TEST_CASES)
    echo $OUTPUT
}

determine_use_case() {
    if [[ $AUTOMATION_TYPE == 'manual' ]]
    then
        sh $MODULE_USER_INPUT $USER_EMAIL $USER_API_KEY $TESTLODGE_ACCOUNT_ID
        OUTPUT=( $(tail -n 1 $FILE_USER_INPUT) )
        TESTLODGE_PROJECT_ID="${OUTPUT[0]}"
        TESTLODGE_PLAN_ID="${OUTPUT[1]}"
        AUTOMATION_TYPE='auto'
    fi

    sh $MODULE_GENERATE_CASES $DIRECTORY_TEST_CASES $AUTOMATION_TYPE $USER_EMAIL $USER_API_KEY $TESTLODGE_ACCOUNT_ID $TESTLODGE_PROJECT_ID $TESTLODGE_PLAN_ID $AUTOMATION_IDS
}

copy_test_files() {    
     sh $MODULE_COPY_TEST_FILES $DIRECTORY_MOBILE_SOURCE $TARGET_PLATFORM $DIRECTORY_TEST_CASES
}

run_platform_tests() {
    # OUTPUT=$($MODULE_RUN_PLATFORM_TESTS $DIRECTORY_MOBILE_SOURCE $TARGET_PLATFORM)
    # echo $OUTPUT
    bash $MODULE_RUN_PLATFORM_TESTS $DIRECTORY_MOBILE_SOURCE $TARGET_PLATFORM
}

parse_platform_test_results() {
    sh $MODULE_PARSE_PLATFORM_TEST_RESULTS $DIRECTORY_MOBILE_SOURCE $TARGET_PLATFORM
}

report_test_results() {
    OUTPUT=$($MODULE_REPORT_TEST_RESULTS $DIRECTORY_MOBILE_SOURCE $TARGET_PLATFORM $TESTLODGE_ACCOUNT_ID $TESTLODGE_PROJECT_ID $TESTLODGE_PLAN_ID)
    echo $OUTPUT
}



# Begin Execution Logic

# DEBUGGING ONLY
# echo "Number of inputs is $(($#))"
# for i in $@; do
#     echo "$i"
# done

# set -e  # exit on any command fail (ignore for test runners as failed tests would register as failed command)

get_constants $@

remove_old_files
check_dependencies
determine_use_case
copy_test_files
run_platform_tests
parse_platform_test_results
report_test_results