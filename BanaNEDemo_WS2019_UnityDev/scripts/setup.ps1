Set-StrictMode -Version 3
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

# Files to download
$UnityHubUri = "https://public-cdn.cloud.unity3d.com/hub/prod/UnityHubSetup.exe"

# chocolatey のインストール
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# 各種アプリのインストール
choco install -y --ignore-checksums googlechrome
choco install -y vscode
choco install -y azure-cli
choco install -y az.powershell | Out-Null
choco install -y nodejs.install | Out-Null
choco install -y rclone | Out-Null
choco install -y git | Out-Null
choco install -y p4v
choco install -y svn

# UnitySetup モジュール
Get-PackageProvider -Name NuGet -ForceBootstrap
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Force UnitySetup

# Install Unity Hub
Invoke-WebRequest -Uri $UnityHubUri -OutFile D:\UnityHubSetup.exe
D:\UnityHubSetup.exe /S

# Install Unity Licensing Client
Expand-Archive -Path D:\UnityLicensingClient.zip -DestinationPath C:\UnityLicensingClient

# Create a directory for services-config.json
mkdir C:\ProgramData\Unity\config | Out-Null

# Auto start ssh-agent service
Set-Service -StartupType Automatic -Name ssh-agent

# IEのセキュリティ設定を無効化
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0 -Force

# ログオン時にサーバーマネージャーを起動させない
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ServerManager" -Name "DoNotOpenServerManagerAtLogon" -Value 1 -Force
