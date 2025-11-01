#!/bin/bash


pacman -S mingw-w64-ucrt-x86_64-{gtk4,vala,granite7,ninja,meson,nsis}
pacman -S mingw-w64-libgee mingw-w64-gsettings-desktop-schemas

wget https://github.com/christiannaths/redacted-font/raw/63e542017bab347ba9be54d7d99b99d4754c3d97/RedactedScript/fonts/ttf/RedactedScript-Regular.ttf -O font/RedactedScript-Regular.ttf