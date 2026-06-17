#!/bin/bash

echo "[detecting build artifacts to clean...]"

targets=(
  "*.out"
  "*.class"
  "*.o"
  "*.exe"
  "*.jar"
  "*.a"
  "*.so"
  "__pycache__"
  ".pytest_cache"
  "dist"
  "build"
  "target"
  "node_modules"
  ".parcel-cache"
  ".next"
  ".turbo"
  ".cache"
)

found=()

# Find matching files/directories
for pattern in "${targets[@]}"; do
  matches=$(find . -type f -name "$pattern" -o -type d -name "$pattern" 2>/dev/null)
  if [[ -n "$matches" ]]; then
    while IFS= read -r line; do
      found+=("$line")
    done <<<"$matches"
  fi
done

if [[ ${#found[@]} -eq 0 ]]; then
  echo "[nothing to clean]"
  exit 0
fi

echo "[files/directories to be deleted:]"
printf '%s\n' "${found[@]}"

echo
read -p "⚠️  Proceed to delete these? (y/n): " confirm

if [[ "$confirm" == [yY] ]]; then
  for path in "${found[@]}"; do
    rm -rf "$path"
  done
  echo "[cleanup complete]"
else
  echo "[cleanup aborted]"
fi
