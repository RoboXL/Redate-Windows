@echo off

REM Define variables
set "repoUrl=https://github.com/RoboXL/Redate-Windows/archive/refs/heads/main.zip"
set "tempDir=%TEMP%"
set "downloadPath=%tempDir%\Redate.zip"
set "extractPath=%tempDir%\Redate"
set "scriptPath=%extractPath%\Redate-Windows-main\Redate.bat"
set "destinationFolder=%USERPROFILE%\Redate"
set "destinationPath=%destinationFolder%\Redate.bat"
set "shortcutPath=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Redate.lnk"

echo ---------------------------------------
echo This script will Update Redate-Windows
echo ---------------------------------------

set /p "choice=Do you want to continue with the Update? (Y/N): "
if /i "%choice%" neq "Y" exit

REM Download the repository zip file
echo:
echo -----------------------------------------
powershell.exe -Command "(New-Object System.Net.WebClient).DownloadFile('%repoUrl%', '%downloadPath%')"
echo -----------------------------------------
echo:

cls

REM Extract the contents of the zip file
echo -----------------------------------------
powershell.exe -Command "Expand-Archive -Path '%downloadPath%' -DestinationPath '%extractPath%' -Force"
echo -----------------------------------------
echo:

cls

REM Create the destination folder if it doesn't exist
echo -----------------------------------------
mkdir "%destinationFolder%" 2>nul
echo -----------------------------------------
echo:

cls

REM Move the script to the desired location
move /Y "%scriptPath%" "%destinationPath%"

REM Create a shortcut in the Start Menu folder
powershell.exe -Command "$shell = New-Object -ComObject WScript.Shell; $shortcut = $shell.CreateShortcut('%shortcutPath%'); $shortcut.TargetPath = '%destinationPath%'; $shortcut.Save()"

cls

REM Clean up temporary files
del "%downloadPath%" /F /Q
rmdir "%extractPath%" /S /Q

cls

echo ----------------------------------------
echo Redate-Windows update completed.
echo ---------------------------------------
echo:

set /p proceed=Do you want to proceed [Type Y for yes and N for no] [y/n]

if /i "%proceed%"=="y" (

\Redate-Windows-main\Redate.bat

echo:
) else (
    
)

pause
