Install-WindowsUpdate -AcceptEula
Update-ExecutionPolicy Unrestricted
Move-LibraryDirectory "Personal" "$env:UserProfile\skydrive\documents"

#Stock TFS dev environment
#& \\vscsstor\Tools\tfsbootstrapper\build full-install -sourcePath d:\dev\wit\src -binariesPath c:\dev\wit\binaries -branch $/devdiv/feature/q11w_mwrock2
#& \\vscsstor\Tools\tfsbootstrapper\build create-workspace -sourcePath d:\dev\wit\q11w -binariesPath c:\dev\wit\q11w\binaries -branch $/devdiv/d11rel/q11w

Set-ExplorerOptions -showHidenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions
Set-TaskbarSmall
Enable-RemoteDesktop

cinstm git-credential-winstore 
cinstm console-devel 
cinstm sublimetext2 
cinstm skydrive 
cinstm fiddler 
cinstm poshgit       
cinstm winrar 
cinstm Paint.net 
cinstm windirstat 
cinstm sysinternals 
cinstm evernote 
cinstm NugetPackageExplorer 
cinstm InputDirector 
cinstm QTTabBar 
cinstm Firefox 
cinstm windbg 
cinstm googlechrome 
cinstm resharper 
cinstm TestDriven.Net 
cinstm dotpeek 
cinstm autohotkey_l 

cinst Microsoft-Hyper-V-All -source windowsFeatures
cinst TelnetClient -source windowsFeatures

Install-ChocolateyVsixPackage vscommands http://visualstudiogallery.msdn.microsoft.com/a83505c6-77b3-44a6-b53b-73d77cba84c8/file/74740/18/SquaredInfinity.VSCommands.VS11.vsix

$sublimeDir = "$env:programfiles\Sublime Text 2"

Install-ChocolateyPinnedTaskBarItem "$env:windir\system32\mstsc.exe"
Install-ChocolateyPinnedTaskBarItem "$env:programfiles\console\console.exe"
Install-ChocolateyPinnedTaskBarItem "$sublimeDir\sublime_text.exe"
Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Google\Chrome\Application\chrome.exe"
Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Microsoft Visual Studio 11.0\Common7\IDE\devenv.exe"

#Install-ChocolateyFileAssociation "." txtfile
Install-ChocolateyFileAssociation ".txt" "$env:programfiles\Sublime Text 2\sublime_text.exe"
Install-ChocolateyFileAssociation ".dll" "$($Boxstarter.ChocolateyBin)\dotPeek.bat"

mkdir "$sublimeDir\data"
copy-item (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'sublime\*') -Force -Recurse "$sublimeDir\data"
move-item "$sublimeDir\data\Pristine Packages\*" -Force "$sublimeDir\Pristine Packages"
copy-item (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'console.xml') -Force $env:appdata\console\console.xml

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
