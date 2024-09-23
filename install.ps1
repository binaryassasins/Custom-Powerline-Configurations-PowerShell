# install.ps1

# Function to ensure NuGet provider is installed
function Ensure-NuGetProvider {
  try {
      if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
          Write-Host 'Installing NuGet provider...'
          Install-PackageProvider -Name NuGet -Force -Scope CurrentUser -ErrorAction Stop
          Write-Host 'NuGet provider installed successfully.'
      } else {
          Write-Host 'NuGet provider is already installed.'
      }
  } catch {
      Write-Host 'Failed to install NuGet provider: ' $_.Exception.Message
  }
}

# Ensure NuGet provider is installed
Ensure-NuGetProvider

# Function to install modules with error handling
function Try-InstallModule {
  param (
      [string]$ModuleName,
      [string]$RequiredVersion = $null
  )
  
  try {
      if ($RequiredVersion) {
          Install-Module -Name $ModuleName -RequiredVersion $RequiredVersion -Force -AllowClobber -ErrorAction Stop
      } else {
          Install-Module -Name $ModuleName -Force -AllowClobber -ErrorAction Stop
      }
      Write-Host "$ModuleName installed successfully."
  } catch {
      Write-Host "Failed to install $($ModuleName): $_.Exception.Message"
      Write-Host "Try running the following command manually in an elevated PowerShell session:"
      if ($RequiredVersion) {
          Write-Host "Install-Module -Name $ModuleName -RequiredVersion $RequiredVersion -Force -AllowClobber"
      } else {
          Write-Host "Install-Module -Name $ModuleName -Force -AllowClobber"
      }
  }
}

# Your existing script logic

# Update PowerShellGet and PackageManagement
Try-InstallModule -ModuleName PowerShellGet
Try-InstallModule -ModuleName PackageManagement

# Install Terminal-Icons
Try-InstallModule -ModuleName Terminal-Icons -RequiredVersion 0.9.0

# Other installation steps
try {
  Write-Host 'Downloading and running Oh My Posh installation script...'
  winget install JanDeDobbeleer.OhMyPosh -s winget
} catch {
  Write-Host 'Failed to download installation script. Check your internet connection: ' $_.Exception.Message
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
