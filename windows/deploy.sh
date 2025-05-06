#!/bin/bash

# Variables
# Run app from base directory, not ./windows
# Write path UNIX-style ("/"). Script will invert the slash where relevant.
app_name="Jorts"
build_dir="builddir"
theme_name="io.elementary.stylesheet.blueberry"
font_path="RedactedScript"

deploy_dir="windows/deploy"
exe_name="io.github.ellie_commons.jorts.exe"
icon_file="jorts.ico"
icon_file_install="jorts.ico"
icon_file_uninstall="jorts.ico"

#PRE MESON
#Add win subsystem gui
#Skip metainfo

# Rebuild the exe as a release build
rm -rfd ${build_dir}
meson setup --buildtype release ${build_dir}
ninja -C ${build_dir}

#POST MESON
#remove win subsystem gui
#re-add metainfo

# Copy DLLS
echo "Copying DLLs..."
mkdir -p "${deploy_dir}"
cp "${icon_file}" "${deploy_dir}/${icon_file}"

mkdir -p "${deploy_dir}/bin"
mkdir -p "${deploy_dir}/etc"
mkdir -p "${deploy_dir}/share"
cp "${build_dir}/${exe_name}" "${deploy_dir}/bin"
dlls=$(ldd "${deploy_dir}/bin/${exe_name}" | grep "/ucrt64" | awk '{print $3}')

for dll in $dlls 
do 
    cp "$dll" "${deploy_dir}/bin"
done

# Copy other required things for Gtk to work nicely
echo "Copying other necessary files..."
cp /ucrt64/bin/gdbus.exe ${deploy_dir}/bin/gdbus.exe
cp -r /ucrt64/etc/gtk-3.0 ${deploy_dir}/etc/gtk-3.0
cp -r /ucrt64/etc/gtk-4.0 ${deploy_dir}/etc/gtk-4.0
cp -r /ucrt64/etc/fonts ${deploy_dir}/etc/fonts

# Redacted Script
cp -r ${font_path} ${deploy_dir}/etc/fonts/${font_path}

mkdir -p ${deploy_dir}/lib/gdk-pixbuf-2.0/2.10.0
cp -r /ucrt64/lib/gdk-pixbuf-2.0/2.10.0 ${deploy_dir}/lib/gdk-pixbuf-2.0

# Fix for icons being broken THIS IS SO STUPID WHY
cp -r ${deploy_dir}/lib/gdk-pixbuf-2.0/2.10.0/loaders/pixbufloader_svg.dll ${deploy_dir}/lib/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader_svg.dll
gdk-pixbuf-query-loaders.exe --update-cache ${deploy_dir}/lib/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader_svg.dll

cp -r /ucrt64/share ${deploy_dir}
cp -r /ucrt64/share/glib-2.0 ${deploy_dir}/share/
cp -r /ucrt64/share/gtk-3.0 ${deploy_dir}/share/
cp -r /ucrt64/share/gtk-4.0 ${deploy_dir}/share/
cp -r /ucrt64/share/icons ${deploy_dir}/share/
cp -r /ucrt64/share/icu ${deploy_dir}/share/
cp -r /ucrt64/share/locale ${deploy_dir}/share/
cp -r /ucrt64/share/themes/${theme_name} ${deploy_dir}/share/themes

# Write the theme to gtk settings
cat << EOF > ${deploy_dir}/etc/gtk-4.0/settings.ini
[Settings]
gtk-theme-name=${theme_name}
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintful
gtk-xft-rgba=rgb
EOF

# Create NSIS script
echo "Creating NSIS script..."
cat << EOF > ${app_name}Installer.nsi
!include "MUI2.nsh"

Name ${app_name}

Outfile "${app_name}Installer.exe"
InstallDir "\$PROGRAMFILES\\${app_name}"
#RequestExecutionLevel admin  ; Request administrative privileges

# Set the title of the installer window
Caption "${app_name} Installer"

# Set the title and text on the welcome page
!define MUI_WELCOMEPAGE_TITLE "Welcome to ${app_name} setup"
!define MUI_WELCOMEPAGE_TEXT "This bitch will guide you through the installation of ${app_name}."
!define MUI_ABORTWARNING
!define MUI_ABORTWARNING_TEXT "Are you sure you want to cancel ${app_name} setup?"
!define MUI_INSTFILESPAGE_TEXT "Please wait while ${app_name} is being installed."
!define MUI_ICON "\${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "\${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

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
    File /r "${deploy_dir/\//\\}\\*"
    CreateDirectory \$SMPROGRAMS\\${app_name}

    ; Start menu
    CreateShortCut "\$SMPROGRAMS\\${app_name}\\${app_name}.lnk" "\$INSTDIR\bin\\${exe_name}" "" "\$INSTDIR\\${icon_file/\//\\}" 0
    
    ; Autostart
    ; CreateShortCut "\$SMPROGRAMS\\Startup\\${app_name}.lnk" "\$INSTDIR\bin\\${exe_name}" "" "\$INSTDIR\\${icon_file/\//\\}" 0
    
    ; Preferences
    CreateShortCut "\$SMPROGRAMS\\${app_name}\\Preferences of ${app_name}.lnk" "\$INSTDIR\bin\\${exe_name}" "--preferences" "\$INSTDIR\\${icon_file/\//\\}" 0


    
    WriteRegStr HKCU "Software\\${app_name}" "" \$INSTDIR
    WriteUninstaller "\$INSTDIR\Uninstall.exe"
    
    ; Add to Add/Remove programs list
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\\${app_name}" "DisplayName" "${app_name}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\\${app_name}" "UninstallString" "\$INSTDIR\Uninstall.exe"
SectionEnd

Section "Uninstall"

    ; Remove Start Menu shortcut
    Delete "\$SMPROGRAMS\\${app_name}\\${app_name}.lnk"
    Delete "\$SMPROGRAMS\\${app_name}\\Preferences of ${app_name}.lnk"
    Delete "\$SMPROGRAMS\\Startup\\${app_name}.lnk"

    ; Remove uninstaller
    Delete "\$INSTDIR\${icon_name}"
    Delete "\$INSTDIR\Uninstall.exe"
    
    ; Remove files and folders
    !insertmacro RemoveFilesAndSubDirs "\$INSTDIR"

    ; Remove directories used
    RMDir \$SMPROGRAMS\\${app_name}
    RMDir "\$INSTDIR"

    ; Remove registry keys
    DeleteRegKey HKCU "Software\\${app_name}"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\\${app_name}"

SectionEnd

EOF

echo "Running NSIS..."
makensis ${app_name}Installer.nsi

echo "Done"

