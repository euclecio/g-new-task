#!/usr/bin/env bash

issue_name=$1

if [ ! $(git rev-parse --is-inside-work-tree) ]; then
    exit 1;
fi
repo_path=$(git config --get remote.origin.url | sed -r 's/(.*:)(.*)(\..*)/\2/')

if [[ -z $1 ]] || [[ $1 == '--help' ]] || [[ $1 == '-h' ]]; then
    printf " Creates a new branch in you computer and move it on github

 Usage:
    g-new-task issueID

 Ex:
    g-new-task 3084\n"
    exit 0
fi

if [ -z ${GITHUB_USER+x} ] || [ -z ${GITHUB_PASSWORD+x} ] && [ -z ${GITHUB_TOKEN+x} ]; then
    printf "If you want to move the task you should set the environment variables bellow:
    \e[33mGITHUB_TOKEN\e[0m
OR
    \e[33mGITHUB_USER
    GITHUB_PASSWORD\e[0m\n"
fi

if [ ! -z ${GITHUB_TOKEN+x} ]; then
    issue_exists=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/compufour/compufacil/issues/$issue_name | grep message)
else
    issue_exists=$(curl -s -u $GITHUB_USER:$GITHUB_PASSWORD https://api.github.com/repos/compufour/compufacil/issues/$issue_name | grep message)
fi

if [[ $issue_exists == *"Not Found"* ]]; then
    printf "\e[33mNo issue with this ID was found\e[0m\n"
    exit 1
fi

if [[ $(git branch | grep $issue_name) ]]; then
    printf "\e[33mThis branch already exists.\e[0m\n"
    exit 1
fi

echo "Entering master to create branch from it..."
git checkout master
git fetch origin
git pull origin master
git checkout -b $issue_name

if [ ! -z ${GITHUB_TOKEN+x} ]; then
    curl -s -X DELETE -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/$repo_path/issues/$issue_name/labels/Stage%3A%20Analysis >/dev/null
    curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/$repo_path/issues/$issue_name/labels -d '["Stage: In Progress"]' >/dev/null
else
    curl -s -X DELETE -u $GITHUB_USER:$GITHUB_PASSWORD https://api.github.com/repos/$repo_path/issues/$issue_name/labels/Stage%3A%20Analysis >/dev/null
    curl -s -u $GITHUB_USER:$GITHUB_PASSWORD https://api.github.com/repos/$repo_path/issues/$issue_name/labels -d '["Stage: In Progress"]' >/dev/null
fi


#message="$USER created local branch $issue_name"
#curl -X POST --data-urlencode \
#    "payload={\"channel\": \"#devops\", \"username\": \"Notice \", \"text\": \"$message\", \"icon_emoji\": \":ghost:\"}" \
#    https://hooks.slack.com/services/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
