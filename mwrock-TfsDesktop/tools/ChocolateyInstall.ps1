try {
    import-module $env:systemdrive\tools\boxStarter\boxstarter.psm1
    Move-LibraryDirectory "Personal" "$env:UserProfile\skydrive\documents"
    Move-LibraryDirectory "Downloads" "D:\Downloads"

    Install-WindowsUpdate

    Install-ChocolateyEnvironmentVariable "Bootstr_TemplateWorkspace" "wrockdesk_template"

    #Stock TFS dev environment
    & \\cpvsbuild\DROPS\dev11\Q11W\raw\current\binaries.x86ret\bin\i386\TfsBootstraper\build.bat
    
    cinst git-credential-winstore

    cinst console-devel
    Install-ChocolateyPinnedTaskBarItem "$env:programfiles\console\console.exe"
    copy-item (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'console.xml') -Force $env:appdata\console\console.xml

    Set-TaskbarSmall
    Enable-RemoteDesktop
    cinst TelnetClient -source windowsFeatures
    cinst Microsoft-Hyper-V -source windowsFeatures
    cinst Microsoft-Hyper-V-Management-Clients -source windowsFeatures
    Install-ChocolateyPinnedTaskBarItem "$env:windir\system32\mstsc.exe"

    cinst sublimetext2
    $sublimeDir = (Get-ChildItem $env:systemdrive\chocolatey\lib\sublimetext* | select $_.last)
    $sublimeExe = "$sublimeDir\tools\sublime_text.exe"
    copy-item (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'sublime\*') -Force -Recurse "$sublimeDir\tools\data"
    move-item (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) "$sublimeDir\tools\data\Pristine Packages") -Force "$sublimeDir\tools"    
    Install-ChocolateyPinnedTaskBarItem $sublimeExe
    Install-ChocolateyExplorerMenuItem "sublime" "Open with Sublime Text 2" $sublimeExe
    Install-ChocolateyExplorerMenuItem "sublime" "Open with Sublime Text 2" $sublimeExe "directory"
    Install-ChocolateyFileAssociation ".txt" $sublimeExe
    Install-ChocolateyFileAssociation "." txtfile

    cinst skydrive
    cinst fiddler
    cinst winrar
    cinst posh-git-hg
    cinst tortoisehg
    cinst Paint.net
    cinst windirstat
    cinst sysinternals
    cinst evernote
    cinst NugetPackageExplorer
    cinst PowerGUI
    cinst InputDirector
    cinst QTTabBar
    cinst Firefox
    cinst windbg    

    cinst  googlechrome
    Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"

    Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles(x86)}\Microsoft Visual Studio 11.0\Common7\IDE\devenv.exe"
    cinst resharper
    cinst TestDriven.Net

    cinst dotpeek
    $dotPeekDir = (Get-ChildItem $env:systemdrive\chocolatey\lib\dotpeek* | select $_.last)
    Install-ChocolateyFileAssociation".dll" "$dotPeekDir\tools\dotPeek.exe"

    Install-ChocolateyEnvironmentVariable "devFolder" "d:\dev"
    Install-ChocolateyPath "C:\Chocolatey\chocolateyInstall" "Machine"

    cinst autohotkey_l
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

mkdir d:\dev\wit\Q11W
cd d:\dev\wit\Q11W
$tf = "${env:ProgramFiles(x86)}\Microsoft Visual Studio 11.0\Common7\IDE\tf.exe"
.$tf workspace /new /noprompt /template:wrockdesk-q11w_template $env:computername-q11w /collection:http://vstspioneer:8080/tfs/vstsdf /location:local
} 
catch {
    Write-ChocolateyFailure 'mwrock-TfsDesktop' $($_.Exception.Message)
    throw 
}