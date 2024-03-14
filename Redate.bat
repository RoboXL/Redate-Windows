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
    echo choco failed to install. Please install it manually at https://community.chocolatey.org/
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

choco install winget
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
mode 106, 20

echo:
echo:                                           ^|Redate Options^|
echo:
echo:
echo: #  [1] Update All apps ^| Updates All of your apps using winget ^| May require Administrator priviliges #
echo: #  [2] pending         ^|                                       ^|                                      #
echo: #  [3] pending         ^|                                       ^|                                      #
echo: #  [4] pending         ^|                                       ^|                                      #
echo: #  __________________________________________________________________________________________________ #   
echo: #                                                                                                     #
echo: #  [5] Help                                                                                           #
echo: #  [6] Extras                                                                                         #
echo: #  [0] Exit                                                                                           #
echo: #  __________________________________________________________________________________________________ #
echo:
echo: Enter a menu option in the Keyboard [1,2,3,4,5,6,0]:
choice /C:1234560 /N >nul 2>nul 
set _erl=%errorlevel%

if %_erl%==7 exit /b
if %_erl%==6 setlocal & call :extra & endlocal & goto :mainmenu
if %_erl%==5 start https://sites.google.com/view/redate/support/faq & goto :MainMenu
if %_erl%==4 setlocal & call      & cls & endlocal & goto :MainMenu
if %_erl%==3 setlocal & call    & cls & endlocal & goto :MainMenu
if %_erl%==2 setlocal & call    & cls & endlocal & goto :MainMenu
if %_erl%==1 setlocal & call :wingetupdate & cls & endlocal & goto :MainMenu
goto :MainMenu

==========================================================================================================================

:extra

cls
color 0c
title  Redate Windows
mode 106, 20

echo:
echo:                                           ^|Extras^|
echo:
echo:
echo: #  [1] Chris Titus winutil ^| Runs the Chris Titus Winutil                                              #
echo: #  [2] Download More ram   ^| Downloads more ram (Joke)                                                 #
echo: #  __________________________________________________________________________________________________ # 
echo: #                                                                                                     #
echo: #  [0] Exit to main menu                                                                              #
echo: #  __________________________________________________________________________________________________ #
echo:
echo: Enter a menu option in the Keyboard [1,2,3,4,5,0]:
choice /C:120 /N >nul 2>nul 
set __erl=%errorlevel%

if %__erl%==3 exit /b 
if %__erl%==2 start https://www.youtube.com/watch?v=dQw4w9WgXcQ & goto :extra
if %__erl%==1 powershell.exe -Command "iwr -useb https://christitus.com/win | iex" & exit /b 
goto :extra

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