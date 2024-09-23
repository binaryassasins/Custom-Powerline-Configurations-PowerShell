@echo off
echo "In order for terminal to work properly, please ensure that you have installed Nerd Fonts (https://www.nerdfonts.com/font-downloads) or you may install stock fonts in the 'Fonts' folder."
echo "Running Powerline Installation/Configuration"

powershell -Command "Install-Module -Name Terminal-Icons -RequiredVersion 0.9.0"
powershell -Command "winget install JanDeDobbeleer.OhMyPosh -s winget; winget install Neovim.Neovim; $profilePath = '.\Microsoft.PowerShell_profile.ps1'; if (Test-Path $profilePath) { Copy-Item -Path $profilePath -Destination '$env:USERPROFILE\Documents\PowerShell'; Write-Host 'Profile replaced successfully.' } else { Write-Host 'Please ensure that you have installed "Windows Terminal" from Microsoft Store (https://apps.microsoft.com/detail/9n0dx20hk701?hl=en-US&gl=US)'; } Copy-Item -Path .\kushalxmod.omp.json -Destination '$env:POSH_THEMES_PATH'"

echo "Installation Completed! Restart Your Terminal..."
echo "Press any key to exit."
pause >nul
