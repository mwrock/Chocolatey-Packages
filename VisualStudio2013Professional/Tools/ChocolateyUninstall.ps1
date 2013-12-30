$app = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "Microsoft Visual Studio Professional 2013" }
if($app -ne $null){
    $version=$app.Version
    $uninstaller=Get-Childitem "$env:ProgramData\Package Cache\" -Recurse -Filter vs_Professional.exe | ? { $_.VersionInfo.ProductVersion.startswith($version)}
    Uninstall-ChocolateyPackage 'VisualStudio2013Professional' 'exe' "/Uninstall /force /Passive /NoRestart" $uninstaller.FullName
}