#! /bin/bash

##### NETWORK CONSTANTS #####

# Testlodge REST API urls
API_QUERIES=(
    "https://api.testlodge.com/v1/account/ACCOUNT_ID/projects.json?page=1" 
    "https://api.testlodge.com/v1/account/ACCOUNT_ID/projects/PROJECT_ID/plans.json?page=1"
    "https://api.testlodge.com/v1/account/ACCOUNT_ID/projects/PROJECT_ID/suites/SUITE_ID/suite_sections.json?page=1" 
    "https://api.testlodge.com/v1/account/ACCOUNT_ID/projects/PROJECT_ID/suites/SUITE_ID/suite_sections/SUITE_SECTION_ID/steps.json?page=1"
    "https://api.testlodge.com/v1/account/REPLACE_ACCOUNT_ID/projects/REPLACE_PROJECT_ID/runs.json" 
    "https://api.testlodge.com/v1/account/REPLACE_ACCOUNT_ID/projects/REPLACE_PROJECT_ID/runs/REPLACE_RUN_ID/executed_steps/REPLACE_RUN_CASE_ID.json"
    "https://api.testlodge.com/v1/account/REPLACE_ACCOUNT_ID/projects/REPLACE_PROJECT_ID/runs/REPLACE_RUN_ID/executed_steps.json?page=1"
)

# jq command line filtering string
JSON_DATA_KEYS=(
    '.projects[].id'
    '.plans[].id'
    '.suites[] | select(.plan_id | contains(REPLACE_ID)) | .id'
    '.suite_sections[].id'
    '.steps[].step_number'
    '.steps[].id'
)