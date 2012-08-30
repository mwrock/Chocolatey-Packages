try {
    import-module $env:systemdrive\tools\boxStarter\boxstarter.psm1
    Move-LibraryDirectory "Personal" "$env:UserProfile\skydrive\documents"
    Move-LibraryDirectory "Downloads" "D:\Downloads"

    Install-WindowsUpdate

    Add-PersistentEnvVar "Bootstr_TemplateWorkspace" "wrockdesk_template"

    #Stock TFS dev environment
    & \\cpvsbuild\DROPS\dev11\Q11W\raw\current\binaries.x86ret\bin\i386\TfsBootstraper\build.bat
    
    Install-FromChocolatey git-credential-winstore

    Install-FromChocolatey console-devel
    Set-PinnedApplication -Action PinToTaskbar -FilePath "$env:programfiles\console\console.exe"
    copy-item (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'console.xml') -Force $env:appdata\console\console.xml

    Set-TaskbarSmall
    Enable-RemoteDesktop
    Enable-Telnet
    Enable-HyperV
    Set-PinnedApplication -Action PinToTaskbar -FilePath "$env:windir\system32\mstsc.exe"

    Install-FromChocolatey sublimetext2
    $sublimeDir = (Get-ChildItem $env:systemdrive\chocolatey\lib\sublimetext* | select $_.last)
    $sublimeExe = "$sublimeDir\tools\sublime_text.exe"
    copy-item (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'sublime\*') -Force -Recurse "$sublimeDir\tools\data"
    move-item (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) "$sublimeDir\tools\data\Pristine Packages") -Force "$sublimeDir\tools"    
    Set-PinnedApplication -Action PinToTaskbar -FilePath $sublimeExe
    Add-ExplorerMenuItem "sublime" "Open with Sublime Text 2" $sublimeExe
    Add-ExplorerMenuItem "sublime" "Open with Sublime Text 2" $sublimeExe "directory"
    Set-FileAssociation ".txt" $sublimeExe
    cmd /c assoc .=txtfile

    Install-FromChocolatey skydrive
    Install-FromChocolatey fiddler
    Install-FromChocolatey winrar
    Install-FromChocolatey posh-git-hg
    Install-FromChocolatey tortoisehg
    Install-FromChocolatey Paint.net
    Install-FromChocolatey windirstat
    Install-FromChocolatey sysinternals
    Install-FromChocolatey evernote
    Install-FromChocolatey NugetPackageExplorer
    Install-FromChocolatey PowerGUI
    Install-FromChocolatey InputDirector
    Install-FromChocolatey QTTabBar
    Install-FromChocolatey Firefox

    Install-FromChocolatey googlechrome
    Set-PinnedApplication -Action PinToTaskbar -FilePath "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"


    Set-PinnedApplication -Action PinToTaskbar -FilePath "${env:ProgramFiles(x86)}\Microsoft Visual Studio 11.0\Common7\IDE\devenv.exe"
    Install-FromChocolatey resharper
    Install-FromChocolatey TestDriven.Net

    Install-FromChocolatey dotpeek
    $dotPeekDir = (Get-ChildItem $env:systemdrive\chocolatey\lib\dotpeek* | select $_.last)
    Set-FileAssociation ".dll" "$dotPeekDir\tools\dotPeek.exe"

    Add-PersistentEnvVar "devFolder" "d:\dev"
    Install-ChocolateyPath "C:\Chocolatey\chocolateyInstall" "Machine"

    Install-FromChocolatey autohotkey_l
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