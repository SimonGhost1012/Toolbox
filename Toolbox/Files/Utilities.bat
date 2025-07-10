@echo off
title Toolbox System Utilities - Ghost
chcp 65001 >nul
mode 125, 30

:: Check for admin privileges
>nul 2>&1 net session
if %errorLevel% neq 0 (
    echo Requesting Administrative Privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:menu
cls
echo.
echo [38;5;243m ╔══════════════════════════════════════════════════╗[0m
echo [38;5;243m ║         TOOLBOX SYSTEM UTILITIES - GHOST         ║[0m
echo [38;5;245m ╠══════════════════════════════════════════════════╣[0m
echo [38;5;247m ║  1. System File Checker [SFC]                    ║[0m
echo [38;5;247m ║  2. DISM Health Restore                          ║[0m
echo [38;5;247m ║  3. Run Check Disk [CHKDSK]                      ║[0m
echo [38;5;247m ║  4. Reset IP Stack                               ║[0m
echo [38;5;247m ║  5. Reset Winsock                                ║[0m
echo [38;5;247m ║  6. Flush DNS Cache                              ║[0m
echo [38;5;247m ║  7. Run Disk Cleanup                             ║[0m
echo [38;5;245m ║  8. Exit                                         ║[0m
echo [38;5;243m ╚══════════════════════════════════════════════════╝[0m
echo.
choice /c 12345678 /n /m "[38;5;245m Select An Option : [0m

if "%choice%"=="1" goto sfc_scan
if "%choice%"=="2" goto dism_restore
if "%choice%"=="3" goto chkdsk_run
if "%choice%"=="4" goto reset_ip
if "%choice%"=="5" goto reset_winsock
if "%choice%"=="6" goto flush_dns
if "%choice%"=="7" goto disk_cleanup
if "%choice%"=="8" exit
goto menu

:sfc_scan
cls
echo [38;5;247m Running System File Checker [SFC][0m
sfc /scannow
echo.
pause
goto menu

:dism_restore
cls
echo [38;5;247m Running DISM Health Restore...[0m
dism /online /cleanup-image /restorehealth
echo.
pause
goto menu

:chkdsk_run
cls
echo [38;5;247m Running Check Disk [CHKDSK][0m
chkdsk C:
echo.
pause
goto menu

:reset_ip
cls
echo [38;5;247m Resetting IP Stack...[0m
netsh int ip reset
echo.
pause
goto menu

:reset_winsock
cls
echo [38;5;247m Resetting Winsock...[0m
netsh winsock reset
echo.
pause
goto menu

:flush_dns
cls
echo [38;5;247m Flushing DNS Cache...[0m
ipconfig /flushdns
echo.
pause
goto menu

:disk_cleanup
cls
echo [38;5;247m Running Disk Cleanup...[0m
cleanmgr
echo.
pause
goto menu
