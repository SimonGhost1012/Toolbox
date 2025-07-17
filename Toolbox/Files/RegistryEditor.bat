@echo off
title Toolbox Registry - Ghost

>nul 2>&1 reg query HKCU\Console || >nul reg add HKCU\Console /f

reg query HKCU\Console /v VirtualTerminalLevel 2>nul | findstr /r /c:"0x1" >nul
if errorlevel 1 (
    >nul reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f

    echo ANSI Support Enabled. Restarting Script...
    timeout /t 1 >nul

    start "" "%~f0" %*
    exit /b
)

start regedit.exe

exit