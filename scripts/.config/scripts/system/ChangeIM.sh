#!/bin/bash
current_im=$(fcitx5-remote -n)

if [[ $current_im == "unikey" ]]; then
    fcitx5-remote -s keyboard-us
elif [[ $current_im == "keyboard-us" ]]; then
    fcitx5-remote -s unikey
fi
