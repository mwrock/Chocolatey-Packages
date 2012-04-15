param(
	[string]$package,
	[string]$product
)

try {
    $tempDir = Join-Path $env:TEMP "chocolatey\WindowsLive-mw"
    if (!(Test-Path $tempDir)) {New-Item $tempDir -type Directory}
    $file = Join-Path $tempDir "wlsetup-all.exe"
    if(!(Test-Path $file)) { Get-ChocolateyWebFile WindowsLive $file http://g.live.com/1rewlive4-all/en/wlsetup-all.exe }
    Install-ChocolateyInstallPackage "WindowsLiveMesh" 'exe' "/q /NOToolbarCEIP /NOhomepage /Nolaunch /nosearch /AppSelect:$product" $file
    Write-ChocolateySuccess $package
} catch {
    Write-ChocolateyFailure $package $($_.Exception.Message)
    throw 
}