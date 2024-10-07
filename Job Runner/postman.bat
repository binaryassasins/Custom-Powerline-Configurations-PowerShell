@echo off
set "POSTMAN_PATH=%LOCALAPPDATA%\Postman\Postman.exe"
start "" "%POSTMAN_PATH%" > nul 2>&1
