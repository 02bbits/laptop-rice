#!/bin/bash

amixer get Master | grep '\[on\]' >/dev/null && amixer set Master mute || amixer set Master unmute
