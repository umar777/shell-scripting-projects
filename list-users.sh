#!/bin/bash


API_URL="https://api.github.com"

USERNAME=$username
TOKEN=$token

REPO_OWNER=$1
REPO_NAME=$2

function github_api_get {
	local endpoint="$1"
	local url="${API_URL}/${endpoint}"

	curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

function list_users {
	local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"
	
	
	collabrators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"
	
	if [[ -z "$collabrators"  ]]; then
		echo "No users with read access foung for ${REPO_OWNER}/${REPO_NAME}."
	else
		echo "Users with read access found for ${REPO_OWNER}/${REPO_NAME}:"
		echo "$collabrators"
	fi

}

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users

