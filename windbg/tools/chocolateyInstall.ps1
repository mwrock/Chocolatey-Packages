try {
$tempFolder = "$env:temp\chocolatey\windbg"
mkdir $tempFolder -ErrorAction SilentlyContinue

$path = "http://download.microsoft.com/download/B/0/C/B0C80BA3-8AD6-4958-810B-6882485230B5/standalonesdk/Installers"
$files = @(
    "$path/SDK%20Debuggers-x86_en-us.msi",
    "$path/X64%20Debuggers%20And%20Tools-x64_en-us.msi",
    "$path/X86%20Debuggers%20And%20Tools-x86_en-us.msi",
    "$path/0253f7df0974f9d7169b410d812a5385.cab",
    "$path/114c321d61ae77816824fed67cd25704.cab",
    "$path/1a822224523be67061edcc97f6c0e36a.cab",
    "$path/2c1331a0f4ecc46dfa39f43a575305e0.cab",
    "$path/2c1817d3f3f33cd01376c5ec441cc636.cab",
    "$path/34ee98a7c9420178c55f176f75c3fe10.cab",
    "$path/3960f55df7c8073f3997269e5e390abc.cab",
    "$path/3a53dffe0b4548753bc34825894f19bf.cab",
    "$path/3ca392fde3898c3be052ddcddd14bb5f.cab",
    "$path/437e52bd67ebe977a8957439db5ecf75.cab",
    "$path/4ac48dbdddbc8ce04721f519b9cf1698.cab",
    "$path/4de7a1422374f98369172705b05d4bf9.cab",
    "$path/7178f554c01f912c749b622564106b02.cab",
    "$path/72bda6e16f5c7a040361c1304b4b5b36.cab",
    "$path/79e9b68a34bc84ab465fe1b79b84a325.cab",
    "$path/7cb1ba9318f4b586c6a3bdd541e7f3ad.cab",
    "$path/96e8f767221532c6446fd1b8dad53b60.cab",
    "$path/a74408a87a51829b89e5282e73974d74.cab",
    "$path/ab8c11616091812d6c7137e366ba1d8d.cab",
    "$path/b98a31e36735eb82b3b238c68f36fbbf.cab",
    "$path/ba5d20281a858248e59d96d75c014391.cab",
    "$path/baa2d817ae180ba7e772f1543c3bbdea.cab",
    "$path/d55d1e003fbb00a12c63b8f618e452bf.cab",
    "$path/dcb0a55d6cacaa05ead299e1d3de3c6d.cab",
    "$path/e10f9740446a96314a1731aa7cb4286a.cab",
    "$path/e8bc712abeffd7c9711ee3f55d4aa99b.cab",
    "$path/fe80f1b6d4cf60c919f4b3a0cd2f4306.cab"
)

foreach ($file in $files) {
    Get-ChocolateyWebFile "windbg" "$tempFolder\$($file.substring($file.lastindexof('/')+1).replace('%20',' '))" $file
}

Install-ChocolateyInstallPackage "windbg" "msi" "/q" "$tempFolder\SDK Debuggers-x86_en-us.msi"

    if(${env:ProgramFiles(x86)} -ne $null){ $programFiles86 = ${env:ProgramFiles(x86)} } else { $programFiles86 = $env:ProgramFiles }
    $windbgPath = (Join-Path $programFiles86 "Windows Kits\8.1\Debuggers")
    [Environment]::SetEnvironmentVariable( '_NT_SYMBOL_PATH', 'symsrv*symsrv.dll*f:\localsymbols*http://msdl.microsoft.com/download/symbols', 'User')
    $env:_NT_SYMBOL_PATH = "symsrv*symsrv.dll*f:\localsymbols*http://msdl.microsoft.com/download/symbols"
    
    $fxDir = "$env:windir\Microsoft.NET\Framework"
    if(Test-Path $fxDir) {
        $frameworksx86 = dir "$fxdir\v*" | ? { $_.psiscontainer -and $_.Name -match "v[0-9]" }
    }

$statement = @"
    copy-item (join-path '$($frameworksx86[-1])' "sos.dll") '$windbgPath\x86';
    copy-item '$windbgPath\x86\windbg.exe' '$windbgPath\x86\windbgx86.exe';
    Install-ChocolateyDesktopLink '$windbgPath\x64\windbg.exe';
    Install-ChocolateyDesktopLink '$windbgPath\x86\windbgx86.exe';
"@
    $fxDir = "${fxdir}64"
    if(Test-Path $fxDir) {
        $frameworksx64 = dir "$fxdir\v*" | ? { $_.psiscontainer -and $_.Name -match "v[0-9]"}
        $statement += @"
        copy-item (join-path '$($frameworksx64[-1])' "sos.dll") '$windbgPath\x64';
"@
    }
    
    Start-ChocolateyProcessAsAdmin "$statement" -minimized -nosleep

    Write-ChocolateySuccess 'windbg'

} catch {
  Write-ChocolateyFailure 'windbg' $($_.Exception.Message)
  throw
}
