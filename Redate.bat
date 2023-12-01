@echo off

echo Check for new versions of the script at https://sites.google.com/view/redate or open "update redate"
echo:
echo Some apps might not update due to having an unknown version. NOTE: Discord and it's dependencies are known to fail the update process because Discord updates itself, ignore it it's normal
echo:
echo What's up %username%? This script is going to update your apps with Winget. Is that ok?
echo:

set /p proceed=Do you want to proceed [Type Y for yes and N for no] [y/n]

if /i "%proceed%"=="y" (

    where winget >nul 2>nul || (
        echo "Winget is not detected on this system :< Please install it from https://apps.microsoft.com/detail/9NBLGGH4NNS1 or search for app installer on the microsoft store"
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