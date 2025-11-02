#!/bin/bash

# cd /c/Documents\ and\ Settings/TC/Desktop/jorts

pacman -S mingw-w64-ucrt-x86_64-{gtk4,vala,granite7,ninja,meson,nsis,gcc}
pacman -S mingw-w64-libgee mingw-w64-gsettings-desktop-schemas
pacman -S mingw-w64-x86_64-desktop-file-utils
 pacman -S mingw-w64-x86_64-gtk-elementary-theme mingw-w64-x86_64-elementary-icon-theme

# No its not redundant
pacman -S meson gcc ninja
pacman -S pacman -S mingw-w64-ucrt-x86_64-vala mingw-w64-x86_64-vala

wget https://github.com/christiannaths/redacted-font/raw/63e542017bab347ba9be54d7d99b99d4754c3d97/RedactedScript/fonts/ttf/RedactedScript-Regular.ttf -O font/RedactedScript-Regular.ttf