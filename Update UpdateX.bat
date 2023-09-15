@echo off

REM Define variables
set "repoUrl=https://github.com/RoboXL/UpdateX-Windows/archive/refs/heads/main.zip"
set "tempDir=%TEMP%"
set "downloadPath=%tempDir%\UpdateX.zip"
set "extractPath=%tempDir%\UpdateX"
set "scriptPath=%extractPath%\UpdateX-Windows-main\UpdateX.bat"
set "destinationFolder=%USERPROFILE%\UpdateX"
set "destinationPath=%destinationFolder%\UpdateX.bat"
set "shortcutPath=%APPDATA%\Microsoft\Windows\Start Menu\Programs\UpdateX.lnk"

echo ---------------------------------------
echo This script will Update UpdateX-Windows
echo ---------------------------------------

set /p "choice=Do you want to continue with the Update? (Y/N): "
if /i "%choice%" neq "Y" exit

REM Download the repository zip file
echo ""
echo -----------------------------------------
powershell.exe -Command "(New-Object System.Net.WebClient).DownloadFile('%repoUrl%', '%downloadPath%')"
echo -----------------------------------------
echo ""

REM Extract the contents of the zip file
echo -----------------------------------------
powershell.exe -Command "Expand-Archive -Path '%downloadPath%' -DestinationPath '%extractPath%' -Force"
echo -----------------------------------------
echo ""

REM Create the destination folder if it doesn't exist
echo -----------------------------------------
mkdir "%destinationFolder%" 2>nul
echo -----------------------------------------
echo ""

REM Move the script to the desired location
move /Y "%scriptPath%" "%destinationPath%"

REM Create a shortcut in the Start Menu folder
powershell.exe -Command "$shell = New-Object -ComObject WScript.Shell; $shortcut = $shell.CreateShortcut('%shortcutPath%'); $shortcut.TargetPath = '%destinationPath%'; $shortcut.Save()"

REM Clean up temporary files
del "%downloadPath%" /F /Q
rmdir "%extractPath%" /S /Q

echo ----------------------------------------
echo UpdateX-Windows update completed.
echo ---------------------------------------
pause
