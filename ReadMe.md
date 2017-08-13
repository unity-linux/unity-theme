# About



# Documentation

  * https://wiki.mageia.org/en/Artwork_Installer

  * http://www.freedesktop.org/wiki/Software/Plymouth
  * http://www.freedesktop.org/wiki/Software/Plymouth/Scripts

# Items to check or do

  * review all backgrounds and animations to match Mageia theme:
    - common/plymouth/logo_mageia.png and *.png
    - Mageia-Default/background/*
    - Mageia-Default/gfxboot/*.jpg
    - Mageia-Default/plymouth/

# GfxBoot specs

Images should be color JPEG, non-progressive with a 4:2:0 sampling
(see advanced parameters in GIMP).
Also ImageMagick with:
convert -resize 800 -quality 90 -sampling-factor 2x2 -interlace none 
Mageia-Default-1600x1200.png back.jpg
