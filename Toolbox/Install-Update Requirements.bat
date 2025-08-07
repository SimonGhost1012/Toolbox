@echo off
title Toolbox Requirements Installer-Updater - Ghost

echo Installing And Updating Requirements
timeout /t 1 >nul
cls
echo Installing And Updating Requirements .
timeout /t 1 >nul
cls
echo Installing And Updating Requirements ..
timeout /t 1 >nul
cls
echo Installing And Updating Requirements ...
timeout /t 1 >nul
cls

powershell -Command "try { Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; Write-Output 'Execution Policy Set Successfully.' } catch { Write-Output 'Failed To Set Execution Policy.'; exit 1 }"

powershell -Command "try { iwr get.scoop.sh -useb | iex; Write-Output 'Scoop Installed Successfully.' } catch { Write-Output 'Failed To Install Scoop.'; exit 1 }"

echo Verifying Scoop Installation
where scoop >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Scoop Not found. Adding Scoop To PATH
    set "PATH=%PATH%;%USERPROFILE%\scoop\shims"
)

winget install --id Microsoft.WindowsTerminal --source winget --accept-package-agreements --accept-source-agreements
winget upgrade --id Microsoft.WindowsTerminal --source winget --accept-package-agreements --accept-source-agreements

call scoop update
call scoop install 7zip
call scoop install git
call scoop install jq
call scoop install curl
call scoop update 7zip
call scoop update git
call scoop update jq
call scoop update curl

echo Install-Update Complete
pause
exit
