#!/bin/zsh

full_path="$ZED_FILE"
filename_ext=$(basename "$full_path")
filename="${filename_ext%.*}"
extension="${filename_ext##*.}"
dir=$(dirname "$full_path")

echo "[running $filename_ext]"

# source "$(pwd)/.venv/bin/activate" && python "$full_path" 
case "$extension" in
py)
    python "$full_path"
    ;;
js)
    node "$full_path"
    ;;
ts)
    ts-node "$full_path"
    ;;
sh)
    bash "$full_path"
    ;;
rb)
    ruby "$full_path"
    ;;
php)
    php "$full_path"
    ;;
c)
    gcc "$full_path" -o "/tmp/$filename" && "/tmp/$filename"
    ;;
cpp)
    g++ "$full_path" -o "/tmp/$filename" && "/tmp/$filename"
    ;;
java)
    javac "$full_path" && java -cp "$dir" "$filename"
    ;;
go)
    go run "$full_path"
    ;;
rs)
    rustc "$full_path" -o "/tmp/$filename" && "/tmp/$filename"
    ;;
lua)
    lua "$full_path"
    ;;
pl)
    perl "$full_path"
    ;;
swift)
    swift "$full_path"
    ;;
kt)
    kotlinc "$full_path" -include-runtime -d "/tmp/$filename.jar" && java -jar "/tmp/$filename.jar"
    ;;
*)
    echo "[unsupported extension: .$extension]"
    ;;
esac
