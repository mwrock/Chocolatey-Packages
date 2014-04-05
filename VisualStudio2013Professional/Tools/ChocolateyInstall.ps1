. (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'common.ps1')

$adminFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'AdminDeployment.xml')
$customArgs = $env:chocolateyInstallArguments
$env:chocolateyInstallArguments=""

$settings = Initialize-VS-Settings $customArgs

$installerArgs = Get-VS-Installer-Args $settings.ProductKey
Install-ChocolateyPackage 'VisualStudio2013Professional' 'exe' $installerArgs 'http://download.microsoft.com/download/A/F/1/AF128362-A6A8-4DB3-A39A-C348086472CC/vs_professional_download.exe'
