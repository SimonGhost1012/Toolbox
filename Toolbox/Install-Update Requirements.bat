@echo off
title Toolbox Requirements Installer-Updater - Ghost
color 4

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

scoop update & scoop install git & scoop install jq & scoop install curl & scoop update git & scoop update jq & scoop update curl

exit
