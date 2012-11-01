try {
    import-module $env:systemdrive\tools\boxStarter\boxstarter.psm1
    Move-LibraryDirectory "Personal" "$env:UserProfile\skydrive\documents"
    Move-LibraryDirectory "Downloads" "D:\Downloads"

    Install-WindowsUpdate

    #Stock TFS dev environment
    #& \\vscsstor\Tools\tfsbootstrapper\build full-install -sourcePath d:\dev\wit\src -binariesPath c:\dev\wit\binaries -branch $/devdiv/feature/q11w_mwrock2
    #& \\vscsstor\Tools\tfsbootstrapper\build create-workspace -sourcePath d:\dev\wit\q11w -binariesPath c:\dev\wit\q11w\binaries -branch $/devdiv/d11rel/q11w
    
    Install-ChocolateyPinnedTaskBarItem "$env:programfiles\console\console.exe"
    copy-item (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'console.xml') -Force $env:appdata\console\console.xml

    Set-TaskbarSmall
    Enable-RemoteDesktop
    cinst TelnetClient -source windowsFeatures
    cinst Microsoft-Hyper-V -source windowsFeatures
    cinst Microsoft-Hyper-V-Management-Clients -source windowsFeatures
    Install-ChocolateyPinnedTaskBarItem "$env:windir\system32\mstsc.exe"

    $sublimeDir = (Get-ChildItem $env:systemdrive\chocolatey\lib\sublimetext* | select $_.last)
    $sublimeExe = "$sublimeDir\tools\sublime_text.exe"
    copy-item (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'sublime\*') -Force -Recurse "$sublimeDir\tools\data"
    move-item (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) "$sublimeDir\tools\data\Pristine Packages") -Force "$sublimeDir\tools"    
    Install-ChocolateyPinnedTaskBarItem $sublimeExe
    Install-ChocolateyExplorerMenuItem "sublime" "Open with Sublime Text 2" $sublimeExe
    Install-ChocolateyExplorerMenuItem "sublime" "Open with Sublime Text 2" $sublimeExe "directory"
    Install-ChocolateyFileAssociation ".txt" $sublimeExe
    Install-ChocolateyFileAssociation "." txtfile

    Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"

    Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles(x86)}\Microsoft Visual Studio 11.0\Common7\IDE\devenv.exe"

    $dotPeekDir = (Get-ChildItem $env:systemdrive\chocolatey\lib\dotpeek* | select $_.last)
    Install-ChocolateyFileAssociation".dll" "$dotPeekDir\tools\dotPeek.exe"

    $ahk = "$env:appdata\Microsoft\Windows\Start Menu\Programs\startup\AutoScript.ahk"
    set-content $ahk -Force -value @"
^+C::
IfWinExist Console
{
    WinActivate
}
else
{
    Run Console
    WinWait Console
    WinActivate
}
"@
.$ahk
} 
catch {
    Write-ChocolateyFailure 'mwrock-TfsDesktop' $($_.Exception.Message)
    throw 
}