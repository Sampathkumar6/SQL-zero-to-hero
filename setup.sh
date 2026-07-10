#!/bin/bash
# Run this from inside your repo root (e.g. sql-zero-to-hero/)
# It creates unit-01 through unit-30 folders, each with a starter .sql and notes.md

for i in $(seq -w 1 30); do
  dir="unit-${i}"
  mkdir -p "$dir"

  sql_file="$dir/unit-${i}.sql"
  if [ ! -f "$sql_file" ]; then
    cat > "$sql_file" << EOF
-- Unit ${i}
-- Date:
-- Topics:

-- Q1:

EOF
  fi

  notes_file="$dir/notes.md"
  if [ ! -f "$notes_file" ]; then
    cat > "$notes_file" << EOF
# Unit ${i} Notes

## Key concepts

## Gotchas / things I got wrong

## One-line summary
EOF
  fi
done

echo "Done. Created unit-01 through unit-30 folders with starter files."
