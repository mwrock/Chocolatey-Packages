$app = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "Microsoft Visual Studio Ultimate 2015 Preview" }
if($app -ne $null){
    $version=$app.Version
    $uninstaller=Get-Childitem "$env:ProgramData\Package Cache\" -Recurse -Filter vs_ultimate.exe | ? { $_.VersionInfo.ProductVersion.startswith($version)}
    Uninstall-ChocolateyPackage 'VisualStudio2015Preview' 'exe' "/Uninstall /force /Passive /NoRestart" $uninstaller.FullName
}
