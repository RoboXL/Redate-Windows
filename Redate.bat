@setlocal DisableDelayedExpansion
@echo off

REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

==========================================================================================================================

:welcome
cls
color 0c
Title Welcome to Redate

echo " ______              _                     ";
echo "(_____ \            | |        _           ";
echo " _____) )  ____   _ | |  ____ | |_    ____ ";
echo "(_____ (  / _  ) / || | / _  ||  _)  / _  )";
echo "      | |( (/ / ( (_| |( ( | || |__ ( (/ / ";
echo "      |_| \____) \____| \_||_| \___) \____)";
echo "                                           ";
echo Quick tool to Install and update common apps 
echo Website: https://sites.google.com/view/redate
echo Contact: https://sites.google.com/view/redate/support/contact-me
pause


==========================================================================================================================
WHERE choco >nul 2>nul
if ERRORLEVEL == 1 (
    echo Choco not installed, Installing now... && goto :installchoco
) else (
    echo ================================
    echo. Choco installed, proceeding...
    echo ================================
    goto :wingetcheck
)

==========================================================================================================================

:installchoco
powershell.exe -ExecutionPolicy Bypass -Command "& { Set-ExecutionPolicy Bypass -Scope Process; iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex }"
if ERRORLEVEL == 1 (
    echo choco failed to install. Please install it manually
    start https://community.chocolatey.org/ 
    goto :error
) else (
    goto :wingetcheck
)

==========================================================================================================================

:wingetcheck

WHERE winget >nul 2>nul
if ERRORLEVEL == 1 (
    goto :wingetinstall
) else (     
    echo ==============================================
    echo. Winget installed, proceeding to main menu...
    echo ==============================================
    goto :mainmenu
)
==========================================================================================================================

:wingetinstall

choco install winget-cli
if ERRORLEVEL == 1 (
    echo =========================================================================================================================================================================
    echo. Winget failed to install. Make sure you have app installer installed from the microsoft store, if you cannot find it make sure you are running Windows 10 1709 or later
    echo =========================================================================================================================================================================
    goto :error
) else (
    goto :mainmenu
)



==========================================================================================================================

:mainmenu
cls
color 0c
title  Redate Windows
mode 108, 25

echo:
echo:                                           ^|Redate Options^|
echo:
echo:
echo: # [1] Update All apps      ^| Updates All of your apps             ^| May require Administrator priviliges #
echo: # [2] Install common apps  ^| It's in the name                     ^| List of common apps you can install  #
echo: # [3] Windows Update       ^| Checks for Windows updates           ^| Recommended before updating apps     #
echo: # [4] Uninstall Common apps^| It's in the name (again)             ^|                                      #
echo: #  __________________________________________________________________________________________________    #   
echo: #                                                                                                        #
echo: # [5] Help                                                                                               #
echo: # [6] Extras                                                                                             #
echo: # [0] Exit                                                                                               #
echo: #  __________________________________________________________________________________________________    #
echo:
echo: Enter a menu option in the Keyboard [1,2,3,4,5,6,0]:
choice /C:1234560 /N >nul 2>nul 
set _erl=%errorlevel%

if %_erl%==7 exit /b
if %_erl%==6 setlocal & call :extra & endlocal & goto :mainmenu
if %_erl%==5 start https://sites.google.com/view/redate/support/faq & goto :MainMenu
if %_erl%==4 setlocal & call :Uninstallmenu     & cls & endlocal & goto :MainMenu
if %_erl%==3 setlocal & control update & cls & endlocal & goto :MainMenu
if %_erl%==2 setlocal & call :Installmenu & cls & endlocal & goto :MainMenu
if %_erl%==1 setlocal & call :wingetupdate & cls & endlocal & goto :MainMenu
goto :MainMenu

==========================================================================================================================

:extra

cls
color 0c
title  Redate Extras
mode 108, 20

echo:
echo:                                           ^|Extras^|
echo:
echo:
echo: #  [1] Chris Titus winutil ^| Runs the Chris Titus Winutil                                               #
echo: #  [2] Download More ram   ^| Downloads more ram (Joke)                                                  #
echo: #  [3] Sysinfo             ^| Opens winver and shows system information                                  #
echo: #  __________________________________________________________________________________________________   # 
echo: #                                                                                                       #
echo: #  [0] Exit to main menu                                                                                #
echo: #  __________________________________________________________________________________________________   #
echo:
echo: Enter a menu option in the Keyboard [1,2,3,0]:
choice /C:1230 /N >nul 2>nul 
set __erl=%errorlevel%

if %__erl%==4 exit /b 
if %__erl%==3 start winver & start msinfo32 & goto :extra 
if %__erl%==2 start https://www.youtube.com/watch?v=dQw4w9WgXcQ & goto :extra
if %__erl%==1 powershell.exe -Command "iwr -useb https://christitus.com/win | iex" & exit /b 
goto :extra

==========================================================================================================================

:Installmenu
cls
color 0c
mode 108, 25
Title Redate Windows

echo:
echo:                       ^| Choose the app you want to install (eg. 2 for Firefox ) ^|
echo:----------------------------------------------------------------------------------------------------------
echo:               ^|Browsers^|                      ^|Advanced tools^|                   ^|Gaming^|
echo:                                          
echo: # [1] Chrome Web browser               ^| [12] Git                      ^| [24] Steam                    ^|
echo: # [2] Firefox                          ^| [13] Github Desktop           ^| [25] EA App (Was Origin)      ^|
echo: # [3] Opera Browser                    ^| [14] Unity Hub                ^| [26] Epic Games               ^|
echo: # [4] Opera GX (The gaming browser)    ^| [15] VS Code                  ^| [27] Itch.io                  ^|
echo: # [5] Brave                            ^| [16] Power Toys               ^| [28] GOG                      ^|
echo: # [6] Tor Browser                      ^| [17] Notepad ++               ^| [29] Ubisoft Connect          ^|
echo: # [7] Chromium (Open source chrome)    ^| [18] OBS Studio               ^| [30] Sidequest                ^|
echo:----------------------------------------------------------------------------------------------------------
echo: #          ^|Communication^|             ^| [19] Angry IP Scanner         ^|          ^|Other^|
echo: # [8] Discord                          ^| [20] puTTy                    ^| [31] Rufus                    ^|
echo: # [9] Whatsapp                         ^| [21] 7-Zip (WinRAR but free)  ^| [32] GIMP                     ^|
echo: # [10] Zoom                            ^| [22] Wireshark                ^| [33] Wiztree                  ^|
echo: # [11] Thunderbird                     ^| [23] Google Drive             ^| [34] Motrix Download Manager  ^|
echo:----------------------------------------------------------------------------------------------------------
echo:                                        [99] Exit to main menu
echo:----------------------------------------------------------------------------------------------------------
echo:
set /p "M=Enter a menu option in the Keyboard: "
IF "%M%"=="1" cls & winget.exe install --id Google.Chrome --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="2" cls & winget.exe install --id Mozilla.Firefox --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="3" cls & winget.exe install --id Opera.Opera --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="4" cls & winget.exe install --id Opera.OperaGX --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="5" cls & winget.exe install --id Brave.Brave --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="6" cls & winget.exe install --id TorProject.TorBrowser --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="7" cls & winget.exe install --id Hibbiki.Chromium --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="8" cls & winget.exe install --id Discord.Discord --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="9" cls & winget.exe install --id 9NKSQGP7F2NH --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="10" cls & winget.exe install --id Zoom.Zoom --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="11" cls & winget.exe install --id Mozilla.Thunderbird --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="12" cls & winget.exe install --id Git.Git --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="13" cls & winget.exe install --id GitHub.GitHubDesktop --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="14" cls & winget.exe install --id Unity.UnityHub --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="15" cls & winget.exe install --id Microsoft.VisualStudioCode --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="16" cls & winget.exe install --id XP89DCGQ3K6VLD --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="17" cls & winget.exe install --id Notepad++.Notepad++ --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="18" cls & winget.exe install --id OBSProject.OBSStudio --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="19" cls & winget.exe install --id angryziber.AngryIPScanner --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="20" cls & choco.exe install putty -y & goto :Installmenu
IF "%M%"=="21" cls & winget.exe install --id 7zip.7zip --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="22" cls & choco.exe install wireshark -y & goto :Installmenu
IF "%M%"=="23" cls & winget.exe install --id Google.GoogleDrive --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="24" cls & winget.exe install --id Valve.Steam --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="25" cls & winget.exe install --id ElectronicArts.EADesktop --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="26" cls & winget.exe install --id EpicGames.EpicGamesLauncher --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="27" cls & winget.exe install --id ItchIo.Itch --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="28" cls & winget.exe install --id GOG.Galaxy --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="29" cls & winget.exe install --id Ubisoft.Connect --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="30" cls & winget.exe install --id SideQuestVR.SideQuest --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="31" cls & winget.exe install --id Rufus.Rufus --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="32" cls & winget.exe install --id GIMP.GIMP --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="33" cls & winget.exe install --id AntibodySoftware.WizTree --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="34" cls & winget.exe install --id agalwood.Motrix --exact --accept-source-agreements --accept-package-agreements & goto :Installmenu
IF "%M%"=="99" goto :mainmenu

goto :Installmenu



==========================================================================================================================

:Uninstallmenu
cls
color 0c
mode 108, 25
Title Redate Windows

echo:
echo:            ^| Choose the app you want to Uninstall (Only Choose the ones that you installed ) ^|
echo:----------------------------------------------------------------------------------------------------------
echo:               ^|Browsers^|                      ^|Advanced tools^|                   ^|Gaming^|
echo:                                          
echo: # [1] Chrome Web browser               ^| [12] Git                      ^| [24] Steam                    ^|
echo: # [2] Firefox                          ^| [13] Github Desktop           ^| [25] EA App (Was Origin)      ^|
echo: # [3] Opera Browser                    ^| [14] Unity Hub                ^| [26] Epic Games               ^|
echo: # [4] Opera GX (The gaming browser)    ^| [15] VS Code                  ^| [27] Itch.io                  ^|
echo: # [5] Brave                            ^| [16] Power Toys               ^| [28] GOG                      ^|
echo: # [6] Tor Browser                      ^| [17] Notepad ++               ^| [29] Ubisoft Connect          ^|
echo: # [7] Chromium (Open source chrome)    ^| [18] OBS Studio               ^| [30] Sidequest                ^|
echo:----------------------------------------------------------------------------------------------------------
echo: #          ^|Communication^|             ^| [19] Angry IP Scanner         ^|          ^|Other^|
echo: # [8] Discord                          ^| [20] puTTy                    ^| [31] Rufus                    ^|
echo: # [9] Whatsapp                         ^| [21] 7-Zip (WinRAR but free)  ^| [32] GIMP                     ^|
echo: # [10] Zoom                            ^| [22] Wireshark                ^| [33] Wiztree                  ^|
echo: # [11] Thunderbird                     ^| [23] Google Drive             ^| [34] Motrix Download Manager  ^|
echo:----------------------------------------------------------------------------------------------------------
echo:                                        [99] Exit to main menu
echo:----------------------------------------------------------------------------------------------------------
echo:
set /p "M=Enter a menu option in the Keyboard: "
IF "%M%"=="1" cls & winget.exe rm --id Google.Chrome --exact & goto :Uninstallmenu
IF "%M%"=="2" cls & winget.exe rm --id Mozilla.Firefox --exact & goto :Uninstallmenu
IF "%M%"=="3" cls & winget.exe rm --id Opera.Opera --exact & goto :Uninstallmenu
IF "%M%"=="4" cls & winget.exe rm --id Opera.OperaGX --exact & goto :Uninstallmenu
IF "%M%"=="5" cls & winget.exe rm --id Brave.Brave --exact & goto :Uninstallmenu
IF "%M%"=="6" cls & winget.exe rm --id TorProject.TorBrowser --exact & goto :Uninstallmenu
IF "%M%"=="7" cls & winget.exe rm --id Hibbiki.Chromium --exact & goto :Uninstallmenu
IF "%M%"=="8" cls & winget.exe rm --id Discord.Discord --exact & goto :Uninstallmenu
IF "%M%"=="9" cls & winget.exe rm --id 9NKSQGP7F2NH --exact & goto :Uninstallmenu
IF "%M%"=="10" cls & winget.exe rm --id Zoom.Zoom --exact & goto :Uninstallmenu
IF "%M%"=="11" cls & winget.exe rm --id Mozilla.Thunderbird --exact & goto :Uninstallmenu
IF "%M%"=="12" cls & winget.exe rm --id Git.Git --exact & goto :Uninstallmenu
IF "%M%"=="13" cls & winget.exe rm --id GitHub.GitHubDesktop --exact & goto :Uninstallmenu
IF "%M%"=="14" cls & winget.exe rm --id Unity.UnityHub --exact & goto :Uninstallmenu
IF "%M%"=="15" cls & winget.exe rm --id Microsoft.VisualStudioCode --exact & goto :Uninstallmenu
IF "%M%"=="16" cls & winget.exe rm --id XP89DCGQ3K6VLD --exact & goto :Uninstallmenu
IF "%M%"=="17" cls & winget.exe rm --id Notepad++.Notepad++ --exact & goto :Uninstallmenu
IF "%M%"=="18" cls & winget.exe rm --id OBSProject.OBSStudio --exact & goto :Uninstallmenu
IF "%M%"=="19" cls & winget.exe rm --id angryziber.AngryIPScanner --exact & goto :Uninstallmenu
IF "%M%"=="20" cls & choco.exe Uninstall putty -y & goto :Uninstallmenu
IF "%M%"=="21" cls & winget.exe rm --id 7zip.7zip --exact & goto :Uninstallmenu
IF "%M%"=="22" cls & choco.exe Uninstall wireshark -y & goto :Uninstallmenu
IF "%M%"=="23" cls & winget.exe rm --id Google.GoogleDrive --exact & goto :Uninstallmenu
IF "%M%"=="24" cls & winget.exe rm --id Valve.Steam --exact & goto :Uninstallmenu
IF "%M%"=="25" cls & winget.exe rm --id ElectronicArts.EADesktop --exact & goto :Uninstallmenu
IF "%M%"=="26" cls & winget.exe rm --id EpicGames.EpicGamesLauncher --exact & goto :Uninstallmenu
IF "%M%"=="27" cls & winget.exe rm --id ItchIo.Itch --exact & goto :Uninstallmenu
IF "%M%"=="28" cls & winget.exe rm --id GOG.Galaxy --exact & goto :Uninstallmenu
IF "%M%"=="29" cls & winget.exe rm --id Ubisoft.Connect --exact & goto :Uninstallmenu
IF "%M%"=="30" cls & winget.exe rm --id SideQuestVR.SideQuest --exact & goto :Uninstallmenu
IF "%M%"=="31" cls & winget.exe rm --id Rufus.Rufus --exact & goto :Uninstallmenu
IF "%M%"=="32" cls & winget.exe rm --id GIMP.GIMP --exact & goto :Uninstallmenu
IF "%M%"=="33" cls & winget.exe rm --id AntibodySoftware.WizTree --exact & goto :Uninstallmenu
IF "%M%"=="34" cls & winget.exe rm --id agalwood.Motrix --exact & goto :Uninstallmenu
IF "%M%"=="99" goto :mainmenu

goto :Uninstallmenu



==========================================================================================================================

:wingetupdate

cls

winget upgrade --all
if ERRORLEVEL == 1 (
    echo =======================================================================================================================
    echo. Oh no! Winget failed to update all apps :( You can check the error and troubleshoot it yourself or you can contact me
    echo ======================================================================================================================= 
    goto :error
) else (
    goto :chocoupdate
) 


==========================================================================================================================

:chocoupdate

cls

choco upgrade all -y
if errorlevel == 1 (
    echo ======================================================================================================================
    echo. Oh no! Choco failed to update all apps :( You can check the error and troubleshoot it yourself or you can contact me
    echo ======================================================================================================================
    goto :error
) else (
    goto :mainmenu
)




==========================================================================================================================

:error 

pause

exit