#Aliases
Set-Alias vim nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias np notepad
Set-Alias grep findstr #Need adjustment
Set-Alias tt tree
Set-Alias ifconfig ipconfig

#Custom Job Runner Aliases
Set-Alias sn obsidian
Set-Alias dc discord
Set-Alias browse opera
Set-Alias diagram drawio
Set-Alias music spotify

if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  #Auto Run
  Write-Host "			<--------------------> NETWORK ADAPTER STATUS <---------------------->"
  Get-NetAdapter
}

#PS Pre-Config
Set-PSReadLineOption -PredictionViewStyle ListView

#Modules
#Import-Module microsoft.powershell.localaccounts -UseWindowsPowerShell
Install-PSResource -Name Terminal-Icons

#Powerline
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\kushalxmod.omp.json" | Invoke-Expression

#Functions
function whereis ($command) {
  Begin {
    "Initializing Process..."
    $ct = 0
  }
  Process {
    "Searching...`n"
    $items = @(Get-ChildItem -Path ${env:ProgramFiles}, ${env:ProgramFiles(x86)}, ${env:LOCALAPPDATA} -Recurse -Filter "*$command*" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName)
    $ct = $items.Count
  }
  End {
    foreach ($item in $items) { "$item" }
    "`nResults: $ct found"
  }
}
function rm ($filepath) { 
  Remove-Item $filepath -Recurse -ErrorAction SilentlyContinue 
  Get-ChildItem
}
function mv ($item,$path) { Move-Item -Path $item -Destination $path }
function cat ($filepath) { Get-Content -Path $filepath -ErrorAction Stop }
#List of Environments
function printenv { 
  param (
    [string] $optenv
  )
  Get-ChildItem env:$optenv
}
function hval {
  param (
    [Parameter(Mandatory=$true)]
    [string] $path,
    [string] $algo
  )
    #$filehash = Get-FileHash -Path $path $algo | Select-Object Hash | Out-String
    #Write-Host $filehash
    #$filehash.GetType()
  try {
    if ($algo -eq "") {
      Get-FileHash $path -ErrorAction Stop | Format-List
    } else {
      Get-FileHash $path $algo -ErrorAction Stop | Format-List
    }    
  }
  catch { Write-Host "Permission denied: $path" }
}
#Integrity Check
<#
function integchk {
  param (
    [Parameter(Mandatory=$true)]
    [string] $path,
    [Parameter(Mandatory=$true)]
    [string] $algo,
    [Parameter(Mandatory=$true)]
    [string] $pubhash
  )
}
#>
#Start Root Terminal
function root { Start-Process "$env:LOCALAPPDATA\Microsoft\WindowsApps\Microsoft.WindowsTerminal_8wekyb3d8bbwe\wt.exe" -Verb RunAs }

#Privilege Mode
function sudo {
  param (
    # Parameter help description
    [Parameter(Position=0, Mandatory=$true, HelpMessage="Use either Start/Stop/Status/Restart")]
    [string] $command,
    [Parameter(Position=1, Mandatory=$true, HelpMessage="Use <valid service name>/sshsvcd (ssh service)")]
    [string] $preDefService
  )
  if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $svcName = Get-Service -Name $preDefService -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name
    try {
      switch ($command) {  
        "Start" { 
          if ("sshsvcd" -eq $preDefService) {
            Start-Service "sshd"
            Start-Service "LogMeIn Hamachi Tunneling Engine"
            Write-Host "SSH Service Started"
            break
          } elseif ("mongodb" -eq $preDefService) {
            Start-Service "MongoDB"
            Write-Host "MongoDB Service Started"
	          break
          } else { 
            Start-Service $svcName 
            break
          }
        }
        "Stop" {
          if ("sshsvcd" -eq $preDefService) {
            Stop-Service "sshd"
            Stop-Service "LogMeIn Hamachi Tunneling Engine"
            Write-Host "SSH Service Stopped"
            break
          } elseif ("mongodb" -eq $preDefService) {
            Stop-Service "MongoDB"
            Write-Host "MongoDB Service Stopped"
	          break
          } else { 
            Stop-Service $svcName 
            break
          }
        }
        "Status" {
          if ("sshsvcd" -eq $preDefService) {
            Get-Service "sshd"
            Get-Service "LogMeIn Hamachi Tunneling Engine"
            break
          } elseif ("mongodb" -eq $preDefService) {
            Get-Service "MongoDB"
	    break
          } else { 
            Get-Service $svcName 
            break
          }
        }
        "Restart" {
          if ("sshsvcd" -eq $preDefService) {
            Restart-Service "sshd"
            Restart-Service "LogMeIn Hamachi Tunneling Engine"
            Write-Host "SSH Service Restarted"
            break
          } elseif ("mongodb" -eq $preDefService) {
            Restart-Service "MongoDB"
            Write-Host "MongoDB Service Restarted"
	          break
          } else { 
            Restart-Service $svcName 
            break
          }
        }
      }
    }
    catch {
      Write-Host "There is no such service named as '$preDefService'"
    }
	} else {
		Write-Host "To run this command, you may want to use 'root' to run the terminal as administrator."
	}
}
function Get-TID ($procid) {
  try {
    $process = Get-Process -Id $procid -ErrorAction Stop
    #Yoda expression
    if ($null -ne $process) {
        Write-Host "Process ID (PID): $($process.Id)"
        Write-Host "Thread IDs (TIDs):"
        foreach ($thread in $process.Threads) { Write-Host "  $($thread.Id)" }
    } else {
      Write-Host "No process found with ID: $procid"
    }
  } catch {
    Write-Host "$($_.Exception.Message)"
  }
}
#Fetching IANA Port Registry Via Web Request
function Get-IANAPortRegistry {
  $url = "https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv"
  $reqAPI = Invoke-WebRequest -Uri $url
  $IANAdata = $reqAPI.Content | ConvertFrom-Csv -Header "Service","Port" | Select-Object Port, Service
  return $IANAdata
  #$IANAdata
}
#Opened TCP Port For Local Connections
function netstatxloc {
  Begin {
    $rawRegistry = @(Get-IANAPortRegistry)
    $filteredRegistry = @()
  }
  Process {
    foreach ($registry in $rawRegistry) {
      if (($registry.Service -ne "") -and ($registry.Port -ne "")) {
        $filteredRegistry += $registry
      }
    }
    # Output the result
    $locPorts = @(Get-NetTCPConnection | Select-Object -ExpandProperty LocalPort)
    $filteredLocPorts = @()
    foreach ($port in $locPorts) {
      if ($port -ne 0) {
        $filteredLocPorts += $port
      }
    }
    Write-Host "`nOpened TCP Local Port"
    Write-Host "---------------------`n"
    foreach ($fLocPort in $filteredLocPorts) {
      if ($filteredRegistry.Port -contains $fLocPort) {
        $svcname = ($filteredRegistry | Where-Object Port -EQ $fLocPort | Select-Object -ExpandProperty Service -Unique) -join ','
        $locAddress = (Get-NetTCPConnection | Where-Object LocalPort -EQ $fLocPort | Select-Object -ExpandProperty LocalAddress -Unique) -join ','
        $state = (Get-NetTCPConnection | Where-Object LocalPort -EQ $fLocPort | Select-Object -ExpandProperty State -Unique) -join ','
        Write-Host "$fLocPort ~ $svcname ~ $locAddress ~ $state"
      } else {
        Write-Host "$fLocPort ~ - ~ $locAddress ~ $state"
      }
    }
  }
}
#Opened TCP Port For Remote Connections
function netstatxrem {
  $rawRegistry = @(Get-IANAPortRegistry)
  #$rawregistry.Count
  $filteredRegistry = @()
  foreach ($registry in $rawRegistry) {
    if (($registry.Service -ne "") -and ($registry.Port -ne "")) {
      $filteredRegistry += $registry
    }
  }
  # Output the result
  $remPorts = @(Get-NetTCPConnection | Select-Object -ExpandProperty RemotePort)
  $filteredRemPorts = @()
  foreach ($port in $remPorts) {
    if ($port -ne 0) {
      $filteredRemPorts += $port
    }
  }
  Write-Host "`nOpened TCP Remote Port"
  Write-Host "----------------------`n"
  foreach ($fRemPort in $filteredRemPorts) {
    if ($filteredRegistry.Port -contains $fRemPort) {
      $svcname = $filteredRegistry | Where-Object Port -EQ $fRemPort | Select-Object -ExpandProperty Service -join ','
      $remAddress = Get-NetTCPConnection | Where-Object RemotePort -EQ $fRemPort | Select-Object -ExpandProperty RemoteAddress -join ','
      $state = Get-NetTCPConnection | Where-Object RemotePort -EQ $fRemPort | Select-Object -ExpandProperty State -join ','
      Write-Host "$fRemPort ~ $svcname ~ $remAddress ~ $state"
    } else {
      Write-Host "$fRemPort ~ - ~ $remAddress ~ $state"
    }
  }
}
