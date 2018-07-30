; NSIS 3.x
!include 'LogicLib.nsh'
!include 'WinMessages.nsh'

!define INSTALLER_VERSION     "0.0.14"
!define INSTALLER_NAME        "Mount & Blade: Warband Korean Patch"
!define INSTALLER_FILE_BASE   "mnb_warband_ko_patch"
!define TITLE_NAME            "${INSTALLER_NAME} ${INSTALLER_VERSION}"
!define INSTALLER_FILE_NAME   "${INSTALLER_FILE_BASE}_${INSTALLER_VERSION}.exe"

; compression
SetCompress					auto 	; (auto|force|off)
SetCompressor				lzma	; (zlib|bzip2|lzma)

; ==================================
; "StrRep"
; ==================================
!define StrRep "!insertmacro StrRep"
!macro StrRep output string old new
    Push `${string}`
    Push `${old}`
    Push `${new}`
    !ifdef __UNINSTALL__
        Call un.StrRep
    !else
        Call StrRep
    !endif
    Pop ${output}
!macroend
 
!macro Func_StrRep un
    Function ${un}StrRep
        Exch $R2 ;new
        Exch 1
        Exch $R1 ;old
        Exch 2
        Exch $R0 ;string
        Push $R3
        Push $R4
        Push $R5
        Push $R6
        Push $R7
        Push $R8
        Push $R9
 
        StrCpy $R3 0
        StrLen $R4 $R1
        StrLen $R6 $R0
        StrLen $R9 $R2
        loop:
            StrCpy $R5 $R0 $R4 $R3
            StrCmp $R5 $R1 found
            StrCmp $R3 $R6 done
            IntOp $R3 $R3 + 1 ;move offset by 1 to check the next character
            Goto loop
        found:
            StrCpy $R5 $R0 $R3
            IntOp $R8 $R3 + $R4
            StrCpy $R7 $R0 "" $R8
            StrCpy $R0 $R5$R2$R7
            StrLen $R6 $R0
            IntOp $R3 $R3 + $R9 ;move offset by length of the replacement string
            Goto loop
        done:
 
        Pop $R9
        Pop $R8
        Pop $R7
        Pop $R6
        Pop $R5
        Pop $R4
        Pop $R3
        Push $R0
        Push $R1
        Pop $R0
        Pop $R1
        Pop $R0
        Pop $R2
        Exch $R1
    FunctionEnd
!macroend
!insertmacro Func_StrRep ""
!insertmacro Func_StrRep "un."

Function CloseProgram 
  Exch $1
  Push $0
  loop:
    FindWindow $0 $1
    IntCmp $0 0 done
      ${If} ${Cmd} 'MessageBox MB_YESNO "����带 �����Ϸ� �մϴ�. �����Ͻðڽ��ϱ�? No�� ������ ��ġ�� ��ҵ˴ϴ�." IDNO'
          MessageBox mb_ok '��ġ�� �����մϴ�.'
          Quit
      ${EndIf}

      #SendMessage $0 ${WM_DESTROY} 0 0
      SendMessage $0 ${WM_CLOSE} 0 0
    Sleep 500 
    Goto loop 
  done: 
  Pop $0 
  Pop $1
FunctionEnd

Function un.CloseProgram 
  Exch $1
  Push $0
  loop:
    FindWindow $0 $1
    IntCmp $0 0 done
      #SendMessage $0 ${WM_DESTROY} 0 0
      SendMessage $0 ${WM_CLOSE} 0 0
    Sleep 100 
    Goto loop 
  done: 
  Pop $0 
  Pop $1
FunctionEnd


; ==================================
; Env
; ==================================
!define WARBAND_DIR           "$INSTDIR"
!define WARBAND_NATIVE_DIR    "$INSTDIR\Modules\Native"
!define PENDOR_DIR            "$INSTDIR\..\..\workshop\content\48700\875202420"
!define AWOIAF_DIR            "$INSTDIR\..\..\workshop\content\48700\948075218"
!define TLD_DIR               "$INSTDIR\..\..\workshop\content\48700\299974223"
!define PERISNO_DIR           "$INSTDIR\..\..\workshop\content\48700\316610148"
!define PW_DIR                "$INSTDIR\Modules\PW_4.5"


InstallDir "fuck me \steamapps\common\MountBlade Warband"

; ==================================
; "GetMyDocs"
; ==================================
Function "GetMyDocs"
  ReadRegStr $0 HKCU \
             "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" \
             Personal
FunctionEnd

; ==================================
; "GetSteamDir"
; ==================================
Function "GetSteamDir"
  ; Computer\HKEY_CURRENT_USER\Software\Valve\Steam
  ReadRegStr $0 HKCU \
             "SOFTWARE\Valve\Steam" \
             SteamPath

  ${StrRep} '$0' '$0' '/' '\'
  StrCpy $INSTDIR "$0\steamapps\common\MountBlade Warband"

FunctionEnd

; ==================================
; "GetWarbandFolder"
; ==================================
Function "GetWarbandFolder"
  Call "GetSteamDir"
  StrCpy $0 "$0\steamapps\common\MountBlade Warband"
FunctionEnd


; ==================================
; "GetEnvFolder"
; ==================================
Function "GetEnvFolder"
  Call "GetMyDocs"
  StrCpy $0 "$0\Mount&Blade Warband"
FunctionEnd

; ==================================
; "CheckRequirement"
; ==================================
Function "CheckRequirement"

  ClearErrors
  Call "GetWarbandFolder"
  IfErrors 0 NoErrorSteam

  ${If} ${Cmd} 'MessageBox MB_YESNO "���� ��ġ ���丮�� �߰����� ���߽��ϴ�. ��ġ�� ����Ϸ��� ��ġ�� ����Ʈ&���̵� ����� ��ġ�� ������ ���� �����ؾ� �մϴ�. ��ġ�� ��� �ϰڽ��ϱ�?" IDNO'
      MessageBox mb_ok '��ġ�� �����մϴ�.'
      Quit
  ${EndIf}
  NoErrorSteam:

  ; MessageBox mb_ok '$0\mb_warband.exe'
  IfFileExists $0\mb_warband.exe 0 +2
  goto NoErrorWarband

  ${If} ${Cmd} 'MessageBox MB_YESNO "����尡 ��ġ ���� �ʾҽ��ϴ�. ��ġ�� ��� �ϰڽ��ϱ�?" IDNO'
      MessageBox mb_ok '��ġ�� �����մϴ�.'
      Quit
  ${EndIf}

  NoErrorWarband:

  ClearErrors 
  Call "GetEnvFolder"
  ; MessageBox mb_ok '$0\language.txt'
  IfFileExists $0\language.txt 0 +2  
  goto NoErrorWarbandEnv

  ${If} ${Cmd} 'MessageBox MB_YESNO "����� ���� ������ ã�� ���Ͽ����ϴ�. ����尡 ��ġ�� ���� �ʾҰų� ��������� �����ϴ�. ��ġ�� ����Ϸ��� ����带 �ּ� 1ȸ �������ּ���. ��ġ�� ��� �ϰڽ��ϱ�?" IDNO'
      MessageBox mb_ok '��ġ�� �����մϴ�.'
      Quit
  ${EndIf}

  NoErrorWarbandEnv:

  NoErrorPendor:

  goto FunExit

  ${If} ${Cmd} 'MessageBox MB_YESNO "���� ����. ��ġ�� ��� �ϰڽ��ϱ�?" IDNO' ;notice the quotes here
      MessageBox mb_ok '��ġ�� �����մϴ�.'
      Quit
  ${EndIf}

  FunExit:
FunctionEnd


Function .onInit
  InitPluginsDir

  ;Get the skin file to use
  File /oname=$PLUGINSDIR\Windows10Dark.vsf ".\Windows10Dark.vsf"

; NEED TO INSTALL; nsis vcl-styles-plugins
; https://github.com/RRUZ/vcl-styles-plugins/releases/tag/1.5.4.1

; eanble for black theme
; NSISVCLStyles::LoadVCLStyle $PLUGINSDIR\Windows10Dark.vsf

  Call "CheckRequirement"

  ; ����� ���� �õ�

  Push "#32770 (Dialog)"
  Call CloseProgram

  Sleep 500 

  Push "MB Window"
  Call CloseProgram

FunctionEnd

;--------------------------------
;Include Modern UI
 
  !include "MUI2.nsh"

; The name of the installer
Name "${TITLE_NAME}"

; The file to write
OutFile "${INSTALLER_FILE_NAME}"

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


Section "!M&B: ����� �ѱ�" SecWarbandVanilla
  SectionIn RO

  Call "GetMyDocs"
  SetOutPath "$0\Mount&Blade Warband"
  File .\src\language.txt

  SetOutPath "${WARBAND_DIR}"
  Rename "${WARBAND_DIR}\mb_warband.exe" "${WARBAND_DIR}\orig.mb_warband.exe"
  File .\src\mb_warband.exe

  ; korean font data
  SetOutPath "${WARBAND_DIR}\data\languages\ko"
  File .\src\mnb_warband\data\languages\ko\font_data.xml
  SetOutPath "${WARBAND_DIR}\textures\languages\ko"
  File .\src\mnb_warband\textures\languages\ko\font.dds

  ; korean data
  SetOutPath "${WARBAND_DIR}\languages\ko"
  File /r /x *.txt .\src\mnb_warband\languages\ko\*.csv

  ; korean font data; to warband native
  SetOutPath "${WARBAND_NATIVE_DIR}\data\languages\ko"
  File .\src\mnb_warband\data\languages\ko\font_data.xml
  SetOutPath "${WARBAND_NATIVE_DIR}\textures\languages\ko"
  File .\src\mnb_warband\textures\languages\ko\font.dds

  ; WARBAND_NATIVE_DIR
  SetOutPath "${WARBAND_NATIVE_DIR}\languages\ko"
  File /r /x *.txt .\src\mnb_warband\languages\ko\*.csv
 
SectionEnd

;--------------------------------
;Installer Sections

SectionGroup "�浵���� ���� 3.9.2"

Section /o "!�ѱ� ��ġ" SecPendor
  ; MessageBox mb_ok '${PENDOR_DIR}\main.bmp'
  IfFileExists "${PENDOR_DIR}\main.bmp" 0 +2  
  goto NoError

  MessageBox mb_iconexclamation|mb_ok "�浵���� ���� ��ġ ������ ã�� ���Ͽ����ϴ�. �浵���� ���������� �۵����� ���� �� �ֽ��ϴ�."

  NoError:

  ; korean font data
  SetOutPath "${PENDOR_DIR}\data\languages\ko"
  File .\src\mnb_warband\data\languages\ko\font_data.xml
  SetOutPath "${PENDOR_DIR}\textures\languages\ko"
  File .\src\mnb_warband\textures\languages\ko\font.dds

  SetOutPath "${PENDOR_DIR}"
  File .\src\prophecy_of_pendor\info_pages.txt

  ; korean data
  SetOutPath "${PENDOR_DIR}\languages\ko"
  File /r /x *.txt .\src\prophecy_of_pendor\languages\ko\*.csv

SectionEnd

Section /o "�߸� ���� �� ǥ��" SecPendorNeutral
  ; MessageBox mb_ok '${PENDOR_DIR}\main.bmp'
  IfFileExists "${PENDOR_DIR}\main.bmp" 0 +2  
  goto NoError

  MessageBox mb_iconexclamation|mb_ok "�浵���� ���� ��ġ ������ ã�� ���Ͽ����ϴ�. �浵���� ���������� �۵����� ���� �� �ֽ��ϴ�."

  NoError:

  SetOutPath "${PENDOR_DIR}"
  ; Rename "${PENDOR_DIR}\party_templates.txt" "${PENDOR_DIR}\orig.party_templates.txt"
  File .\src\prophecy_of_pendor\small_label_party_templates\party_templates.txt

SectionEnd

SectionGroupEnd

SectionGroup "�丮���� 0.81"

Section /o "!�ѱ� ��ġ" SecPerisno
  ; MessageBox mb_ok '${PERISNO_DIR}\main.bmp'
  IfFileExists "${PERISNO_DIR}\main.bmp" 0 +2  
  goto NoError

  MessageBox mb_iconexclamation|mb_ok "�丮���� ��ġ ������ ã�� ���Ͽ����ϴ�. �丮���밡 ���������� �۵����� ���� �� �ֽ��ϴ�."

  NoError:

  Rename "${PERISNO_DIR}\data\font_data.xml" "${PERISNO_DIR}\data\orig.font_data.xml"
  Rename "${PERISNO_DIR}\textures\font.dds" "${PERISNO_DIR}\textures\orig.font.dds"
  ; korean font data
  SetOutPath "${PERISNO_DIR}\data\languages\ko"
  File .\src\mnb_warband\data\languages\ko\font_data.xml
  SetOutPath "${PERISNO_DIR}\textures\languages\ko"
  File .\src\mnb_warband\textures\languages\ko\font.dds

  ; korean data
  SetOutPath "${PERISNO_DIR}\languages\ko"
  File /r /x *.txt .\src\perisno\languages\ko\*.csv

SectionEnd

Section /o "���� ���� ǥ��" SecPersinoTroopLevel
  ; MessageBox mb_ok '${PERISNO_DIR}\main.bmp'
  IfFileExists "${PERISNO_DIR}\main.bmp" 0 +2  
  goto NoError

  MessageBox mb_iconexclamation|mb_ok "�丮���� ��ġ ������ ã�� ���Ͽ����ϴ�. �浵���� ���������� �۵����� ���� �� �ֽ��ϴ�."

  NoError:

  SetOutPath "${PERISNO_DIR}\languages\ko"
  ; Rename "${PENDOR_DIR}\party_templates.txt" "${PENDOR_DIR}\orig.party_templates.txt"
  File /r /x *.txt .\src\perisno\langguage_ko_leveld_troops\*.csv

SectionEnd

Section /o "���� ī�޶� ����" SecPersinoCamera
  ; MessageBox mb_ok '${PERISNO_DIR}\main.bmp'
  IfFileExists "${PERISNO_DIR}\main.bmp" 0 +2  
  goto NoError

  MessageBox mb_iconexclamation|mb_ok "�丮���� ��ġ ������ ã�� ���Ͽ����ϴ�. �丮���밡 ���������� �۵����� ���� �� �ֽ��ϴ�."

  NoError:

  SetOutPath "${PERISNO_DIR}"
  ; Rename "${PENDOR_DIR}\party_templates.txt" "${PENDOR_DIR}\orig.party_templates.txt"
  File .\src\perisno\custom_camera_tweak\mission_templates.txt

SectionEnd
 
SectionGroupEnd


Section /o "(beta) AWOIAF: �ѱ�" SecAWOIAF
  ; MessageBox mb_ok '${PENDOR_DIR}\main.bmp'
  IfFileExists "${AWOIAF_DIR}\main.bmp" 0 +2  
  goto NoError

  MessageBox mb_iconexclamation|mb_ok "AWOIAF ��ġ ������ ã�� ���Ͽ����ϴ�. AWOIAF�� ���������� �۵����� ���� �� �ֽ��ϴ�."

  NoError:

  ; korean font data
  SetOutPath "${AWOIAF_DIR}\data\languages\ko"
  File .\src\mnb_warband\data\languages\ko\font_data.xml
  SetOutPath "${AWOIAF_DIR}\textures\languages\ko"
  File .\src\mnb_warband\textures\languages\ko\font.dds

  ; korean data
  SetOutPath "${AWOIAF_DIR}\languages\ko"
  File /r /x *.txt .\src\awoiaf\languages\ko\*.csv

SectionEnd

/*

SectionGroup "PW 4.5 (��� ��ġ)"

Section /o "!PW 4.5.1: ��� ��ġ" SecPW

  ; korean data
  SetOutPath "${PW_DIR}"
  File /r .\src\pw_4.5.1\*.*

SectionEnd

Section /o "PW 4.5.1: �ѱ�" SecPWKo

  ; korean data
  SetOutPath "${PW_DIR}"
  File /r .\src\pw_4.5.1_ko\*.*

SectionEnd

Section /o "PW 4.5.1: LOD ��ġ" SecPWLOD

  ; korean data
  SetOutPath "${PW_DIR}"
  File /r .\src\pw_4.5.1_lod\*.*

SectionEnd

SectionGroupEnd

*/

