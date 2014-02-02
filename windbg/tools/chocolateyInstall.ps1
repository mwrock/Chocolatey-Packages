try {
    Install-ChocolateyPackage 'windbg' 'exe' "/features OptionId.WindowsDesktopDebuggers /norestart /q /log $env:temp\windbg.log" 'http://download.microsoft.com/download/E/5/D/E5DEED97-B850-4F9A-B660-4AAABE55A931/standalonesdk/sdksetup.exe'    
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

} catch {
  Write-ChocolateyFailure 'Debugging Tools for Windows' $($_.Exception.Message)
  throw
}


