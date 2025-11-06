#!/bin/bash

# Variables
# Run app from base directory, not ./windows
# Write path UNIX-style ("/"). Script will invert the slash where relevant.
app_name="Jorts"
build_dir="builddir"
theme_name="io.elementary.stylesheet.blueberry"
version="3.5.0"

deploy_dir="windows/deploy"
exe_name="io.github.ellie_commons.jorts.exe"

# Rebuild the exe as a release build
rm -rfd ${build_dir}
meson setup --buildtype release ${build_dir}
ninja -C ${build_dir}

# Copy DLLS
echo "Copying DLLs..."
mkdir -p "${deploy_dir}"
mkdir -p "${deploy_dir}/bin"
mkdir -p "${deploy_dir}/etc"
mkdir -p "${deploy_dir}/share"
mkdir -p "${deploy_dir}/lib"
mkdir -p "${deploy_dir}/include"
cp "${build_dir}/src/${exe_name}" "${deploy_dir}/bin"
cp -r "windows/icons" "${deploy_dir}"

dlls=$(ldd "${deploy_dir}/bin/${exe_name}" | grep "/mingw64" | awk '{print $3}')

for dll in $dlls 
do 
    cp "$dll" "${deploy_dir}/bin"
done

# You wouldnt believe how much pain it was to figure out these three lines
cp -rnv /mingw64/bin/rsvg-convert.exe ${deploy_dir}/bin/
cp -rnv /mingw64/bin/librsvg-2-2.dll ${deploy_dir}/bin/
cp -rnv /mingw64/bin/libxml2-16.dll ${deploy_dir}/bin/
# I beg you, everytime you see your apps icons show up, think of the pain it took and the sacrifices made


# Copy other required things for Gtk to work nicely
echo "Copying other necessary files..."
cp -nv /mingw64/bin/gdbus.exe ${deploy_dir}/bin/
cp -rnv /mingw64/etc/fonts ${deploy_dir}/etc/
cp -rnv /mingw64/share/glib-2.0 ${deploy_dir}/share/
cp -rnv /mingw64/share/gtk-4.0 ${deploy_dir}/share/
cp -rnv /mingw64/share/locale ${deploy_dir}/share/
cp -rnv /mingw64/share/themes/ ${deploy_dir}/share/
cp -rnv /mingw64/share/gettext/ ${deploy_dir}/share/
cp -rnv /mingw64/share/fontconfig/ ${deploy_dir}/share/
cp -rnv /mingw64/share/GConf/ ${deploy_dir}/share/
cp -rnv /mingw64/lib/gettext/ ${deploy_dir}/lib/

# We need this to properly display icons
cp -rnv /mingw64/include/librsvg-2.0 ${deploy_dir}/include/
cp -rnv /mingw64/lib/gdk-pixbuf-2.0/ ${deploy_dir}/lib/
#export GDK_PIXBUF_MODULEDIR=lib/gdk-pixbuf-2.0/2.10.0/loaders
#gdk-pixbuf-query-loaders > ${deploy_dir}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache

# Make sure this one is actually copied
cat windows/loaders.cache > ${deploy_dir}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache

# Ive tried, and failed, to pull only needed icons
#cp -rnv /mingw64/share/icons/ ${deploy_dir}/share/

# Only what we need
mkdir -pv ${deploy_dir}/share/icons/elementary
cp -rnv /mingw64/share/icons/elementary/actions* ${deploy_dir}/share/icons/elementary/
cp -rnv /mingw64/share/icons/elementary/status* ${deploy_dir}/share/icons/elementary/
cp -rnv /mingw64/share/icons/elementary/emotes* ${deploy_dir}/share/icons/elementary/
cp -rnv /mingw64/share/icons/elementary/index.theme ${deploy_dir}/share/icons/elementary/
gtk4-update-icon-cache.exe -f ${deploy_dir}/share/icons/elementary/




# Write the theme to gtk settings
mkdir -v ${deploy_dir}/etc/gtk-4.0/
cat << EOF > ${deploy_dir}/etc/gtk-4.0/settings.ini
[Settings]
gtk-theme-name=${theme_name}
gtk-icon-theme-name=elementary
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintful
gtk-xft-rgba=rgb
EOF

#glib-compile-schemas ${deploy_dir}/share/glib-2.0/schemas

#================================================================
# Create NSIS script
echo "Creating NSIS script..."
cat << EOF > windows/${app_name}-Installer.nsi
!include "MUI2.nsh"
!include WinMessages.nsh

Name ${app_name}

VIAddVersionKey /LANG=0 "ProductName" "${app_name}"
VIAddVersionKey /LANG=0 "FileVersion" "${version}"
VIAddVersionKey /LANG=0 "ProductVersion" "${version}"
VIAddVersionKey /LANG=0 "FileDescription" "https://github.com/ellie-commons/jorts"
VIAddVersionKey /LANG=0 "LegalCopyright" "GNU GPL v3 Ellie-Commons"
VIProductVersion "${version}"

Outfile "${app_name}-Installer.exe"
InstallDir "\$LOCALAPPDATA\\Programs\\${app_name}"

# RequestExecutionLevel admin  ; Request administrative privileges 
RequestExecutionLevel user

# Set the title of the installer window
Caption "${app_name} Installer"
BrandingText "Jorts ${version}, Ellie-Commons 2025"

# Set the title and text on the welcome page
!define MUI_WELCOMEPAGE_TITLE "Welcome to ${app_name} setup"
!define MUI_WELCOMEPAGE_TEXT "This bitch will guide you through the installation of ${app_name}."
!define MUI_INSTFILESPAGE_TEXT "Please wait while ${app_name} is being installed."
!define MUI_ICON "icons\install.ico"
!define MUI_UNICON "icons\uninstall.ico"

!define MUI_FINISHPAGE_LINK "Source code and wiki"
!define MUI_FINISHPAGE_LINK_LOCATION "https://github.com/ellie-commons/jorts"
!define MUI_FINISHPAGE_RUN "\$SMPROGRAMS\Startup\Jorts.lnk"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

!macro GetCleanDir INPUTDIR
  ; ATTENTION: USE ON YOUR OWN RISK!
  ; Please report bugs here: http://stefan.bertels.org/
  !define Index_GetCleanDir 'GetCleanDir_Line\${__LINE__}'
  Push \$R0
  Push \$R1
  StrCpy \$R0 "\${INPUTDIR}"
  StrCmp \$R0 "" \${Index_GetCleanDir}-finish
  StrCpy \$R1 "\$R0" "" -1
  StrCmp "\$R1" "\" \${Index_GetCleanDir}-finish
  StrCpy \$R0 "\$R0\"
\${Index_GetCleanDir}-finish:
  Pop \$R1
  Exch \$R0
  !undef Index_GetCleanDir
!macroend

; ################################################################
; similar to "RMDIR /r DIRECTORY", but does not remove DIRECTORY itself
; example: !insertmacro RemoveFilesAndSubDirs "\$INSTDIR"
!macro RemoveFilesAndSubDirs DIRECTORY
  ; ATTENTION: USE ON YOUR OWN RISK!
  ; Please report bugs here: http://stefan.bertels.org/
  !define Index_RemoveFilesAndSubDirs 'RemoveFilesAndSubDirs_\${__LINE__}'

  Push \$R0
  Push \$R1
  Push \$R2

  !insertmacro GetCleanDir "\${DIRECTORY}"
  Pop \$R2
  FindFirst \$R0 \$R1 "\$R2*.*"
\${Index_RemoveFilesAndSubDirs}-loop:
  StrCmp \$R1 "" \${Index_RemoveFilesAndSubDirs}-done
  StrCmp \$R1 "." \${Index_RemoveFilesAndSubDirs}-next
  StrCmp \$R1 ".." \${Index_RemoveFilesAndSubDirs}-next
  IfFileExists "\$R2\$R1\*.*" \${Index_RemoveFilesAndSubDirs}-directory
  ; file
  Delete "\$R2\$R1"
  goto \${Index_RemoveFilesAndSubDirs}-next
\${Index_RemoveFilesAndSubDirs}-directory:
  ; directory
  RMDir /r "\$R2\$R1"
\${Index_RemoveFilesAndSubDirs}-next:
  FindNext \$R0 \$R1
  Goto \${Index_RemoveFilesAndSubDirs}-loop
\${Index_RemoveFilesAndSubDirs}-done:
  FindClose \$R0

  Pop \$R2
  Pop \$R1
  Pop \$R0
  !undef Index_RemoveFilesAndSubDirs
!macroend

Section "Install"
    SetOutPath "\$INSTDIR"
    File /r "deploy\\*"
    CreateDirectory \$SMPROGRAMS\\${app_name}

    ; fonts. We install to local fonts to not trip up admin rights, and register for local user
    SetOutPath "\$LOCALAPPDATA\\Microsoft\\Windows\\Fonts"
    File "fonts\\RedactedScript-Regular.ttf"
    WriteRegStr HKCU "Software\\Microsoft\\Windows NT\\CurrentVersion\\Fonts" "Redacted Script Regular (TrueType)" "\$LOCALAPPDATA\\Microsoft\\Windows\\Fonts\\RedactedScript-Regular.ttf"
    SetOutPath "\$INSTDIR"

    ; Start menu
    CreateShortCut "\$SMPROGRAMS\\${app_name}\\${app_name}.lnk" "\$INSTDIR\\bin\\${exe_name}" "" "\$INSTDIR\\icons\\icon-mini.ico" 0
    
    ; Autostart
    CreateShortCut "\$SMPROGRAMS\\Startup\\${app_name}.lnk" "\$INSTDIR\\bin\\${exe_name}" "" "\$INSTDIR\\icons\\icon-mini.ico" 0
    
    ; Preferences
    CreateShortCut "\$SMPROGRAMS\\${app_name}\\Preferences of ${app_name}.lnk" "\$INSTDIR\bin\\${exe_name}" "--preferences" "\$INSTDIR\\icons\\settings-mini.ico" 0
    
    WriteRegStr HKCU "Software\\${app_name}" "" \$INSTDIR
    WriteUninstaller "\$INSTDIR\Uninstall.exe"
    
    ; Add to Add/Remove programs list
    WriteRegStr HKCU "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${app_name}" "DisplayName" "${app_name}"
    WriteRegStr HKCU "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${app_name}" "DisplayIcon" "\$INSTDIR\\icons\\icon.ico"
    WriteRegStr HKCU "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${app_name}" "InstallLocation" "\$INSTDIR\\"
    WriteRegStr HKCU "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${app_name}" "UninstallString" "\$INSTDIR\\Uninstall.exe"
    WriteRegStr HKCU "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${app_name}" "Publisher" "Ellie-Commons"
    WriteRegStr HKCU "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${app_name}" "URLInfoAbout" "https://github.com/ellie-commons/jorts"
    WriteRegDWORD HKCU "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${app_name}" "EstimatedSize" "0x00025D78" ;155MB
SectionEnd

Section "Uninstall"

    ; Remove Start Menu shortcut
    Delete "\$SMPROGRAMS\\${app_name}\\${app_name}.lnk"
    Delete "\$SMPROGRAMS\\${app_name}\\Preferences of ${app_name}.lnk"
    Delete "\$SMPROGRAMS\\Startup\\${app_name}.lnk"

    ; Remove uninstaller
    Delete "\$INSTDIR\Uninstall.exe"
    
    ; Remove files and folders
    !insertmacro RemoveFilesAndSubDirs "\$INSTDIR"

    ; Remove directories used
    RMDir \$SMPROGRAMS\\${app_name}
    RMDir "\$INSTDIR"

    ; Remove font
    Delete "\$LOCALAPPDATA\\Microsoft\\Windows\\Fonts\\RedactedScript-Regular.ttf"
    DeleteRegKey HKCU "Software\\Microsoft\\Windows NT\\CurrentVersion\\Fonts" "Redacted Script Regular (TrueType)"

    ; Remove registry keys
    DeleteRegKey HKCU "Software\\${app_name}"
    DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\\${app_name}"

SectionEnd

EOF

echo "Running NSIS..."
makensis windows/${app_name}-Installer.nsi

echo "Done"

