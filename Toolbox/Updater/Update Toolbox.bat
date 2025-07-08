@echo off
title Toolbox Updater - Ghost
color 4
setlocal

REM Set CURRENT_DIR to the directory where the script is located
set "CURRENT_DIR=%~dp0"

REM Ensure we are running the script from the CURRENT_DIR
cd /d "%CURRENT_DIR%"

REM Set EXTRACT_DIR to the Toolbox folder directly (not Updater\Toolbox)
set "EXTRACT_DIR=%CURRENT_DIR%\Toolbox"

REM Check for 7-Zip path (same as before)
for /f "tokens=2*" %%A in ('reg query "HKLM\SOFTWARE\7-Zip" /v Path') do (
    set "SevenZipPath=%%B7z.exe"
)

REM If not found in the registry, search PATH
if not exist "%SevenZipPath%" (
    for %%A in (7z.exe) do set "SevenZipPath=%%~$PATH:A"
)

REM If still not found, report an error
if not exist "%SevenZipPath%" (
    echo 7-Zip could not be found. Please ensure it is installed and in your PATH.
    pause
    exit /b 1
)

REM Fetch the latest release information from GitHub
echo Fetching Latest Release Information From GitHub...
curl -s https://api.github.com/repos/SimonGhost1012/Toolbox/releases/latest > release.json

REM Extract the latest version number from GitHub
for /f "delims=" %%i in ('jq -r ".tag_name" release.json') do (
    set "LATEST_VERSION=%%i"
)

REM Debugging: Display the latest version
echo Latest Version From GitHub: %LATEST_VERSION%

REM Check if the local Version.txt exists
if not exist "%CURRENT_DIR%\Version.txt" (
    echo No Local Version.txt Found. Updating Toolbox...
    goto UPDATE
)

REM Read the local version from Version.txt
set /p LOCAL_VERSION=<"%CURRENT_DIR%\Version.txt"

REM Compare the local version with the latest version
if %LOCAL_VERSION%==%LATEST_VERSION% (
    echo Your Toolbox Is Up-To-Date.
    del release.json
    pause
    endlocal
    exit /b 0
)

REM Notify the user of the update
echo A New Version Of Toolbox Is Available. Updating Now...

:UPDATE
REM Extract the correct download URL for the latest Toolbox.zip
for /f "delims=" %%i in ('jq -r ".assets[] | select(.name | test(\"Toolbox.*.zip\")) | .browser_download_url" release.json') do (
    set "DOWNLOAD_URL=%%i"
)

REM Download the Toolbox.zip if not present
echo Downloading Toolbox.zip From: %DOWNLOAD_URL%
curl -L -o Toolbox.zip %DOWNLOAD_URL%

REM Ensure EXTRACT_DIR exists (create the Toolbox folder)
if not exist "%EXTRACT_DIR%" mkdir "%EXTRACT_DIR%"

REM Use 7-Zip to extract files into the Toolbox folder directly, ensuring no extra folder names
echo Found 7-Zip at: %SevenZipPath%
"%SevenZipPath%" x Toolbox.zip -o"%EXTRACT_DIR%" -y

REM Ensure no extra "Updater" folder remains
if exist "%EXTRACT_DIR%\Updater" (
    move /y "%EXTRACT_DIR%\Updater\*" "%EXTRACT_DIR%\" 
    rmdir /S /Q "%EXTRACT_DIR%\Updater"
)

if errorlevel 1 (
    echo Extraction Failed.
    pause
    exit /b 1
)

REM Overwrite the local Version.txt with the latest version
echo %LATEST_VERSION% > "%CURRENT_DIR%\Version.txt"

REM Cleanup
del Toolbox.zip
del release.json

REM Notify the user
echo Update Complete. Files Are Located In The "%EXTRACT_DIR%" Folder.
pause
endlocal
