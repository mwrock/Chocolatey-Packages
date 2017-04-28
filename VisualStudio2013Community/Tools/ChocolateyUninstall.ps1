$app = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "Microsoft Visual Studio Community 2013" } | Select-Object -First 1
if($app -ne $null){
    $version=$app.Version
    $uninstaller=Get-Childitem "$env:ProgramData\Package Cache\" -Recurse -Filter vs_community.exe | ? { $_.VersionInfo.ProductVersion.startswith($version)}
    Uninstall-ChocolateyPackage 'VisualStudio2013Community' 'exe' "/Uninstall /force /Passive /NoRestart" $uninstaller.FullName
}
