@echo off
cd /d "%~dp0Files"
setlocal EnableDelayedExpansion
set "UPDATER_PATH=%~dp0Updater"
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
echo [38;5;243m                      ████████╗  ██████╗   ██████╗  ██╗      ██████╗   ██████╗  ██╗  ██╗     ╔═════════════╗[0m
ping localhost -n 1 >nul
echo [38;5;245m                      ╚══██╔══╝ ██╔═══██╗ ██╔═══██╗ ██║      ██╔══██╗ ██╔═══██╗ ╚██╗██╔╝     ║             ║[0m
ping localhost -n 1 >nul
echo [38;5;247m                    	 ██║    ██║   ██║ ██║   ██║ ██║      ██████╔╝ ██║   ██║  ╚███╔╝      ║   Version   ║    [0m
ping localhost -n 1 >nul
echo [38;5;249m                    	 ██║    ██║   ██║ ██║   ██║ ██║      ██╔══██╗ ██║   ██║  ██╔██╗      ║     4.1     ║    [0m
ping localhost -n 1 >nul
echo [38;5;251m                       	 ██║    ╚██████╔╝ ╚██████╔╝ ███████╗ ██████╔╝ ╚██████╔╝ ██╔╝ ██╗     ║             ║    [0m
ping localhost -n 1 >nul
echo [38;5;253m		       	 ╚═╝     ╚═════╝   ╚═════╝  ╚══════╝ ╚═════╝   ╚═════╝  ╚═╝  ╚═╝     ╚═════════════╝[0m
ping localhost -n 1 >nul 
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.

:input
ping localhost -n 1 >nul
echo    [90;1m                                                                                            ╔═»[0m  [38;5;249m[   Update   ]  [0m [38;5;243m[U][0m
ping localhost -n 1 >nul
echo    [90;1m 											       ╠═»[0m  [38;5;249m[   Credits  ] [0m  [38;5;243m[C][0m
ping localhost -n 1 >nul
echo    [90;1m#╦════════════════════════════════════╦═════════════════════════════════════════════════════╬═»[0m  [38;5;249m[    Exit    ]  [0m [38;5;243m[E][0m
ping localhost -n 1 >nul
echo    [90;1m ║                                    ║                                                     ╚═»[0m  [38;5;249m[   PW Gen   ] [0m [38;5;243m [P][0m
ping localhost -n 1 >nul
echo    [90;1m ╠═══════»[0m [38;5;249m[     Cleaner     ][0m [38;5;243m[1][0m   [90;1m ╠═══════»[0m [38;5;249m[    Task Manager   ][0m [38;5;243m[6][0m
ping localhost -n 1 >nul
echo     [90;1m╠═══════»[0m [38;5;249m[   Kill VMware   ][0m [38;5;243m[2][0m   [90;1m ╠═══════»[0m [38;5;249m[  Registry Editor  ][0m [38;5;243m[7][0m
ping localhost -n 1 >nul
echo     [90;1m╠═══════»[0m [38;5;249m[ Kill VirtualBox ][0m [38;5;243m[3][0m   [90;1m ╠═══════»[0m [38;5;249m[   Control Panel   ][0m [38;5;243m[8][0m
ping localhost -n 1 >nul
echo     [90;1m╠═══════»[0m [38;5;249m[     Settings    ][0m [38;5;243m[4][0m   [90;1m ╠═══════»[0m [38;5;249m[   Command Prompt  ][0m [38;5;243m[9][0m
ping localhost -n 1 >nul
echo     [90;1m╠═══════»[0m [38;5;249m[     Utilities   ][0m [38;5;243m[5][0m   [90;1m ╚═══════»[0m [38;5;249m[    System Info    ][0m [38;5;243m[0][0m
echo|set /p="[90;1m    ║[0m"
ping localhost -n 1 >nul
echo.
ping localhost -n 1 >nul

:input2
setlocal EnableDelayedExpansion
set "ESC="
set "myprompt=%ESC%[90;1m    ╚═══════> %ESC%[0m"
set "clearline=%ESC%[2K%ESC%[G"
set "COLOR_WHITE=%ESC%[38;5;253m"
set "COLOR_GRAY=%ESC%[38;5;243m"
set "COLOR_RESET=%ESC%[0m"

<nul set /p "=!myprompt!"
choice /c 1234567890CPUE /n
set "errlevel=%errorlevel%"

set "keys=1234567890CPUE"
set /a index=%errlevel%-1
set "char=!keys:~%index%,1!"

<nul set /p "=[1A%clearline%"
<nul set /p "=!myprompt!!COLOR_WHITE!!char!!COLOR_RESET!"

for /l %%i in (3,-1,1) do (
    <nul set /p "=[G[2K!myprompt!!COLOR_WHITE!!char!!COLOR_RESET!   %COLOR_GRAY%Running In %%i...%COLOR_RESET%"
    timeout /t 1 >nul
)

<nul set /p "=[G[2K!myprompt!"

if "!char!"=="1" start "" Cleaner.bat
if "!char!"=="2" start "" VMware.bat
if "!char!"=="3" start "" Virtualbox.bat
if "!char!"=="4" start "" Settings.bat
if "!char!"=="5" start "" Utilities.bat
if "!char!"=="6" start "" TaskManager.bat
if "!char!"=="7" start "" RegistryEditor.bat
if "!char!"=="8" start "" ControlPanel.bat
if "!char!"=="9" start "" cmd.exe
if "!char!"=="0" start "" SystemInfo.bat
if "!char!"=="C" start "" ToolboxCredits.bat
if "!char!"=="P" start "" PasswordGen.bat
if /I "!char!"=="U" (
    start "" cmd /k "cd /d "!UPDATER_PATH!" && call Update-Toolbox.bat"
)

if "!char!"=="E" exit /b

<nul set /p "=[G[2K"

goto input2