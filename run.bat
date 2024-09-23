@echo off
echo In order for terminal to work properly, please ensure that you have installed Nerd Fonts (https://www.nerdfonts.com/font-downloads) or you may install stock fonts in the 'Fonts' folder.
echo Running Powerline Installation/Configuration

powershell -ExecutionPolicy Bypass -NoProfile -File ".\install.ps1"

echo Installation Completed! Restart Your Terminal...
echo Press any key to exit.
pause >nul
