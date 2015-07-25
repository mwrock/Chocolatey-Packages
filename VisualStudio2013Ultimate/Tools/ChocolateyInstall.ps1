. (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'common.ps1')

$adminFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'AdminDeployment.xml')
$customArgs = $env:chocolateyInstallArguments
$env:chocolateyInstallArguments=""

$settings = Initialize-VS-Settings $customArgs $adminFile
$installerArgs = Get-VS-Installer-Args $settings.ProductKey

Install-ChocolateyPackage 'VisualStudio2013Ultimate' 'exe' $installerArgs 'http://download.microsoft.com/download/E/2/A/E2ADF1BE-8FA0-4436-A260-8780444C8355/vs_ultimate_download.exe'
