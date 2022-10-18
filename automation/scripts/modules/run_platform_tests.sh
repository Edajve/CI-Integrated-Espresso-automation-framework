#! /bin/bash

get_constants() {
    # Import Global Variables from all files in './constants' folder
    for f in ./constants/*; do
        . "$f"
    done

    DIRECTORY_MOBILE_SOURCE=$1
    # DIRECTORY_MOBILE_SOURCE=/Users/robertbosse/release/fubo-native-client
    TARGET_PLATFORM=$2
    CWD=$(pwd)
    COMMAND_PATH_GRADLEW=$DIRECTORY_MOBILE_SOURCE/android
}

start_metro() {
    if [ -z "$METRO_IS_ACTIVE" ]
    then
        cd $DIRECTORY_MOBILE_SOURCE

        command_to_exec="cd $DIRECTORY_MOBILE_SOURCE;yarn start"

        echo "Opening new Terminal..."

        osascript -e "
            activate
            tell application \"Terminal.app\"        
                do script \"$command_to_exec\"
            end tell
        " > /dev/null


        # YARN_PID=$!
        # echo $YARN_PID
        cd $CWD
    fi
}

check_metro_port() {
    METRO_IS_ACTIVE=$(lsof -n -i TCP:8081 | sed -n '2 p')
}

check_if_android_emulator_is_installed() {
    echo "Checking for installed emulators..."
    LIST=$($COMMAND_PATH_EMULATOR -list-avds)

    if [ -z "$LIST" ]
    then
        echo -e "\033[1;31mSCRIPT FAILURE - No Android emulator installed!\033[0m\n"
        exit 1 
    fi
}

check_android_emulator_is_running() {
    echo "Checking for running emulators..."
    RUNNING_ANDROID_DEVICES=$($COMMAND_PATH_ADB devices -l | sed -n '2 p')    
}

start_android_emulator() {
    if [ -z "$RUNNING_ANDROID_DEVICES" ]
    then
        echo "Starting Android emulator..."
        command_to_exec="$COMMAND_PATH_EMULATOR -avd $LIST -netdelay none -netspeed full;$COMMAND_PATH_ADB -s emulator-5554 reverse tcp:8081 tcp:8081"

        echo "Opening new Terminal..."

        osascript -e "
            activate
            tell application \"Terminal.app\"        
                do script \"$command_to_exec\"
            end tell
        " > /dev/null

        until adb shell true; do sleep 1; done
        # Kill PID oncomplete!
    fi
}

run_android_tests() {
    # $($DIRECTORY_MOBILE_SOURCE/android/gradlew connectedAndroidTest)
    echo "Running Android Tests..."

    check_if_android_emulator_is_installed
    check_android_emulator_is_running
    start_android_emulator

    echo "Emulator ready --- Run tests!"
    
    cd $DIRECTORY_MOBILE_SOURCE/android
    ./gradlew connectedDebugAndroidTest
}

run_ios_tests() {
    echo "Running iOS Tests..."
}

run_platform_tests() {
    check_metro_port
    start_metro

    if [[ $TARGET_PLATFORM == 'android' ]]
    then
        run_android_tests
    fi

    if [[ $TARGET_PLATFORM == 'ios' ]]
    then
        run_ios_tests
    fi
}

clean_up() {
    commands=("qemu-system-aarch64" "yarn" "node")
    for command in "${commands[@]}"
    do
        # echo -e "\n$command"
        ps_ids=$(pgrep $command)
        if [[ $ps_ids ]];
        then
            for process in $ps_ids
            do
                if [[ $(ps -o pid= $process) ]]
                then
                    # echo -e "\t\t$(ps -o pid= $process)"
                    kill -9 $(ps -o pid= $process)
                fi
            done
        fi
    done
}

# Begin Execution Logic

# DEBUGGING ONLY
# echo "Number of inputs is $(($#))"
# for i in $@; do
#     echo "$i"
# done

get_constants $@
run_platform_tests
# clean_up