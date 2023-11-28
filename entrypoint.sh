#!/bin/bash
json_array='[]'

while IFS= read -r file; do
    json_array=$(jq --arg file "$file" '. += [{"file": $file}]' <<< "$json_array")
done < <(ls $DIRECTORY)

echo "$json_array"
echo "deployments=$(echo $json_array)" >> $GITHUB_OUTPUT
