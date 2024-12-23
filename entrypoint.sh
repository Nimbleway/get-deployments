#!/bin/bash
json_array='[]'
EXCLUDE_FILES=${EXCLUDE_FILES:-"^$"}

while IFS= read -r file; do
    deployment=""
    deployment=$(cat "$file" | yq '. | select(.kind == "Deployment") | .metadata.name')
    json_array=$(jq --arg file "$file" --arg deployment "$deployment" '. += [{"file": $file, "deployment": $deployment}]' <<< "$json_array")
done < <(ls $DIRECTORY | grep -v -E "$EXCLUDE_FILES")

echo "$json_array"
echo "deployments=$(echo $json_array)" >> $GITHUB_OUTPUT
