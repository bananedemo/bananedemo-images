Set-StrictMode -Version 3
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

# Files and directories
$UnityHubUri = 'https://public-cdn.cloud.unity3d.com/hub/prod/UnityHubSetup.exe'
$UnityLicensingClientZip = 'D:\UnityLicensingClient.zip'
$UnityLicensingClientDir = 'C:\UnityLicensingClient'

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

# UnitySetup モジュールのインストール
Get-PackageProvider -Name NuGet -ForceBootstrap
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Force UnitySetup

# Unity Hub インストール
Invoke-WebRequest -Uri $UnityHubUri -OutFile D:\UnityHubSetup.exe
D:\UnityHubSetup.exe /S

# Unity.Licensing.Client インストール (存在する場合)
if (Test-Path $UnityLicensingClientZip) {
    Expand-Archive -Path $UnityLicensingClientZip -DestinationPath $UnityLicensingClientDir
}

# services-config.json を置くディレクトリ作成
mkdir C:\ProgramData\Unity\config | Out-Null

# Auto start ssh-agent service
Set-Service -StartupType Automatic -Name ssh-agent

# IEのセキュリティ設定を無効化
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0 -Force

# ログオン時にサーバーマネージャーを起動させない
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ServerManager" -Name "DoNotOpenServerManagerAtLogon" -Value 1 -Force
