# Powerline Setup Guide

## Requirements
- Nerd Fonts (you may install stock fonts provided in the "Font" folder)
- Windows Terminal - [Click Here](https://apps.microsoft.com/detail/9n0dx20hk701?hl=en-US&gl=US)
- PowerShell - [Click Here](https://apps.microsoft.com/detail/9mz1snwt0n5d?ocid=pdpshare&hl=en-us&gl=US)

## Installation Steps
1. Clone the repository to your local machine or download and extract it.
```shell
git clone https://github.com/binaryassasins/Custom-Powerline-Configurations-PowerShell.git
```
2. Navigate to the folder where the setup directory is located
3. Execute the **run.bat** file
```powershell
.\run.bat
```
4. Allow the script to be executed by entering 'Y'

## Verify the Job Runner Path
1. Check PATH: To verify that the Job Runner folder was successfully added to your PATH, open a new PowerShell session and run:
```powershell
$env:Path -split ';'
```
Ensure that the output contains the path to your Job Runner folder.

# Additional Resources
- [Oh My Posh Documentation](https://ohmyposh.dev/docs)
- [Neovim Documentation](https://neovim.io/doc/user/)