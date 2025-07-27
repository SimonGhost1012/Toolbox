@echo off
title Toolbox Cleaner - Ghost
chcp 65001 >nul

>nul 2>&1 net session
if %errorLevel% neq 0 (
    echo Requesting Administrative Privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

>nul 2>&1 reg query HKCU\Console || >nul reg add HKCU\Console /f

reg query HKCU\Console /v VirtualTerminalLevel 2>nul | findstr /r /c:"0x1" >nul
if errorlevel 1 (
    >nul reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f

    echo ANSI Support Enabled. Restarting Script...
    timeout /t 1 >nul

    start "" "%~f0" %*
    exit /b
)

:menu
cls
echo.
echo [38;5;243m ╔═════════════════════════════════════════╗[0m
echo [38;5;243m ║         TOOLBOX CLEANER - GHOST         ║[0m
echo [38;5;245m ╠═════════════════════════════════════════╣[0m
echo [38;5;247m ║  1. Clean Local Temp                    ║[0m
echo [38;5;247m ║  2. Clean User Temp                     ║[0m
echo [38;5;247m ║  3. Clean Windows Temp                  ║[0m
echo [38;5;247m ║  4. Clean Windows Update Cache          ║[0m
echo [38;5;247m ║  5. Clean Prefetch                      ║[0m
echo [38;5;247m ║  6. Empty Recycle Bin                   ║[0m
echo [38;5;245m ║  7. Run Full Cleanup                    ║[0m
echo [38;5;243m ║  E. Exit                                ║[0m
echo [38;5;243m ╚═════════════════════════════════════════╝[0m
echo.
choice /c 1234567E /n /m "[38;5;245m Select An Option : [0m"
set "choice=%errorlevel%"

if "%choice%"=="1" goto clean_local
if "%choice%"=="2" goto clean_user
if "%choice%"=="3" goto clean_windows
if "%choice%"=="4" goto clean_windows_update
if "%choice%"=="5" goto clean_prefetch
if "%choice%"=="6" goto empty_recycle
if "%choice%"=="7" goto full_clean
if "%choice%"=="8" (
    exit /b
)
goto menu

:clean_local
cls
echo [38;5;247m Cleaning Local Temp [%LOCALAPPDATA%\Temp][0m
del /s /q /f "%LOCALAPPDATA%\Temp\*.*" >nul 2>&1
del /s /q /f "%USERPROFILE%\Local Settings\Temp\*.*" >nul 2>&1
echo  Done!
pause
goto menu

:clean_user
cls
echo [38;5;247m Cleaning User Temp [%TEMP%][0m
del /s /q /f "%TEMP%\*.*" >nul 2>&1
del /s /q /f "%TMP%\*.*" >nul 2>&1
echo  Done!
pause
goto menu

:clean_windows
cls
echo [38;5;247m Cleaning Windows Temp [%WINDIR%\Temp][0m
del /s /q /f "%WINDIR%\Temp\*.*" >nul 2>&1
for /d %%p in ("%WINDIR%\Temp\*") do rmdir /s /q "%%p"
echo  Done!
pause
goto menu

:clean_windows_update
cls
echo [38;5;247m Cleaning Windows Update Cache[0m
net stop wuauserv >nul 2>&1
del /s /q /f "%WINDIR%\SoftwareDistribution\Download\*.*" >nul 2>&1
for /d %%p in ("%WINDIR%\SoftwareDistribution\Download\*") do rmdir /s /q "%%p"
net start wuauserv >nul 2>&1
echo  Done!
pause
goto menu

:clean_prefetch
cls
echo [38;5;247m Cleaning Prefetch [%WINDIR%\Prefetch][0m
del /s /q /f "%WINDIR%\Prefetch\*.*" >nul 2>&1
for /d %%p in ("%WINDIR%\Prefetch\*") do rmdir /s /q "%%p"
echo  Done!
pause
goto menu

:empty_recycle
cls
echo [38;5;247m Emptying Recycle Bin[0m
"%~dp0nircmd.exe" emptybin
echo  Done!
pause
goto menu

:full_clean
cls
echo [38;5;247m Running Full Cleanup[0m
call :clean_local
call :clean_user
call :clean_windows
call :clean_windows_update
call :clean_prefetch
call :empty_recycle
echo  Full Cleanup Done!
pause
goto menu