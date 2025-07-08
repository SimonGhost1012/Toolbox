@echo off
setlocal EnableDelayedExpansion
mode 125, 30
title Toolbox - Ghost
chcp 65001 >nul

if not defined firstRun (
    set firstRun=1
    goto start
) else (
    goto input
)


:start
cls
echo.
echo.
echo.
ping localhost -n 2 >nul
echo [38;5;52m                      ████████╗  ██████╗   ██████╗  ██╗      ██████╗   ██████╗  ██╗  ██╗     ╔═════════════╗[0m
ping localhost -n 1 >nul
echo [38;5;88m                      ╚══██╔══╝ ██╔═══██╗ ██╔═══██╗ ██║      ██╔══██╗ ██╔═══██╗ ╚██╗██╔╝     ║             ║[0m
ping localhost -n 1 >nul
echo [38;5;124m                    	 ██║    ██║   ██║ ██║   ██║ ██║      ██████╔╝ ██║   ██║  ╚███╔╝      ║   Version   ║    [0m
ping localhost -n 1 >nul
echo [38;5;160m                    	 ██║    ██║   ██║ ██║   ██║ ██║      ██╔══██╗ ██║   ██║  ██╔██╗      ║     3.7     ║    [0m
ping localhost -n 1 >nul
echo [38;5;196m                       	 ██║    ╚██████╔╝ ╚██████╔╝ ███████╗ ██████╔╝ ╚██████╔╝ ██╔╝ ██╗     ║             ║    [0m
ping localhost -n 1 >nul
echo [38;5;196m		       	 ╚═╝     ╚═════╝   ╚═════╝  ╚══════╝ ╚═════╝   ╚═════╝  ╚═╝  ╚═╝     ╚═════════════╝[0m
ping localhost -n 1 >nul 
echo.
echo.
echo.
echo.

:input
ping localhost -n 1 >nul
echo    [90;1m                                                                                              ╔═»[0m  [38;5;196m[Update]  [0m [38;5;124m[U][0m
ping localhost -n 1 >nul
echo    [90;1m 											         ╠═»[0m  [38;5;196m[Credits] [0m [38;5;124m[C][0m
ping localhost -n 1 >nul
echo    [90;1m#╦════════════════════════════════════╦═══════════════════════════════════════════════════════╬═»[0m  [38;5;196m[Exit]    [0m [38;5;124m[E][0m
ping localhost -n 1 >nul
echo    [90;1m ║                                    ║                                                       ╚═»[0m  [38;5;196m[PW Gen] [0m [38;5;124m [P][0m
ping localhost -n 1 >nul
echo    [90;1m ╠═══════»[0m  [38;5;196m[Clear Temp Files][0m [38;5;124m[1][0m   [90;1m ╠═══════»[0m  [38;5;196m[Task Manager][0m    [38;5;124m[5][0m
ping localhost -n 1 >nul
echo     [90;1m╠═══════»[0m  [38;5;196m[Kill VMware][0m  [38;5;124m    [2][0m   [90;1m ╠═══════»[0m  [38;5;196m[Registry Editor][0m [38;5;124m[6][0m
ping localhost -n 1 >nul
echo     [90;1m╠═══════»[0m  [38;5;196m[Kill VirtualBox][0m  [38;5;124m[3][0m   [90;1m ╠═══════»[0m  [38;5;196m[Control Panel][0m   [38;5;124m[7][0m
ping localhost -n 1 >nul
echo     [90;1m╠═══════»[0m  [38;5;196m[Settings][0m         [38;5;124m[4][0m   [90;1m ╚═══════»[0m  [38;5;196m[Command Prompt][0m  [38;5;124m[8][0m
ping localhost -n 1 >nul
echo|set /p="[90;1m    ║[0m"
ping localhost -n 1 >nul
echo.
ping localhost -n 1 >nul

:input2
setlocal EnableDelayedExpansion

set "ESC="
set "myprompt=%ESC%[90;1m    ╚═══════>  %ESC%[0m"
set "clearline=%ESC%[2K%ESC%[G"
set "COLOR_BRIGHT_RED=%ESC%[38;5;196m"
set "COLOR_DEEP_RED=%ESC%[38;5;124m"
set "COLOR_RESET=%ESC%[0m"

<nul set /p "=!myprompt!"
choice /c 12345678CPUE /n
if errorlevel 13 exit /b 

set "keys=12345678CPUE"
set /a index=%errorlevel%-1
set "char=!keys:~%index%,1!"

<nul set /p "=[1A%clearline%"
<nul set /p "=!myprompt!!COLOR_BRIGHT_RED!!char!!COLOR_RESET!"

for /l %%i in (3,-1,1) do (
    <nul set /p "=[G[2K!myprompt!!COLOR_BRIGHT_RED!!char!!COLOR_RESET!   %COLOR_DEEP_RED%Running In %%i...%COLOR_RESET%"
    timeout /t 1 >nul
)

<nul set /p "=[G[2K!myprompt!"

if "%char%"=="1" start "" Temp.bat
if "%char%"=="2" start "" VMware.bat
if "%char%"=="3" start "" Virtualbox.bat
if "%char%"=="4" start "" Settings.bat
if "%char%"=="5" start "" TaskManager.bat
if "%char%"=="6" start "" RegistryEditor.bat
if "%char%"=="7" start "" ControlPanel.bat
if "%char%"=="8" start "" cmd.exe
if "%char%"=="C" start "" ToolboxCredits.bat
if "%char%"=="P" start "" PasswordGen.bat
if "%char%"=="U" start "" cmd /c "%~dp0Updater\Update Toolbox.bat"
if "%char%"=="E" exit /b

<nul set /p "=[G[2K"

goto input2
