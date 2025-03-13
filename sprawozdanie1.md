# Sprawozdanie1

## Git Hook
\`\`\`bash
#!/bin/bash
commit_msg=$(head -n1 "$1")
pattern="^JP416100"

if [[ ! $commit_msg =~ $pattern ]]; then
  echo "ERROR: Commit message musi zaczynać się od 'JP416100'"
  exit 1
fi
\`\`\`
