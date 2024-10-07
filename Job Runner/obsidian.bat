@echo off
set "OBSIDIAN_PATH=%LOCALAPPDATA%\Obsidian\Obsidian.exe"

start "" "%OBSIDIAN_PATH%" > nul 2>&1
