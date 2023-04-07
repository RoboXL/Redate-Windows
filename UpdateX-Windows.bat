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

    echo Upgrading packages...
    winget upgrade --all

    echo Cleaning up...
    winget clean

    set /p restart=Packages have been updated. Do you want to restart your computer now? [y/n]
    if /i "%restart%"=="y" (
        shutdown /r /t 0
    )
) else (
    echo Update cancelled.
)
