#! /bin/bash

##### FILE/FOLDER PATH CONSTANTS #####

DEFAULT_TARGET_PLATFORM='android'
AUTOMATION_TYPE='manual'

# Folder Paths (absolute)
PATH_BASE=$(pwd)
PATH_CONSTANTS_ROOT="$PATH_BASE/constants"
PATH_MOCKS_ROOT="$PATH_BASE/mocks"
PATH_MODULE_ROOT="$PATH_BASE/modules"
PATH_OUTPUT_ROOT="$PATH_BASE/generated"
PATH_PARSERS_ROOT="$PATH_BASE/parsers"
PATH_TESTS_ROOT="$PATH_BASE/tests"
PATH_ANDROID_OUTPUT="$PATH_OUTPUT_ROOT/android"
PATH_IOS_OUTPUT="$PATH_OUTPUT_ROOT/ios"
PATH_LOG_OUTPUT="$PATH_OUTPUT_ROOT/logs"

# Script Module Dependancies
MODULE_API_FETCH="$PATH_MODULE_ROOT/fetch_api_data.sh"
MODULE_CHECK_DEPENDENCIES="$PATH_MODULE_ROOT/check_dependencies.sh"
MODULE_COPY_TEST_FILES="$PATH_MODULE_ROOT/copy_test_files.sh"
MODULE_GENERATE_CASES="$PATH_MODULE_ROOT/generate_cases.sh"
MODULE_GENERATE_TEST_FILES="$PATH_MODULE_ROOT/generate_test_files.sh"
MODULE_LOG="$PATH_MODULE_ROOT/log.sh"
MODULE_PARSE_PLATFORM_TEST_RESULTS="$PATH_MODULE_ROOT/parse_platform_test_results.sh"
MODULE_REPORT_TEST_RESULTS="$PATH_MODULE_ROOT/report_test_results.sh"
MODULE_RUN_PLATFORM_TESTS="$PATH_MODULE_ROOT/run_platform_tests.sh"
MODULE_USER_INPUT="$PATH_MODULE_ROOT/fetch_user_input.sh"

# Script Parser Dependancies
FILE_ESPRESSO_PARSER="$PATH_PARSERS_ROOT/espresso.sh"
FILE_XCUITEST_PARSER="$PATH_PARSERS_ROOT/xcuitest.sh"

# File Paths
FILE_LOG_CASES=$PATH_LOG_OUTPUT/cases.log
FILE_USER_INPUT=$PATH_LOG_OUTPUT/user_input.log
FILE_RUN_MAPPING=$PATH_LOG_OUTPUT/run_mapping.log
FILE_ESPRESSO_RESULTS=$PATH_LOG_OUTPUT/espresso.log
FILE_XCUITEST_RESULTS=$PATH_LOG_OUTPUT/xcuitest.log
FILE_CONVERGED_DATA=$PATH_LOG_OUTPUT/converged_data.log

# State Default Paths
DEFAULT_DIRECTORY_TEST_CASES="$PATH_BASE/tests"
DEFAULT_DIRECTORY_MOBILE_SOURCE="$PATH_BASE/source"

# Added to Class name (since class name can't be number in Java and "Test" needed for test runners)
PREPEND_LABEL_SUITE="TLS"
APPEND_LABEL_SUITE="Test"

PATH_ANDROID_PACKAGE_FOLDER="app/src/androidTest/java/com/fubo/sportsbook/v3"
PATH_ANDROID_TEST_RESULTS_XML_FOLDER="app/build/outputs/androidTest-results/connected"

COMMAND_PATH_ADB="$HOME/Library/Android/sdk/platform-tools/adb"
COMMAND_PATH_EMULATOR="$HOME/Library/Android/sdk/emulator/emulator"
