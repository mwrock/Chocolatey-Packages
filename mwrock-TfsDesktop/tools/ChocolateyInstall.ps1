try {
    import-module $env:systemdrive\tools\boxStarter\boxstarter.psm1
    Move-LibraryDirectory "Personal" "$env:UserProfile\skydrive\documents"
    Install-WindowsUpdate

    Add-PersistentEnvVar "Bootstr_TemplateWorkspace" "mwrock-feature2"

    #Stock TFS dev environment
    #& \\cpvsbuild\DROPS\dev11\Q11W\raw\current\binaries.x86ret\bin\i386\TfsBootstraper\build.bat
    & \\mwrock1\c$\dev\wit\src\vset\internaltools\TfsBootstraper\build.bat

    Install-FromChocolatey console-devel
    Set-PinnedApplication -Action PinToTaskbar -FilePath "$env:programfiles\console\console.exe"
    copy-item (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'console.xml') -Force $env:appdata\console\console.xml

    Set-TaskbarSmall
    Enable-Telnet
    Enable-HyperV
    Set-PinnedApplication -Action PinToTaskbar -FilePath "$env:windir\system32\mstsc.exe"

    Install-FromChocolatey sublimetext2
    $sublimeDir = (Get-ChildItem $env:systemdrive\chocolatey\lib\sublimetext* | select $_.last)
    $sublimeExe = "$sublimeDir\tools\sublime_text.exe"
    copy-item (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'sublime\*') -Force -Recurse "$sublimeDir\tools\"
    Set-PinnedApplication -Action PinToTaskbar -FilePath $sublimeExe
    Add-ExplorerMenuItem "sublime" "Open with Sublime Text 2" $sublimeExe
    Add-ExplorerMenuItem "sublime" "Open with Sublime Text 2" $sublimeExe "folder"
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
    Install-FromChocolatey WindowsLiveMesh
    Install-FromChocolatey InputDirector
    Install-FromChocolatey QTTabBar
    Install-FromChocolatey git-credential-winstore

    Install-FromChocolatey googlechrome
    Set-PinnedApplication -Action PinToTaskbar -FilePath "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"


    Set-PinnedApplication -Action PinToTaskbar -FilePath "${env:ProgramFiles(x86)}\Microsoft Visual Studio 11.0\Common7\IDE\devenv.exe"
    if( Test-Path 'HKCU:\Software\jetbrains\resharper\v7.0\vs11.0' ) {
        $resharperKey = (Get-ItemProperty 'HKCU:\Software\jetbrains\resharper\v7.0\vs11.0')
        $resharperVersion = $resharperKey.'One-Time Initialization Identity'
    }
    if($resharperVersion -ne "Version=7.0.97.60") {
        Install-ChocolateyPackage 'resharper' 'msi' '/quiet' 'http://download.jetbrains.com/resharper/ReSharperSetup.7.0.97.60.msi' 
    }
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

mkdir c:\dev\wit\Q11W
cd c:\dev\wit\Q11W
$tf = "${env:ProgramFiles(x86)}\Microsoft Visual Studio 11.0\Common7\IDE\tf.exe"
.$tf workspace /new /noprompt /template:mwrock-q11w $env:computername-q11w /collection:http://vstspioneer:8080/tfs/vstsdf /location:local

} 
catch {
    Write-ChocolateyFailure 'mwrock-TfsDesktop' $($_.Exception.Message)
    throw 
}