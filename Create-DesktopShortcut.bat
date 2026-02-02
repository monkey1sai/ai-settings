@echo off
set "TargetScript=%~dp0scripts\run-sync.bat"
set "ShortcutName=Sync-openAI-CLI"
set "ShortcutPath=%USERPROFILE%\Desktop\%ShortcutName%.lnk"

echo Creating shortcut for: %TargetScript%
echo Location: %ShortcutPath%

powershell.exe -ExecutionPolicy Bypass -NoProfile -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%ShortcutPath%'); $s.TargetPath = '%TargetScript%'; $s.WorkingDirectory = '%~dp0'; $s.IconLocation = 'shell32.dll,239'; $s.Description = 'Sync openAI CLI settings to Cloud'; $s.Save()"

echo.
echo Shortcut created successfully on Desktop.
pause