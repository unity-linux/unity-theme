[![Build Status](https://travis-ci.org/unity-linux/unity-theme.svg?branch=master)](https://travis-ci.org/unity-linux/unity-theme)

# About



# Documentation

  * https://wiki.mageia.org/en/Artwork_Installer

  * http://www.freedesktop.org/wiki/Software/Plymouth
  * http://www.freedesktop.org/wiki/Software/Plymouth/Scripts

# Items to check or do

  * review all backgrounds and animations to match Unity theme:
    - common/plymouth/logo_unity.png and *.png
    - Unity-Default/background/*
    - Unity-Default/gfxboot/*.jpg
    - Unity-Default/plymouth/
    - Unity-Default/grub2/

# GfxBoot specs

Images should be color JPEG, non-progressive with a 4:2:0 sampling
(see advanced parameters in GIMP).
Also ImageMagick with:
convert -resize 800 -quality 90 -sampling-factor 2x2 -interlace none 
Unity-Default-1600x1200.png back.jpg
