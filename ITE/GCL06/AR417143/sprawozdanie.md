#!/bin/bash 
commit_msg=$(cat "$1") 
if ! [[ $commit_msg =~ ^KD232144 ]]; then 
echo "Error: Commit messege musi zaczynac sie od 'AR417143'" 
echo "Commit messege: $commit_msg" 
exit 1 
fi 
exit 0
