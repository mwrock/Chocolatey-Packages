param(
	[string]$package,
	[string]$product
)

try {
    $tempDir = Join-Path $env:TEMP "chocolatey\WindowsLive-mw"
    if (!(Test-Path $tempDir)) {New-Item $tempDir -type Directory}
    $file = Join-Path $tempDir "wlsetup-all.exe"
    if(!(Test-Path $file)) { Get-ChocolateyWebFile WindowsLive $file http://g.live.com/1rewlive5-all/en/wlsetup-all.exe }
    Install-ChocolateyInstallPackage $product 'exe' "/q /NOToolbarCEIP /NOhomepage /Nolaunch /nosearch /AppSelect:$product" $file @(0, 3010)
    Write-ChocolateySuccess $package
} catch {
    Write-ChocolateyFailure $package $($_.Exception.Message)
    throw 
}