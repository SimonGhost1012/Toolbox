@echo off

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

title Toolbox VMware - Ghost
setlocal enabledelayedexpansion

echo Force stopping VMware services...

set "vmwareServices=VMAuthdService VMnetDHCP VMnetNatSvc VMUSBArbService VGAuthService"

for %%s in (%vmwareServices%) do (
    echo Stopping service %%s...
    sc stop "%%s" >nul 2>&1
    timeout /t 1 >nul
)

timeout /t 2 >nul

echo Killing VMware processes...

set "vmwareProcesses=vmware.exe vmware-authd.exe vmware-hostd.exe vmware-vmx.exe vmware-tray.exe vmware-usbarbitrator64.exe vmplayer.exe vmware-vmrc.exe vmware-unity-helper.exe vmnat.exe vmtoolsd.exe vm3dservice.exe"

for %%p in (%vmwareProcesses%) do (
    echo Killing process %%p...
    taskkill /F /IM %%p /T >nul 2>&1
)

for /F "tokens=1" %%i in ('tasklist ^| findstr /I "vmware vmnat vmtoolsd vm3dservice"') do (
    echo Killing leftover process %%i...
    taskkill /F /IM %%i /T >nul 2>&1
)

echo.
echo All VMware Services And Processes Have Been Stopped.
endlocal
exit
