. (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'common.ps1')

$adminFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'AdminDeployment.xml')
$customArgs = $env:chocolateyInstallArguments
$env:chocolateyInstallArguments=""

$settings = Initialize-VS-Settings $customArgs $adminFile
$installerArgs = Get-VS-Installer-Args $settings.ProductKey

Install-ChocolateyPackage 'VisualStudio2013Premium' 'exe' $installerArgs 'http://download.microsoft.com/download/6/5/F/65F510B7-D597-4E80-8EFE-86DDCFCC7C43/vs_premium_download.exe'
 