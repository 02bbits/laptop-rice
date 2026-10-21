#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# OCR Screenshot script
# Drag-select a region, extract text with tesseract, and store it in
# the clipboard / cliphist history.

iDIR="$HOME/.config/swaync/icons"
sDIR="$HOME/.config/hypr/scripts"
notify_cmd_ocr="notify-send -h string:x-canonical-private-synchronous:ocr-notify -u low -i ${iDIR}/picture.png"

tmp_dir="/tmp"
tmpfile="${tmp_dir}/ocr-shot-$(date +%s)-${RANDOM}.png"

# If OCR_LANG is set explicitly, it always wins (skip auto-detection).
# Otherwise: try to auto-pick a language set based on detected script,
# falling back to a multi-language pass over everything installed below.
ocr_lang="${OCR_LANG:-}"

# Multi-lang fallback pool used when no OCR_LANG override is given.
# Edit this to match the language packs you actually have installed
# (check with: tesseract --list-langs)
FALLBACK_LANGS="eng+vie+jpn+kor+chi_sim"

# Maps tesseract OSD "Script:" output to a language-pack combo.
# Extend this as needed for scripts you use.
script_to_langs() {
    case "$1" in
    Latin) echo "eng+vie" ;;
    Han) echo "chi_sim+chi_tra" ;;
    Japanese) echo "jpn" ;;
    Hangul) echo "kor" ;;
    Cyrillic) echo "rus" ;;
    Arabic) echo "ara" ;;
    Thai) echo "tha" ;;
    *) echo "" ;;
    esac
}

# Only keep language codes that are actually installed, so a missing
# pack never causes a hard failure.
filter_installed() {
    local wanted="$1"
    local installed
    installed=$(tesseract --list-langs 2>/dev/null | tail -n +2)
    local kept=()
    IFS='+' read -ra parts <<<"$wanted"
    for lang in "${parts[@]}"; do
        grep -qx "$lang" <<<"$installed" && kept+=("$lang")
    done
    IFS='+'
    echo "${kept[*]}"
}

cleanup() {
    [[ -f "$tmpfile" ]] && rm -f "$tmpfile"
}
trap cleanup EXIT

# notify helper
notify_result() {
    if [[ "$1" == "ok" ]]; then
        ${notify_cmd_ocr} "OCR Screenshot" "Text copied to clipboard."
        [[ -x "${sDIR}/Sounds.sh" ]] && "${sDIR}/Sounds.sh" --screenshot
    elif [[ "$1" == "empty" ]]; then
        ${notify_cmd_ocr} "OCR Screenshot" "No text detected in selection."
        [[ -x "${sDIR}/Sounds.sh" ]] && "${sDIR}/Sounds.sh" --error
    else
        ${notify_cmd_ocr} "OCR Screenshot" "Failed: $1"
        [[ -x "${sDIR}/Sounds.sh" ]] && "${sDIR}/Sounds.sh" --error
    fi
}

# dependency check
for cmd in grim slurp tesseract wl-copy cliphist magick python3; do
    if ! command -v "$cmd" &>/dev/null; then
        notify_result "missing dependency '$cmd'"
        echo "Error: '$cmd' not found in PATH." >&2
        exit 1
    fi
done

ocrarea() {
    # drag-select a region and grab it
    grim -g "$(slurp)" - >"$tmpfile"

    if [[ ! -s "$tmpfile" ]]; then
        notify_result "selection cancelled or empty"
        exit 1
    fi

    # tesseract wants ~30px glyphs; screen text is ~12px
    magick "$tmpfile" -resize 200% -colorspace Gray "$tmpfile"

    # decide which language(s) to OCR with
    if [[ -z "$ocr_lang" ]]; then
        detected_script=$(tesseract "$tmpfile" - --psm 0 -l osd 2>/dev/null |
            awk -F': ' '/^Script/{print $2; exit}')

        candidate=""
        [[ -n "$detected_script" ]] && candidate=$(script_to_langs "$detected_script")

        if [[ -n "$candidate" ]]; then
            ocr_lang=$(filter_installed "$candidate")
        fi

        # fall back to the full multi-lang pool if detection was empty,
        # unmapped, or none of the candidate packs are installed
        if [[ -z "$ocr_lang" ]]; then
            ocr_lang=$(filter_installed "$FALLBACK_LANGS")
        fi

        # last resort: eng always ships with tesseract
        [[ -z "$ocr_lang" ]] && ocr_lang="eng"
    fi

    # run OCR straight off the temp image, output to stdout
    # ocr-fix.py swaps misread chars by dictionary context (system.1og -> system.log)
    text=$(tesseract "$tmpfile" - -l "$ocr_lang" 2>/dev/null |
        python3 "$(dirname "$0")/ocr-fix.py" | sed -e 's/[[:space:]]*$//')

    if [[ -z "$text" ]]; then
        notify_result "empty"
        exit 1
    fi

    # push to clipboard and cliphist history
    printf '%s' "$text" | wl-copy
    printf '%s' "$text" | cliphist store

    notify_result "ok"
    echo "$text"
}

if [[ ! -d "$tmp_dir" ]]; then
    mkdir -p "$tmp_dir"
fi

ocrarea
exit 0
