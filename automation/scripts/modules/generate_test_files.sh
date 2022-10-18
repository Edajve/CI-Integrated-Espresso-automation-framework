#! /bin/bash

# Generate Espresso Test files by concating individual test cases into larger file(s)
#
#   Params: $1 =SuiteID         (Required), 
#           $2-N =CaseIDs       (Required)

get_constants() {
    # Import Global Variables from all files in './constants' folder
    for f in ./constants/*; do
        . "$f"
    done

    # Grab Global Variables from Shell Script Parameters
    DIRECTORY_TEST_CASES=${@:1:1}
    SUITE_ID=( ${@:2:2} )
    TEST_CASE_IDS=${@:3}
    TEST_OUTPUT_PATH=$PATH_OUTPUT_ROOT/$PLATFORM

    # DEBUGGING
    # echo "D:$DIRECTORY_TEST_CASES"
    # echo "S:$SUITE_ID"
    # echo "TC:$TEST_CASE_IDS"
    # echo "TOP:$TEST_OUTPUT_PATH"

    # Template files locations for test suite class
    HEADER_TEMPLATE_PATH="$DIRECTORY_TEST_CASES/$PLATFORM/header.tpl"
    FOOTER_TEMPLATE_PATH="$DIRECTORY_TEST_CASES/$PLATFORM/footer.tpl"
}

generate_test_files() {
    CLASS_NAME="$PREPEND_LABEL_SUITE$SUITE_ID$APPEND_LABEL_SUITE"

    $(cat $HEADER_TEMPLATE_PATH > $TEST_OUTPUT_PATH/${CLASS_NAME}.${EXTENSION})

    for i in ${TEST_CASE_IDS[@]}; do
        CLEAN_TEST_ID=$(echo $i | sed "s/\"//g")    # Remove "" around Test Case Name/ID
        FILENAME="$DIRECTORY_TEST_CASES/${PLATFORM}/${CLEAN_TEST_ID}.${EXTENSION}"
        if [ -f "$FILENAME" ]; then
             $(cat ${FILENAME} >> $TEST_OUTPUT_PATH/${CLASS_NAME}.${EXTENSION})
        fi
    done

    $(cat $FOOTER_TEMPLATE_PATH >> $TEST_OUTPUT_PATH/${CLASS_NAME}.${EXTENSION})

    $(sed -i '' "s/CLASS_NAME_TO_REPLACE/$CLASS_NAME/g" $TEST_OUTPUT_PATH/$CLASS_NAME.${EXTENSION})
}


# Begin Execution Logic

# DEBUGGING ONLY
# echo "Number of inputs is $(($#))"
# for i in $@; do
#     echo "$i"
# done

get_constants $@
generate_test_files