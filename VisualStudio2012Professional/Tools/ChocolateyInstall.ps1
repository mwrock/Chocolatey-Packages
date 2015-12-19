. (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'common.ps1')

$adminFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'AdminDeployment.xml')
$customArgs = $env:chocolateyInstallArguments
$env:chocolateyInstallArguments=""

$settings = Initialize-VS-Settings $customArgs $adminFile
$installerArgs = Get-VS-Installer-Args $settings.ProductKey

Install-ChocolateyPackage 'VisualStudio2012Professional' 'exe' $installerArgs 'http://go.microsoft.com/?linkid=9810233' -validExitCodes @(0, 3010)
