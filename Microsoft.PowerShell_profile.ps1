$dev = "c:\dev"
$da = "$dev\autobox"
$ds = "$dev\SocialBuilds"
$hostFile="$env:windir\system32\drivers\etc\hosts"

$host.ui.RawUI.WindowTitle = $(get-location)
$p86 = if( ${env:programfiles(x86)} -ne $null){${env:programfiles(x86)}} else {$env:programfiles}

sal sub "$env:programfiles\Sublime Text 2\sublime_text.exe"
sal ch $p86\Google\Chrome\Application\chrome.exe

. 'C:\Chocolatey\lib\Posh-HG.1.1.0.20120417\tools\profile.example-ps3.ps1'
. 'C:\tools\poshgit\dahlbyk-posh-git-60be436\profile.example.ps1'
Rename-Item Function:\prompt OrigPrompt

function prompt(){
    $host.ui.RawUI.WindowTitle = $(get-location)
    OrigPrompt
}




