@echo off

echo Check for new versions of the script at https://sites.google.com/view/updatex
echo.
echo Hello there, this script will update your installed apps with Winget.
echo.
echo Some apps might not update due to having an unknown version or it updates directly from the app.
echo.

set /p proceed=Do you want to proceed? [y/n]

if /i "%proceed%"=="y" (
    echo Updating package list...
    winget update

    where winget >nul 2>nul || (
        echo Installing winget...
        powershell.exe -c "Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/latest/download/winget-cli-windows-x86_64.zip -OutFile winget.zip"
        powershell.exe -c "Expand-Archive -Path .\winget.zip -DestinationPath .\winget"
        set "PATH=%PATH%;%CD%\winget"
    )

    set /p include_unknown=Do you want to include updates for apps with unknown versions? [y/n]

    if /i "%include_unknown%"=="y" (
        echo Upgrading all packages including unknown versions...
        winget upgrade -u --all
    ) else (
        echo Upgrading packages with known versions only...
        winget upgrade --all
    )

    echo It is recommended to restart after the updates

pause