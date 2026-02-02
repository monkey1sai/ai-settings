@echo off
echo Starting openAI CLI Sync...

where pwsh >nul 2>nul
if %errorlevel%==0 (
	pwsh -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync.ps1" %*
) else (
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync.ps1" %*
)
echo.
echo Sync process finished.
pause
