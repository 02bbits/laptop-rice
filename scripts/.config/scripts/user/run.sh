#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: runfile <file>"
    exit 1
fi

full_path=$(realpath "$1" 2>/dev/null)
RED='\033[0;31m'
NC='\033[0m'

if [ ! -f "$full_path" ]; then
    echo "Error: File '$1' does not exist"
    exit 1
fi

filename_ext=$(basename "$full_path")
filename="${filename_ext%.*}"
extension="${filename_ext##*.}"
dir=$(dirname "$full_path")

echo -e "${RED}[running $filename_ext]${NC}"

case "$extension" in
py) python3 "$full_path" ;;
js) node "$full_path" ;;
ts) ts-node "$full_path" ;;
sh) bash "$full_path" ;;
rb) ruby "$full_path" ;;
php) php "$full_path" ;;
c) gcc "$full_path" -o "/tmp/$filename" && "/tmp/$filename" ;;
cpp) g++ "$full_path" -o "/tmp/$filename" && "/tmp/$filename" ;;
java) javac "$full_path" && java -cp "$dir" "$filename" ;;
go) go run "$full_path" ;;
rs) rustc "$full_path" -o "/tmp/$filename" && "/tmp/$filename" ;;
lua) lua "$full_path" ;;
pl) perl "$full_path" ;;
swift) swift "$full_path" ;;
kt) kotlinc "$full_path" -include-runtime -d "/tmp/$filename.jar" && java -jar "/tmp/$filename.jar" ;;
*) echo "[unsupported extension: .$extension]" ;;
esac
