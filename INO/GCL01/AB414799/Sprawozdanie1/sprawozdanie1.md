# Sprawozdanie

## Git Hook (commit-msg)
\`\`\`bash
#!/bin/bash

REQUIRED_PREFIX="AB414799"
MESSAGE=$(cat "$1")

if [[ ! "$MESSAGE" =~ ^$REQUIRED_PREFIX ]]; then
    echo "❌ Commit message musi zaczynać się od: $REQUIRED_PREFIX"
    exit 1
fi

exit 0
\`\`\`
