@echo off

echo Check for new versions of the script at https://sites.google.com/view/redate or open "update redate"
echo:
echo What's up %username%? This script will update most of your installed apps with Winget.
echo:
echo Some apps might not update due to having an unknown version. NOTE: Discord is known to fail the update process because it updates itself, ignore it it's normal
echo:

set /p proceed=Do you want to proceed? [y/n]

if /i "%proceed%"=="y" (

    where winget >nul 2>nul || (
        echo Installing winget...
        powershell.exe -c "Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/latest/download/winget-cli-windows-x86_64.zip -OutFile winget.zip"
        powershell.exe -c "Expand-Archive -Path .\winget.zip -DestinationPath .\winget"
        set "PATH=%PATH%;%CD%\winget"
    )

    echo Upgrading packages...
    echo -------------------------------
    winget upgrade --all
    echo -------------------------------
echo:
echo It is recommended that you restart your computer. Also %username% is a cool username
echo:
) else (
    echo:
    echo Updates cancelled. Hope you found this helpful
)

echo off
pause