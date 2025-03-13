#!/bin/bash
commit_msg=$(cat $1 | cut -c1-8)

if [[ $commit_msg != "EP414657" ]]; then 
 echo "ERROR: Commit message must start with 'EP414657' "
 exit 1
fi
exit 0
