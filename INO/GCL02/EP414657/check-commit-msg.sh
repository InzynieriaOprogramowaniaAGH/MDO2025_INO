#!/bin/bash
commit_msg_file="$1"
commit_msg=$(cat "$commit_msg_file")

if [[ $commit_msg =~ ^EP414657 ]]; then 
 echo "ERROR: Commit message must start with 'EP414657' "
 exit 1
fi
