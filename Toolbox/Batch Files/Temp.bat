@ECHO OFF

>nul 2>&1 net session
if %errorLevel% neq 0 (
    echo Requesting Administrative Privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)


title Toolbox Temp - Ghost

ECHO Deleting User Temp Files
DEL /S /Q /F "%TEMP%\*.*"
DEL /S /Q /F "%TMP%\*.*"

ECHO Deleting Local Temp Files
DEL /S /Q /F "%USERPROFILE%\Local Settings\Temp\*.*"
DEL /S /Q /F "%LOCALAPPDATA%\Temp\*.*"

ECHO Deleting Windows Temp Files
DEL /S /Q /F "%WINDIR%\Temp\*.*"
FOR /D %%p IN ("%WINDIR%\Temp\*") DO RMDIR /S /Q "%%p"

ECHO.
CHOICE /M "Do You Want To Delete The Prefetch Files?"
IF ERRORLEVEL 2 (
    ECHO Prefetch Files Will Not Be Deleted.
) ELSE (
    ECHO Deleting Windows Prefetch Files
    DEL /S /Q /F "%WINDIR%\Prefetch\*.*"
    FOR /D %%p IN ("%WINDIR%\Prefetch\*") DO RMDIR /S /Q "%%p"
    ECHO Prefetch Files Deleted!
)

ECHO Cleanup Completed!
EXIT
