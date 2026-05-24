#!/usr/bin/env bash

# Obsidian vault
VAULT=/mnt/Files/Brain/portugues

# Output file (default: content.md)
output="${1:-content.md}"

# Truncate or create output file
: > "$output"

# Loop through all .md files
for file in $VAULT/*.md; do
  # Skip if no .md files exist
  [[ -e "$file" ]] || continue

  # Skip the output file itself if it matches pattern
  [[ "$file" == "$output" ]] && continue

  # Extract filename without extension
  name=$(basename "$file")

  {
    echo "# $name"
    echo
    cat "$file"
    echo
    echo
  } >> "$output"
done
