#! /bin/bash

# Log parmaters to file for reporting reference

get_constants() {
    # Import Global Variables from all files in './constants' folder
    for f in ./constants/*; do
        . "$f"
    done

    FILE=${@:1:1}
    PARAMS=${@:2}
}

log() {
    echo $PARAMS >>$FILE
}


# Begin Execution Logic

# DEBUGGING ONLY
# echo "Number of inputs is $(($#))"
# for i in $@; do
#     echo "$i"
# done


get_constants $@
log