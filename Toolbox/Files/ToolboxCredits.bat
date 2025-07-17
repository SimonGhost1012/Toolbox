@echo off
title Toolbox Credits - Ghost
mode 80, 20
chcp 65001 >nul

>nul 2>&1 reg query HKCU\Console || >nul reg add HKCU\Console /f

reg query HKCU\Console /v VirtualTerminalLevel 2>nul | findstr /r /c:"0x1" >nul
if errorlevel 1 (
    >nul reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f

    echo ANSI Support Enabled. Restarting Script...
    timeout /t 1 >nul

    start "" "%~f0" %*
    exit /b
)

cls
echo.
echo.
ping localhost -n 2 >nul
echo [38;5;243m ╔═════════════════════════════════╗[0m
ping localhost -n 1 >nul
echo [38;5;243m ║   CREDITS FOR TOOLBOX - GHOST   ║[0m
ping localhost -n 1 >nul
echo [38;5;243m ╠═════════════════════════════════╣[0m
ping localhost -n 1 >nul
echo [38;5;243m ║		    	           ║
ping localhost -n 1 >nul
echo [38;5;245m ║     Owner/Developer/Forked:[0m[38;5;245m     ║
ping localhost -n 1 >nul
echo [38;5;245m ║     - SimonGhost1012[38;5;245m            ║
ping localhost -n 1 >nul
echo [38;5;245m ║                                 ║
ping localhost -n 1 >nul
echo [38;5;245m ║     Owner:[0m[38;5;245m                      ║
ping localhost -n 1 >nul
echo [38;5;247m ║     - Ebola Man[38;5;247m                 ║
ping localhost -n 1 >nul
echo [38;5;247m ║                                 ║
ping localhost -n 1 >nul
echo [38;5;247m ║     Beta Tester:[38;5;247m                ║
ping localhost -n 1 >nul
echo [38;5;247m ║     - FireFlyHD[0m[38;5;247m                 ║
ping localhost -n 1 >nul
echo [38;5;245m ║                                 ║
ping localhost -n 1 >nul
echo [38;5;245m ║     YouTube:[0m[38;5;245m                    ║
ping localhost -n 1 >nul
echo [38;5;245m ║     - Ebola Man[0m[38;5;245m                 ║
ping localhost -n 1 >nul
echo [38;5;245m ║                                 ║
ping localhost -n 1 >nul
echo [38;5;243m ║     Original Batch Creator:[0m[38;5;243m     ║
ping localhost -n 1 >nul
echo [38;5;243m ║     - Ebola Man[0m[38;5;243m                 ║
ping localhost -n 1 >nul
echo [38;5;243m ║	    		           ║
ping localhost -n 1 >nul
echo [38;5;243m ╚═════════════════════════════════╝[0m
ping localhost -n 1 >nul
echo.
ping localhost -n 1 >nul
echo [38;5;245m Thank You For Using Toolbox - Ghost![0m
ping localhost -n 1 >nul
echo.
ping localhost -n 1 >nul
echo [38;5;247m Press Any Key To Return To The Main Menu[0m
pause >nul
exit
