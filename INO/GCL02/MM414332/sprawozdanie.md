# Sprawozdanie – MM414332

## 1. Gałąź
- Gałąź: `MM414332` utworzona od `GCL02`

## 2. Katalog
- Katalog: `INO/GCL02/MM414332`

## 3. Git hook (commit-msg)
Hook sprawdzający, czy commit message zaczyna się od `MM414332`:

```bash
#!/bin/bash
commit_msg_file="$1"
pattern="^MM414332"

if ! grep -qE "$pattern" "$commit_msg_file"; then
  echo "Commit message musi zaczynać się od 'MM414332'"
  exit 1
fi
