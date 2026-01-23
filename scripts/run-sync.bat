@echo off
echo Starting AI Settings Sync...
powershell.exe -ExecutionPolicy Bypass -File "%~dp0sync.ps1"
echo.
echo Sync process finished.
pause
