@echo off

echo Check for new versions of the script at https://sites.google.com/view/updatex or re-run the install script
echo.
echo Hello there, this script will update your installed apps with Winget.
echo.
echo Some apps might not update due to having an unknown version or it updates directly from the app.
echo.

set /p proceed=Do you want to proceed? [y/n]

if /i "%proceed%"=="y" (

    where winget >nul 2>nul || (
        echo Installing winget...
        powershell.exe -c "Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/latest/download/winget-cli-windows-x86_64.zip -OutFile winget.zip"
        powershell.exe -c "Expand-Archive -Path .\winget.zip -DestinationPath .\winget"
        set "PATH=%PATH%;%CD%\winget"
    )

    echo Upgrading packages...
    winget upgrade --all
echo .
echo It is recommended that you restart your computer
echo .
) else (
    echo Update cancelled.
)

echo off
pause