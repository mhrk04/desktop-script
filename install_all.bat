@echo off
TITLE Master Installer - Chrome, Office & Zoom

::---------------------------------------------------------------------------------
:: 1. Administrative Privileges Check
::---------------------------------------------------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag is set, we do not have admin rights.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set "params=%*"
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"


::---------------------------------------------------------------------------------
:: 2. Install Google Chrome
::---------------------------------------------------------------------------------
echo.
echo [INFO] Installing Google Chrome...
if exist "ChromeInstaller.exe" (
    start /wait ChromeInstaller.exe /silent /install
    echo [SUCCESS] Google Chrome has been installed.
) else (
    echo [ERROR] ChromeInstaller.exe not found! Please place it in the same folder as this script.
)


::---------------------------------------------------------------------------------
:: 3. Install Microsoft Office 2016
::---------------------------------------------------------------------------------
echo.
echo [INFO] Installing Microsoft Office 2016. This may take a while...
if exist "Office2016\setup.exe" (
    start /wait Office2016\setup.exe /config Office2016\config.xml
    echo [SUCCESS] Microsoft Office 2016 has been installed.
) else (
    echo [ERROR] Office 2016 setup files not found! Ensure the 'Office2016' folder exists.
)


::---------------------------------------------------------------------------------
:: 4. Install Zoom Client
::---------------------------------------------------------------------------------
echo.
echo [INFO] Installing Zoom Client...
if exist "ZoomInstaller.msi" (
    REM Using msiexec for silent installation of MSI files. /qn means Quiet (no UI).
    start /wait msiexec /i "ZoomInstaller.msi" /qn /norestart
    echo [SUCCESS] Zoom Client has been installed.
) else (
    echo [ERROR] ZoomInstaller.msi not found! Please place it in the same folder as this script.
)


::---------------------------------------------------------------------------------
:: 5. Finalizing
::---------------------------------------------------------------------------------
echo.
echo [COMPLETE] All installations are finished.
echo This window will close in 10 seconds...
timeout /t 10 /nobreak
exit