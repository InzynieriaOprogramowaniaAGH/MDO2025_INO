commit_msg=$(cat "$1")

if ! [[ "$commit_msg" =~ ^JS415003.* ]]; then
    echo "ERROR: Commit message musi zaczynać się od 'JS415003'"
    echo "Twoja wiadomość: $commit_msg"
    exit 1
fi

exit 0
