#!/bin/bash
json_array='[]'
EXCLUDE_FILES=${EXCLUDE_FILES:-""}

while IFS= read -r file; do
    if echo "$EXCLUDE_FILES" | grep -qw "$(basename "$file")"; then
        continue
    fi

    deployment=""
    deployment=$(cat "$file" | yq '. | select(.kind == "Deployment") | .metadata.name')
    json_array=$(jq --arg file "$file" --arg deployment "$deployment" '. += [{"file": $file, "deployment": $deployment}]' <<< "$json_array")
done < <(ls $DIRECTORY)

echo "$json_array"
echo "deployments=$(echo $json_array)" >> $GITHUB_OUTPUT
