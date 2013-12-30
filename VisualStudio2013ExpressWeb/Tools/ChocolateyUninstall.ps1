$app = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "Microsoft Visual Studio Express 2013 for Web - ENU" } | Select-Object -First 1
if($app -ne $null){
    $version=$app.Version
    $uninstaller=Get-Childitem "$env:ProgramData\Package Cache\" -Recurse -Filter vns_full.exe | ? { $_.VersionInfo.ProductVersion.startswith($version)}
    Uninstall-ChocolateyPackage 'VisualStudio2013ExpressWeb' 'exe' "/Uninstall /force /Passive /NoRestart" $uninstaller.FullName
}