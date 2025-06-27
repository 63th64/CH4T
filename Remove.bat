@echo off
title 64th Service
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] This script requires administrative privileges. Restarting with admin rights...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb RunAs"
    exit /b
)

echo.
echo [*] Checking registry entry ...

:: Check and delete registry entry if it points to MSTTSLooc.dll
set "regFound=0"
for /f "tokens=3*" %%A in ('reg query "HKLM\SYSTEM\ControlSet001\Services\WinSock2\Parameters" /v AutodialDLL 2^>nul') do (
    echo %%A | find /I "MSTTSEngine.dll" >nul
    if not errorlevel 1 (
        set "regFound=1"
    )
)

if %regFound%==1 (
    reg delete "HKLM\SYSTEM\ControlSet001\Services\WinSock2\Parameters" /v AutodialDLL /f >nul 2>&1
    if %errorLevel%==0 (
        echo [+] Registry value AutodialDLL deleted successfully.
    ) else (
        echo [!] Failed to delete registry value AutodialDLL.
    )
) else (
    echo [-] Registry value  not found.
)

echo.
echo [*] Attempting to delete CHeat...

:: Delete the DLL file
set "dllPath=C:\Windows\Microsoft.NET\assembly\GAC_32\MSTTSEngine.dll"
if exist "%dllPath%" (
    del /f /q "%dllPath%" >nul 2>&1
    if exist "%dllPath%" (
        echo [!] Failed to delete  Please close apps like Epic Games or Fortnite and try again.
    ) else (
        echo [+] Successfully deleted Cheat.
    )
) else (
    echo [-] cheat not found close game and then try.
)

echo.
echo [*] Done. Press any key to exit.
pause >nul