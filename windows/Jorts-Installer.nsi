!include "MUI2.nsh"

Name Jorts

Outfile "Jorts-Installer.exe"
InstallDir "$LOCALAPPDATA\Programs\Jorts"
# RequestExecutionLevel admin  ; Request administrative privileges
RequestExecutionLevel user

# Set the title of the installer window
Caption "Jorts Installer"

# Set the title and text on the welcome page
!define MUI_WELCOMEPAGE_TITLE "Welcome to Jorts setup"
!define MUI_WELCOMEPAGE_TEXT "This bitch will guide you through the installation of Jorts."
!define MUI_ABORTWARNING
!define MUI_ABORTWARNING_TEXT "Are you sure you want to cancel Jorts setup?"
!define MUI_INSTFILESPAGE_TEXT "Please wait while Jorts is being installed."
!define MUI_ICON "install.ico"
!define MUI_UNICON "uninstall.ico"

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
  !define Index_GetCleanDir 'GetCleanDir_Line${__LINE__}'
  Push $R0
  Push $R1
  StrCpy $R0 "${INPUTDIR}"
  StrCmp $R0 "" ${Index_GetCleanDir}-finish
  StrCpy $R1 "$R0" "" -1
  StrCmp "$R1" "\" ${Index_GetCleanDir}-finish
  StrCpy $R0 "$R0\"
${Index_GetCleanDir}-finish:
  Pop $R1
  Exch $R0
  !undef Index_GetCleanDir
!macroend

; ################################################################
; similar to "RMDIR /r DIRECTORY", but does not remove DIRECTORY itself
; example: !insertmacro RemoveFilesAndSubDirs "$INSTDIR"
!macro RemoveFilesAndSubDirs DIRECTORY
  ; ATTENTION: USE ON YOUR OWN RISK!
  ; Please report bugs here: http://stefan.bertels.org/
  !define Index_RemoveFilesAndSubDirs 'RemoveFilesAndSubDirs_${__LINE__}'

  Push $R0
  Push $R1
  Push $R2

  !insertmacro GetCleanDir "${DIRECTORY}"
  Pop $R2
  FindFirst $R0 $R1 "$R2*.*"
${Index_RemoveFilesAndSubDirs}-loop:
  StrCmp $R1 "" ${Index_RemoveFilesAndSubDirs}-done
  StrCmp $R1 "." ${Index_RemoveFilesAndSubDirs}-next
  StrCmp $R1 ".." ${Index_RemoveFilesAndSubDirs}-next
  IfFileExists "$R2$R1\*.*" ${Index_RemoveFilesAndSubDirs}-directory
  ; file
  Delete "$R2$R1"
  goto ${Index_RemoveFilesAndSubDirs}-next
${Index_RemoveFilesAndSubDirs}-directory:
  ; directory
  RMDir /r "$R2$R1"
${Index_RemoveFilesAndSubDirs}-next:
  FindNext $R0 $R1
  Goto ${Index_RemoveFilesAndSubDirs}-loop
${Index_RemoveFilesAndSubDirs}-done:
  FindClose $R0

  Pop $R2
  Pop $R1
  Pop $R0
  !undef Index_RemoveFilesAndSubDirs
!macroend

Section "Install"
    SetOutPath "$INSTDIR"
    File /r "deploy\*"
    CreateDirectory $SMPROGRAMS\Jorts

    ; Start menu
    CreateShortCut "$SMPROGRAMS\Jorts\Jorts.lnk" "$INSTDIR\bin\io.github.ellie_commons.jorts.exe" "" "$INSTDIR\jorts.ico" 0
    
    ; Autostart
    ; CreateShortCut "$SMPROGRAMS\Startup\Jorts.lnk" "$INSTDIR\bin\io.github.ellie_commons.jorts.exe" "" "$INSTDIR\jorts.ico" 0
    
    ; Preferences
    CreateShortCut "$SMPROGRAMS\Jorts\Preferences of Jorts.lnk" "$INSTDIR\bin\io.github.ellie_commons.jorts.exe" "--preferences" "$INSTDIR\jorts.ico" 0
    
    WriteRegStr HKCU "Software\Jorts" "" $INSTDIR
    WriteUninstaller "$INSTDIR\Uninstall.exe"
    
    ; Add to Add/Remove programs list
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Jorts" "DisplayName" "Jorts"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Jorts" "UninstallString" "$INSTDIR\Uninstall.exe"
SectionEnd

Section "Uninstall"

    ; Remove Start Menu shortcut
    Delete "$SMPROGRAMS\Jorts\Jorts.lnk"
    Delete "$SMPROGRAMS\Startup\Jorts.lnk"

    ; Remove uninstaller
    Delete "$INSTDIR\Uninstall.exe"
    
    ; Remove files and folders
    !insertmacro RemoveFilesAndSubDirs "$INSTDIR"

    ; Remove directories used
    RMDir $SMPROGRAMS\Jorts
    RMDir "$INSTDIR"

    ; Remove registry keys
    DeleteRegKey HKCU "Software\Jorts"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Jorts"

SectionEnd

