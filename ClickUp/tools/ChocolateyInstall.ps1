# $name = 'ClikcUp'
# $installerType = 'exe'
# $url  = 'https://desktop.clickup.com/windows'
# $silentArgs = '/S'

# Install-ChocolateyPackage $name $installerType $silentArgs $url
$packageName= 'ClickUp'
$toolsDir   = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://desktop.clickup.com/window'
$url64      = 'https://desktop.clickup.com/window'

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'exe'
  url           = $url
  url64bit      = $url64
  silentArgs    = "/S"
  
}
Install-ChocolateyPackage @packageArgs