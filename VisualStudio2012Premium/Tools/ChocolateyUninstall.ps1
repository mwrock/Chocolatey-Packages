$app = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "Microsoft Visual Studio Premium 2012" }
if($app -ne $null){
    $version=$app.Version
    $uninstaller=Get-Childitem "$env:ProgramData\Package Cache\" -Recurse -Filter vs_Premium.exe | ? { $_.VersionInfo.ProductVersion.startswith($version)}
    Uninstall-ChocolateyPackage 'VisualStudio2012Premium' 'exe' "/Uninstall /force /Passive /NoRestart" $uninstaller.FullName
}