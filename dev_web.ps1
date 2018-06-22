# Description: Boxstarter Script
# Author: Microsoft
# Common dev settings for web dev

Disable-UAC

#--- Windows Features ---
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

#--- File Explorer Settings ---
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2


#--- Enabling developer mode on the system --- 
Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1  

#--- Tools ---
choco install -y vscode
RefreshEnv 
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension msjsdiag.debugger-for-edge

choco install -y git -params '"/GitAndUnixToolsOnPath /WindowsTerminal"'
choco install -y 7zip.install

#--- Windows Subsystems/Features ---
choco install -y Microsoft-Hyper-V-All -source windowsFeatures
choco install Microsoft-Windows-Subsystem-Linux -source windowsfeatures
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName Microsoft-Windows-Subsystem-Linux 
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName Microsoft-Hyper-V  

#--- Ubuntu ---
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1604 -OutFile ~/Ubuntu.appx -UseBasicParsing
Add-AppxPackage -Path ~/Ubuntu.appx

<#
#--- SLES ---
# Install SLES Store app
Invoke-WebRequest -Uri https://aka.ms/wsl-sles-12 -OutFile ~/SLES.appx -UseBasicParsing
Add-AppxPackage -Path ~/SLES.appx
# Launch SLES
sles-12.exe

# --- openSUSE ---
Invoke-WebRequest -Uri https://aka.ms/wsl-opensuse-42 -OutFile ~/openSUSE.appx -UseBasicParsing
Add-AppxPackage -Path ~/openSUSE.appx
# Launch openSUSE
opensuse-42.exe
#>

#--- Browsers ---
choco install -y googlechrome
choco install -y firefox

#--- Fonts ---
choco install -y inconsolata
# choco install -y ubuntu.font

#--- Tools ---
choco install -y sysinternals
choco install -y docker-for-windows
choco install -y python

choco install visualstudio2017enterprise -y --package-parameters "--add Microsoft.VisualStudio.Component.Git"  
choco install -y vscode 
choco install -y visualstudio2017-workload-azure 
choco install visualstudio2017-workload-netweb 
choco install visualstudio2017-workload-netcoretools 
choco install visualstudio2017-workload-node 
choco install visualstudio2017-workload-data


choco install kubernetes-cli 


choco install -y baretail 
choco install -y conemu 
choco install -y poshgit 

RefreshEnv 

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula

#--- Uninstall unecessary applications that come with Windows out of the box ---
Write-Host "Uninstall unecessary applications that come with Windows out of the box" -ForegroundColor "Yellow"

#Referenced to build script
# https://docs.microsoft.com/en-us/windows/application-management/remove-provisioned-apps-during-update
# https://github.com/jayharris/dotfiles-windows/blob/master/windows.ps1#L157
# https://gist.github.com/jessfraz/7c319b046daa101a4aaef937a20ff41f
# https://gist.github.com/alirobe/7f3b34ad89a159e6daa1
# https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/scripts/remove-default-apps.ps1

function removeApp {
	Param ([string]$appName)
	Write-Output "Trying to remove $appName"
	Get-AppxPackage $appName -AllUsers | Remove-AppxPackage
	Get-AppXProvisionedPackage -Online | Where DisplayName -like $appName | Remove-AppxProvisionedPackage -Online
}

$applicationList = @(
	"Microsoft.BingFinance"
	"Microsoft.3DBuilder"
	"Microsoft.BingFinance"
	"Microsoft.BingNews"
	"Microsoft.BingSports"
	"Microsoft.BingWeather"
	"Microsoft.CommsPhone"
	"Microsoft.Getstarted"
	"Microsoft.WindowsMaps"
	"*MarchofEmpires*"
	"Microsoft.GetHelp"
	"Microsoft.Messaging"
	"*Minecraft*"
	"Microsoft.MicrosoftOfficeHub"
	"Microsoft.OneConnect"
	"Microsoft.WindowsPhone"
	"Microsoft.SkypeApp"
	"*Solitaire*"
	"Microsoft.MicrosoftStickyNotes"
	"Microsoft.Office.Sway"
	"Microsoft.ZuneMusic"
	"Microsoft.ZuneVideo"
	"Microsoft.NetworkSpeedTest"
	"Microsoft.FreshPaint"
	"Microsoft.Print3D"

	#Non-Microsoft
	"*Autodesk*"
	"*BubbleWitch*"
	"king.com.CandyCrush*"
	"*Dell*"
	"*Dropbox*"
	"*Keeper*"
	"*.Duolingo-LearnLanguagesforFree"
	"*.EclipseManager"
	"ActiproSoftwareLLC.562882FEEB491" # Code Writer
	"*.AdobePhotoshopExpress"
);

foreach ($app in $applicationList) {
    removeApp $app
}
