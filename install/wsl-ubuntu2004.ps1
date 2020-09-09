#Requires -RunAsAdministrator

<# 
  powershell -ExecutionPolicy Bypass -File wsl.ps1
#>

# Install the Windows Subsystem for Linux 
##### dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

# Download the Linux kernel update package
$File = "wsl_update_x64.msi"
$Link = "https://wslstorestorage.blob.core.windows.net/wslblob/$File"
$Tmp = "$env:TEMP\$File"
$Client = New-Object System.Net.WebClient
$Client.DownloadFile($Link, $Tmp)
msiexec /i $Tmp /qn
del $Tmp

# Enable the 'Virtual Machine Platform'
#### dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform

# Set the default version
wsl.exe --set-default-version 2

# Download a distribution
$Link = "https://aka.ms/wslubuntu2004"
$Filename = "$env:TEMP\$(Split-Path $Link -Leaf).appx"
Invoke-WebRequest -Uri $Link -OutFile $Filename -UseBasicParsing
Add-AppxPackage -Path  $Filename

# Set the default distro
wsl.exe --setdefault Ubuntu-20.04

<#
  cd \\wsl$\Ubuntu-20.04
#>
