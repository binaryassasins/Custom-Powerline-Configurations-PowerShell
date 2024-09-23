# install.ps1
try {
    Write-Host 'Downloading and running Oh My Posh installation script...'
    winget install JanDeDobbeleer.OhMyPosh -s winget
} catch {
    Write-Host 'Failed to download installation script. Check your internet connection: ' $_.Exception.Message
}

try {
    Write-Host 'Installing Terminal-Icons module...'
    Install-PSResource -Name Terminal-Icons -Version 0.9.0
} catch {
    Write-Host 'Failed to install Terminal-Icons module: ' $_.Exception.Message
}

try {
    Write-Host 'Installing Neovim...'
    winget install Neovim.Neovim
} catch {
    Write-Host 'Failed to install Neovim: ' $_.Exception.Message
}

$profilePath = '.\Microsoft.PowerShell_profile.ps1'
if (Test-Path $profilePath) {
    try {
        Write-Host 'Copying PowerShell profile...'
        Copy-Item -Path $profilePath -Destination "$env:USERPROFILE\Documents\PowerShell"
        Write-Host 'Profile replaced successfully.'
    } catch {
        Write-Host 'Failed to copy PowerShell profile: ' $_.Exception.Message
    }
} else {
    Write-Host 'Profile file not found. Please ensure it exists.'
}

try {
    Write-Host 'Copying theme file...'
    Copy-Item -Path .\kushalxmod.omp.json -Destination "$env:POSH_THEMES_PATH"
} catch {
    Write-Host 'Failed to copy theme file: ' $_.Exception.Message
}

# Define the path to the "Job Runner" folder
$folderPath = (Get-Location).Path + '\Job Runner'

# Get the current user PATH variable
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", "User")

# Check if the folder is already in the PATH
if ($currentPath -notlike "*$folderPath*") {
    # Add the folder to the PATH
    $newPath = $currentPath + ";" + $folderPath
    [System.Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "'$folderPath' has been added to the user PATH."
} else {
    Write-Host "'$folderPath' is already in the user PATH."
}
