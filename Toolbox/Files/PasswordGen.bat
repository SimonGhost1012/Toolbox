@echo off
title  Toolbox Password Generator - Ghost
chcp 65001 >nul
setlocal enabledelayedexpansion
mode 125, 30

:: Default Configuration
set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&"
set "default_pwlength=12"  :: Default password length
set "pwlength=%default_pwlength%" :: Current password length initialized to default

:main_menu
cls
ping localhost -n 2 >nul
echo [38;5;243m╔═════════════════════════════════╗[0m
ping localhost -n 1 >nul
echo [38;5;243m║   PASSWORD GENERATOR - GHOST    ║[0m
ping localhost -n 1 >nul
echo [38;5;243m╠═════════════════════════════════╣[0m
ping localhost -n 1 >nul
echo [38;5;245m║		    	          ║
ping localhost -n 1 >nul
echo [38;5;245m║       Generate A Password[0m[38;5;245m       ║
ping localhost -n 1 >nul
echo [38;5;245m║             Option 1[38;5;245m            ║
ping localhost -n 1 >nul
echo [38;5;247m║                                 ║
ping localhost -n 1 >nul
echo [38;5;247m║             Options[0m[38;5;247m             ║
ping localhost -n 1 >nul
echo [38;5;247m║             Option 2[38;5;247m            ║
ping localhost -n 1 >nul
echo [38;5;245m║                                 ║
ping localhost -n 1 >nul
echo [38;5;245m║              Exit[38;5;245m               ║
ping localhost -n 1 >nul
echo [38;5;245m║             Option E[0m[38;5;245m            ║
ping localhost -n 1 >nul
echo [38;5;243m║    Current Password Length: %pwlength%  ║
ping localhost -n 1 >nul
echo [38;5;243m║                                 ║
ping localhost -n 1 >nul
echo [38;5;243m╚═════════════════════════════════╝[0m
ping localhost -n 1 >nul
echo.
ping localhost -n 1 >nul
echo|set /p="[38;5;245mSelect An Option : [0m"
choice /c 12E /n

if errorlevel 3 goto exit
if errorlevel 2 goto settings
if errorlevel 1 goto generate_password

:: Calculate the length of the box and adjust based on the password length
set /a "boxWidth=%passwordLength% + 4 + 25"  :: 4 for padding, 25 for text label width
set "border="
for /L %%i in (1,1,%boxWidth%) do set "border=!border!═"

:generate_password
cls
echo [38;5;245m Generating A Password Of Length %pwlength%...
set "password=" 
for /l %%i in (1,1,%pwlength%) do (
    set /a "rand=!random! %% 74"
    for %%j in (!rand!) do set "password=!password!!chars:~%%j,1!"
)
ping localhost -n 1 >nul
echo [38;5;243m ════════════════════════════════════════════════════════════════════════════
ping localhost -n 1 >nul
echo [38;5;245m  Your Generated Password: !password!
ping localhost -n 1 >nul
echo [38;5;243m ════════════════════════════════════════════════════════════════════════════
ping localhost -n 1 >nul
pause
goto main_menu

:settings
cls
ping localhost -n 1 >nul
echo [38;5;243m ╔═════════════════════════════════╗
ping localhost -n 1 >nul
echo [38;5;243m ║             Options             ║  
ping localhost -n 1 >nul 
echo [38;5;245m ╠═════════════════════════════════╣
ping localhost -n 1 >nul
echo [38;5;245m ║   Current Password Length: %pwlength%   ║
ping localhost -n 1 >nul
echo [38;5;247m ║   Default Password Length: %default_pwlength%   ║
ping localhost -n 1 >nul
echo [38;5;247m ╠═════════════════════════════════╣
ping localhost -n 1 >nul
echo [38;5;245m ║   [1] Change Password Length    ║
ping localhost -n 1 >nul
echo [38;5;245m ║   [2] Reset Length To Default   ║
ping localhost -n 1 >nul
echo [38;5;243m ║   [E] Back to Main Menu         ║
ping localhost -n 1 >nul
echo [38;5;243m ╚═════════════════════════════════╝
ping localhost -n 1 >nul
echo.
ping localhost -n 1 >nul
echo|set /p="[38;5;245mSelect An Option > [0m"
choice /c 12E /n"

if errorlevel 3 goto main_menu
if errorlevel 2 goto reset_pwlength
if errorlevel 1 goto change_pwlength

:change_pwlength
cls
ping localhost -n 1 >nul
echo [38;5;243m ╔═════════════════════════════════╗
ping localhost -n 1 >nul
echo [38;5;245m ║       Change Password Length    ║
ping localhost -n 1 >nul
echo [38;5;247m ╠═════════════════════════════════╣
ping localhost -n 1 >nul
echo [38;5;247m ║   Current Password Length: %pwlength%   ║
ping localhost -n 1 >nul
echo [38;5;245m ║   Default Password Length: %default_pwlength%   ║
ping localhost -n 1 >nul
echo [38;5;243m ╚═════════════════════════════════╝
ping localhost -n 1 >nul
set /p "newlength=Enter New Password Length (4-50): "

:: Validate input
if not defined newlength goto settings_invalid
for /f "delims=0123456789" %%A in ("%newlength%") do goto settings_invalid
if %newlength% lss 4 goto settings_invalid
if %newlength% gtr 50 goto settings_invalid

:: Save the new length
set "pwlength=%newlength%"
echo Password length updated to %pwlength%.
pause
goto settings

:reset_pwlength
cls
set "pwlength=%default_pwlength%"
ping localhost -n 1 >nul
echo [38;5;243m ╔═════════════════════════════════╗
ping localhost -n 1 >nul
echo [38;5;245m ║  Password Reset To Default: %pwlength%  ║
ping localhost -n 1 >nul
echo [38;5;243m ╚═════════════════════════════════╝
ping localhost -n 1 >nul
pause
goto settings

:settings_invalid
echo Invalid input. Please Enter A Valid Number Between 4 And 50.
pause
goto settings

:exit
exit
