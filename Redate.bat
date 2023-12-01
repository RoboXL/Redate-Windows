@echo off

echo Check for new versions of the script at https://sites.google.com/view/redate or open "update redate"
echo:
echo What's up %username%? I'm going to update your apps with Winget. Is that ok?
echo:
echo Some apps might not update due to having an unknown version. NOTE: Discord and it's dependencies are known to fail the update process because Discord updates itself, ignore it it's normal
echo:

set /p proceed=Do you want to proceed [Type Y for yes and N for no] [y/n]

if /i "%proceed%"=="y" (

    where winget >nul 2>nul || (
        echo Installing winget...
        powershell.exe -c "Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/latest/download/winget-cli-windows-x86_64.zip -OutFile winget.zip"
        powershell.exe -c "Expand-Archive -Path .\winget.zip -DestinationPath .\winget"
        set "PATH=%PATH%;%CD%\winget"
    )

    echo Updading Apps...
    echo -------------------------------
    winget upgrade --all
    echo -------------------------------
echo:
echo It is recommended that you restart your computer after some updates. Thank you for using Redate!
echo:
) else (
    echo:
    echo Updates cancelled. Hope you found this helpful
)

echo off
pause