@echo off
title Toolbox Updater - Ghost
setlocal

set "CURRENT_DIR=%~dp0"

cd /d "%CURRENT_DIR%"

set "EXTRACT_DIR=%CURRENT_DIR%\Toolbox"

for /f "tokens=2*" %%A in ('reg query "HKLM\SOFTWARE\7-Zip" /v Path') do (
    set "SevenZipPath=%%B7z.exe"
)

if not exist "%SevenZipPath%" (
    for %%A in (7z.exe) do set "SevenZipPath=%%~$PATH:A"
)

if not exist "%SevenZipPath%" (
    echo 7-Zip could not be found. Please ensure it is installed and in your PATH.
    pause
    exit /b 1
)

echo Fetching Latest Release Information From GitHub...
curl -s https://api.github.com/repos/SimonGhost1012/Toolbox/releases/latest > release.json

for /f "delims=" %%i in ('jq -r ".tag_name" release.json') do (
    set "LATEST_VERSION=%%i"
)

echo Latest Version From GitHub: %LATEST_VERSION%

if not exist "%CURRENT_DIR%\Version.txt" (
    echo No Local Version.txt Found. Updating Toolbox...
    goto UPDATE
)

set /p LOCAL_VERSION=<"%CURRENT_DIR%\Version.txt"

if %LOCAL_VERSION%==%LATEST_VERSION% (
    echo Your Toolbox Is Up-To-Date.
    del release.json
    pause
    endlocal
    exit
)

echo A New Version Of Toolbox Is Available. Updating Now...

:UPDATE
for /f "delims=" %%i in ('jq -r ".assets[] | select(.name | test(\"Toolbox.*.zip\")) | .browser_download_url" release.json') do (
    set "DOWNLOAD_URL=%%i"
)

echo Downloading Toolbox.zip From: %DOWNLOAD_URL%
curl -L -o Toolbox.zip %DOWNLOAD_URL%

if not exist "%EXTRACT_DIR%" mkdir "%EXTRACT_DIR%"

echo Found 7-Zip at: %SevenZipPath%
"%SevenZipPath%" x Toolbox.zip -o"%EXTRACT_DIR%" -y

if exist "%EXTRACT_DIR%\Updater" (
    move /y "%EXTRACT_DIR%\Updater\*" "%EXTRACT_DIR%\" 
    rmdir /S /Q "%EXTRACT_DIR%\Updater"
)

if errorlevel 1 (
    echo Extraction Failed.
    pause
    exit /b 1
)

echo %LATEST_VERSION% > "%CURRENT_DIR%\Version.txt"

del Toolbox.zip
del release.json

echo Update Complete. Files Are Located In The "%EXTRACT_DIR%" Folder.
pause
endlocal
exit
