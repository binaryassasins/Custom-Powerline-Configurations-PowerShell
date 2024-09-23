@echo off
set "DISCORD_PATH=%LOCALAPPDATA%\Discord\app-1.0.9163\Discord.exe"

start "" "%DISCORD_PATH%" > nul 2>&1
