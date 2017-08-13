#!/bin/bash

bgpath="/usr/share/mga/backgrounds"
theme="Mageia-Default"
curlink=$(readlink $bgpath/default.png)

# Search for the optimal background resolution according to monitor-edid
if [ -e /usr/sbin/monitor-edid ]; then
    res=$(exec /usr/sbin/monitor-edid | grep -m 1 ModeLine)  # => ModeLine "1920x1080" ...
    res=$(expr "$res" : '.*"\(.*\)".*')  # isolate the resolution
fi

# If the previous method did not work, default to 4:3 aspect ratio (e.g. 1024x768)
if [ -z $res ]; then
    res="1600x1200"
fi

# Check if the symlink is already good
if [ "$curlink" = "$bgpath/$theme-$res.png" ]; then
    exit 0
fi

# Check if this is a supported resolution, if not, find the background with a similar aspect ratio
if [ ! -e "$bgpath/$theme-$res.png" ]; then
    width=$(echo $res | cut -f1 -d"x")
    height=$(echo $res | cut -f2 -d"x")
    # Bash only does integer arithmetic, we multiply everything by 1000 to workaround this
    ratio=$((1000*$width/$height))
    declare -A refRatios=( ["1250"]="1280x1024" ["1333"]="1600x1200" ["1600"]="1920x1200"
                           ["1667"]="1280x768" ["1707"]="1024x600" ["1778"]="3840x2160" )
    for key in "${!refRatios[@]}"; do
        if [ $(($ratio % $key)) -lt 25 -o $(($key % $ratio)) -lt 25 ]; then
            res=${refRatios[$key]}
            break
        fi
    done
fi

# Check again if the symlink does not already point to this new resolution
# If not, create a new symlink
if [ "$curlink" != "$bgpath/$theme-$res.png" ]; then
    if [ -e "$bgpath/$theme-$res.png" ]; then
        ln -sf $bgpath/$theme-$res.png $bgpath/default.png
        if [ -d /boot/grub2/themes ]; then
            cp -f $bgpath/$theme-$res.png /boot/grub2/themes/grub2-mageia-default.png
        fi
    else
        echo -e "Could not find this file: $bgpath/$theme-$res.png"
        echo "Please check that the mageia-theme-Default package is properly installed, or disable"
        echo "the mga-bg-res systemd service if you do not want to force using the Mageia theme."
    fi
fi
 
