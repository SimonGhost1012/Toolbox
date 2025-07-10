@echo off

>nul 2>&1 net session
if %errorLevel% neq 0 (
    echo Requesting Administrative Privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)


title Toolbox VirtualBox - Ghost
echo Stopping all VirtualBox processes...

:: Kill the VirtualBox virtual machine processes
taskkill /F /IM VirtualBoxVM.exe

:: Kill the VirtualBox main GUI process
taskkill /F /IM VirtualBox.exe

:: Kill the VirtualBox service process
taskkill /F /IM VBoxSVC.exe

:: Kill the VirtualBox headless VM process (if any headless VMs are running)
taskkill /F /IM VBoxHeadless.exe

:: Kill the VirtualBox network service process (if running)
taskkill /F /IM VBoxNetDHCP.exe

:: Kill the VirtualBox shared folder service process (if using shared folders)
taskkill /F /IM VBoxTray.exe

:: Kill the VirtualBox autostart service (if enabled)
taskkill /F /IM VBoxAutostartSvc.exe

:: Kill the VirtualBox USB proxy process (if USB devices are attached)
taskkill /F /IM VBoxUSBMon.exe

echo All VirtualBox processes have been stopped.
exit