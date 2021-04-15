#!/bin/bash

direction=$1;

# Get list of desktops and identify the current one with the star symbol
desktop=$(wmctrl -d | grep '\*' | cut -d ' ' -f1);

# Get list of windows on the current desktop
window_list=$(wmctrl -l -G | awk -v a="${desktop}" '$2==a');

# Store window list into an array
mapfile -t windows < <( echo "${window_list}" );

# Make an array with the window ids and window positions
n=0;
for ((i=0;i<${#windows[@]};i++)); do
    thisLine=( $(echo "${windows[i]}") );
    # Check if window is minimized or not
    winState=$(xprop -id ${thisLine[0]} | grep "window state" | cut -d ':' -f2);
    if [ $winState == "Normal" ] ; then
        winId[n]=${thisLine[0]};
        winX[n]=${thisLine[2]};
        winY[n]=${thisLine[3]};
        n=$(($n + 1));
    fi
done

# Sort windows left to right with bubble sort
for ((i=0;i<$n;i++)); do
    for ((j=0;j<$(($n - 1));j++)); do
        if [ ${winX[j]} -gt ${winX[j+1]} ] ; then
            tempId=${winId[j+1]};
            tempX=${winX[j+1]};
            tempY=${winY[j+1]};
            winId[j+1]=${winId[j]};
            winX[j+1]=${winX[j]};
            winY[j+1]=${winY[j]};
            winId[j]=${tempId};
            winX[j]=${tempX};
            winY[j]=${tempY};
        fi
    done
done

# Find currently focused window
focusedWindowString=( $(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW) );
focusedWindow=${focusedWindowString[1]};

# Add extra zero to ensure compatibility between wmctrl and xprop
if [ ${#focusedWindow} -lt ${#winId[0]} ]; then
    focusedWindow=$(echo "${focusedWindow}" | sed 's/0x/0x0/g');
fi

# Now loop through list of windows, find currenty focused window
# and switch to the window on the left or right depending on input
for ((i=0;i<$n;i++)); do
    if [ "${winId[i]}" == "${focusedWindow}" ] ; then
        if [ "${direction}" == "left" ] ; then
            if [ $i -gt 0 ] ; then
                wmctrl -i -a "${winId[i-1]}";
            else
                wmctrl -i -a "${winId[n-1]}";
            fi
        elif [ "${direction}" == "right" ] ; then
            if [ $i -lt $(($n - 1)) ] ; then
                wmctrl -i -a "${winId[i+1]}";
            else
                wmctrl -i -a "${winId[0]}";
            fi
        fi
    fi
done
