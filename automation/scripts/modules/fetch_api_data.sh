#! /bin/bash

# Calls Testlodge API and returns all relevant data filterd using jq command line utility
#
#   Params: $1 =User Email                      (Required), 
#           $2 =User API Key                    (Required),
#           $3 =TestLodge API Request Url       (Required),
#           $4 =JQ command filter string        (Required)

get_constants() {
    # Import Global Variables from all files in './constants' folder
    for f in ./constants/*; do
        . "$f"
    done

    # Grab Global Variables from Shell Script Parameters
    USER_EMAIL=$1
    USER_API_KEY=$2
    API_REQUEST_URL=$3
    JQ_FILTER=${@:4}
}

fetch() {
    JSON_DATA=$(curl -u ${USER_EMAIL}:${USER_API_KEY} ${API_REQUEST_URL})

    TOTAL_PAGES=$(jq  '.pagination.total_pages' <<< $JSON_DATA)

    if [[ "$TOTAL_PAGES" -eq 1 || "$TOTAL_PAGES" -eq '1' ]]
    then
        DATASET=$(jq "${JQ_FILTER}" <<< $JSON_DATA)
        echo $DATASET
    else
        for i in $(seq $TOTAL_PAGES); do
            DATASET=$(curl -u ${USER_EMAIL}:${USER_API_KEY} ${API_REQUEST_URL/page=1/page=$i} | jq  "${JQ_FILTER}")
            echo $DATASET
        done
    fi
}


# Begin Execution Logic

# DEBUGGING ONLY
# echo "Number of inputs is $(($#))"
# for i in $@; do
#     echo "$i"
# done


get_constants $@
fetch