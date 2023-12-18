import json
import sys

def get_nested(data, *args):
    if args and data:
        element = args[0]
        if element:
            value = data.get(element)
            return value if len(args) == 1 else get_nested(value, *args[1:])

# Get the filenames from command line arguments
expected_response_file = sys.argv[1]
response = sys.argv[2]
fields_to_validate_file = sys.argv[3]
report_file = sys.argv[4]

# Load the expected response and actual response
expected = json.load(open(expected_response_file))
actual = json.loads(response)

# Load the fields to validate
with open(fields_to_validate_file, 'r') as f:
    fields_to_validate = [field.split('.') for field in f.read().split(',')]

# Compare the fields and store the result
result = {}
for field in fields_to_validate:
    key = ".".join(field)
    actual_value = get_nested(actual, *field)
   
    if actual_value is not None :
        expected_value = get_nested(expected['expected_values'], *field)
        result[key] = actual_value == expected_value
    else:
        result[key] = "undefined"

# Write the result to the report file
with open(report_file, 'w') as f:
    f.write(", ".join(f'"{k}": {v}' for k, v in result.items()))
