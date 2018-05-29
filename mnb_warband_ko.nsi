; compression
SetCompress					off 	; (auto|force|off)
SetCompressor				lzma	; (zlib|bzip2|lzma)

Function "GetMyDocs"
  ReadRegStr $0 HKCU \
             "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" \
             Personal
FunctionEnd
 
;Function .onInit
;  Call "GetMyDocs"
;  MessageBox MB_OK|MB_ICONINFORMATION $0
;  Quit
;FunctionEnd


;--------------------------------
;Include Modern UI
 
  !include "MUI2.nsh"

; The name of the installer
Name "Mount & Blade: Warband Korean Patch"

; The file to write
OutFile "mnb_warband_ko_patch.exe"

; Default installation folder
InstallDir "$PROGRAMFILES\Steam\steamapps\common\MountBlade Warband"


!define WARBAND_DIR 	"$INSTDIR"
!define PENDOR_DIR 		"$INSTDIR\..\..\workshop\content\48700\875202420"

; Request application privileges for Windows Vista
RequestExecutionLevel user

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
; Pages

  !insertmacro MUI_PAGE_LICENSE ".\license.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "Korean"

;--------------------------------


Section "!M&B: Warband Korean" SecWarbandVanilla

  Call "GetMyDocs"
  SetOutPath "$0\Mount&Blade Warband"
  File .\src\language.txt

  ; korean font data
  SetOutPath "${WARBAND_DIR}\data\languages\ko"
  File .\src\mnb_warband\data\languages\ko\font_data.xml
  SetOutPath "${WARBAND_DIR}\textures\languages\ko"
  File .\src\mnb_warband\textures\languages\ko\font.dds

  ; korean data
  SetOutPath "${WARBAND_DIR}\languages\ko"
  File .\src\mnb_warband\languages\ko\factions.csv
  File .\src\mnb_warband\languages\ko\troops.csv
  File .\src\mnb_warband\languages\ko\dialogs.csv
  File .\src\mnb_warband\languages\ko\ui.csv
  File .\src\mnb_warband\languages\ko\game_strings.csv
  File .\src\mnb_warband\languages\ko\item_kinds.csv
  File .\src\mnb_warband\languages\ko\game_menus.csv
  File .\src\mnb_warband\languages\ko\info_pages.csv
  File .\src\mnb_warband\languages\ko\quick_strings.csv
  File .\src\mnb_warband\languages\ko\hints.csv
  File .\src\mnb_warband\languages\ko\item_modifiers.csv
  File .\src\mnb_warband\languages\ko\parties.csv
  File .\src\mnb_warband\languages\ko\party_templates.csv
  File .\src\mnb_warband\languages\ko\quests.csv
  File .\src\mnb_warband\languages\ko\skills.csv
  File .\src\mnb_warband\languages\ko\skins.csv
  File .\src\mnb_warband\languages\ko\uimain.csv

SectionEnd

;--------------------------------
;Installer Sections

Section /o "Pendor: Korean" SecPendor
  SetOutPath "${PENDOR_DIR}"  
  File .\src\prophecy_of_pendor\info_pages.txt

  ; korean data
  SetOutPath "${PENDOR_DIR}\languages\ko"
  File .\src\prophecy_of_pendor\languages\ko\factions.csv
  File .\src\prophecy_of_pendor\languages\ko\troops.csv
  File .\src\prophecy_of_pendor\languages\ko\dialogs.csv
  File .\src\prophecy_of_pendor\languages\ko\ui.csv
  File .\src\prophecy_of_pendor\languages\ko\game_strings.csv
  File .\src\prophecy_of_pendor\languages\ko\item_kinds.csv
  File .\src\prophecy_of_pendor\languages\ko\game_menus.csv
  File .\src\prophecy_of_pendor\languages\ko\info_pages.csv
  File .\src\prophecy_of_pendor\languages\ko\quick_strings.csv
  File .\src\prophecy_of_pendor\languages\ko\hints.csv
  File .\src\prophecy_of_pendor\languages\ko\item_modifiers.csv
  File .\src\prophecy_of_pendor\languages\ko\parties.csv
  File .\src\prophecy_of_pendor\languages\ko\party_templates.csv
  File .\src\prophecy_of_pendor\languages\ko\quests.csv
  File .\src\prophecy_of_pendor\languages\ko\skills.csv
  File .\src\prophecy_of_pendor\languages\ko\skins.csv
  File .\src\prophecy_of_pendor\languages\ko\uimain.csv

SectionEnd

Section /o "Pendor: Show Unique Troops" SecPendorNeutral

  SetOutPath "${PENDOR_DIR}"  
  File .\src\prophecy_of_pendor\party_templates.txt

SectionEnd


;--------------------------------
;Descriptions

  ;Language strings
  LangString DESC_SecDummy ${LANG_ENGLISH} "A test section."

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    ;!insertmacro MUI_DESCRIPTION_TEXT ${SecDummy} $(DESC_SecDummy)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

