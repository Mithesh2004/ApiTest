#!/bin/bash

REQUESTS_FOLDER="../requests"
EXPECTED_RESPONSES_FOLDER="../expected_responses"
FIELDS_TO_VALIDATE_FOLDER="../fields_to_validate"
ACTUAL_RESPONSES_FOLDER="../actual_responses"
REPORTS_FOLDER="../reports"

# Create the output folders if they don't exist
mkdir -p "$ACTUAL_RESPONSES_FOLDER" "$REPORTS_FOLDER"

for request_file in "$REQUESTS_FOLDER"/*.json; do
    # Extract the request file name without extension
    filename=$(basename -- "$request_file")
    filename_no_ext="${filename%.*}"

    # Build paths for expected and actual response files
    expected_response_file="$EXPECTED_RESPONSES_FOLDER/$filename_no_ext.json"
    fields_to_validate_file="$FIELDS_TO_VALIDATE_FOLDER/$filename_no_ext.txt"
   
    # Add timestamp to make filenames unique
    timestamp=$(date +"%Y%m%d_%H%M%S")
    actual_response_file="$ACTUAL_RESPONSES_FOLDER/${filename_no_ext}_${timestamp}.json"
    report_file="$REPORTS_FOLDER/${filename_no_ext}_${timestamp}.txt"

    # Send the request and store the response
    response=$(curl -s -X POST -H "Content-Type: application/json" --data @"$request_file" "http://localhost:3000/api/endpoint")

    # Extract the fields to be validated from the fields_to_validate file
    fields_to_validate=$(cat "$fields_to_validate_file" | tr -d '\n')

    # Extract and compare the specific fields using python and store the result
    python3 compare_responses.py "$expected_response_file" "$response" "$fields_to_validate_file" "$report_file"

    # Store the actual response
    echo "$response" > "$actual_response_file"
done