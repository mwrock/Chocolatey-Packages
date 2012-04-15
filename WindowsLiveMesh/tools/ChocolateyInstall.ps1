try {
    $tempDir = Join-Path $env:TEMP "chocolatey\WindowsLive-mw"
    if (!(Test-Path $tempDir)) {New-Item $tempDir -type Directory}
    $file = Join-Path $tempDir "wlsetup-all.exe"
    if(!(Test-Path $file)) { Get-ChocolateyWebFile WindowsLive $file http://g.live.com/1rewlive3/en/wlsetup-all.exe }
    Install-ChocolateyInstallPackage 'WindowsLiveMesh' 'exe' '/q /NOToolbarCEIP /NOhomepage /Nolaunch /nosearch /AppSelect:wlsync' $file
    Write-ChocolateySuccess 'Windows Live Mesh'
} catch {
    Write-ChocolateyFailure 'Windows Live Mesh' $($_.Exception.Message)
    throw 
}