#!/bin/bash

amixer get Capture cap | grep '\[on\]' >/dev/null && amixer set Capture nocap || amixer set Capture cap
