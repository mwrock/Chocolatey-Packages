. (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'common.ps1')

$adminFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'AdminDeployment.xml')
$customArgs = $env:chocolateyInstallArguments
$env:chocolateyInstallArguments=""

$settings = Initialize-VS-Settings $customArgs

$installerArgs = Get-VS-Installer-Args $settings.ProductKey

Install-ChocolateyPackage 'VisualStudio2013Premium' 'exe' $installerArgs 'http://download.microsoft.com/download/D/B/D/DBDEE6BB-AF28-4C76-A5F8-710F610615F7/vs_premium_download.exe'
 