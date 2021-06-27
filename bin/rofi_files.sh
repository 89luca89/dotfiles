#!/usr/bin/env bash

EDITOR=xdg-open

CUR_DIR=$PWD

if [ -z $1 ]; then
    # Print formatted listing
    FILES=$(rg --files "$CUR_DIR") && DIRS=$(rg --files --null "$CUR_DIR" | xargs -0 dirname) && echo "$FILES" "$DIRS" | sort -u
else
    xdg-open "$1"
fi
