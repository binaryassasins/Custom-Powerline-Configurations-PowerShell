@echo off
set "baseDir=%LOCALAPPDATA%\Discord"

for /f "delims=" %%i in ('dir "%baseDir%\app-*" /ad /b /o-d') do (
    set "latestDir=%%i"
    goto :break
)
:break

set "DISCORD_PATH=%baseDir%\%latestDir%\Discord.exe"

if exist "%DISCORD_PATH%" (
    start "" "%DISCORD_PATH%" >nul 2>&1
) else (
    echo Discord.exe not found in %DISCORD_PATH%
)

