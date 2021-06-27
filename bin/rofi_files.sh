#!/usr/bin/env bash

EDITOR=xdg-open

CUR_DIR=$PWD

if [ -z $1 ]; then
    # Print formatted listing
    rg --files "$CUR_DIR" | sort -u
else
    xdg-open "$1"
fi
