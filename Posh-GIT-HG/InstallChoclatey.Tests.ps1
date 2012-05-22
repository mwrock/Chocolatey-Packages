. ../Test-Helpers.ps1
if(Test-Path $Profile) { $currentProfileScript = (Get-Content $Profile) }

function Setup-Profile {
    $profileScript = @"
`$dev = "c:\dev"
`$da = "`$dev\autobox"
`$ds = "`$dev\SocialBuilds"
`$hostFile="`$env:windir\system32\drivers\etc\hosts"
`$host.ui.RawUI.WindowTitle = `$(get-location)
`$p86 = if( `${env:programfiles(x86)} -ne `$null){`${env:programfiles(x86)}} else {`$env:programfiles}
sal sub "`$env:programfiles\Sublime Text 2\sublime_text.exe"
sal ch `$p86\Google\Chrome\Application\chrome.exe
function Prompt() {if(Test-Path Function:\PrePoshHGPrompt){PrePoshHGPrompt}}
function prompt(){ `$host.ui.RawUI.WindowTitle = `$(get-location) }
. 'C:\Chocolatey\lib\posh-git-hg.1.0.1\profile.example.ps1'
if(Test-Path Function:\Prompt) {Rename-Item Function:\Prompt PrePoshHGPrompt -Force}
if(!(Test-Path function:\TabExpansion)) { New-Item function:\Global:TabExpansion -value '' | Out-Null }
# Load posh-hg example profile
. 'C:\Chocolatey\lib\Posh-HG.1.1.0.20120520\posh-hg\profile.example.ps1'
Rename-Item Function:\Prompt PoshHGPrompt -Force
function Prompt() {if(Test-Path Function:\PrePoshHGPrompt){PrePoshHGPrompt}PoshHGPrompt}
"@
    Set-Content $Profile -value $profileScript -Force
}

function Clean-Environment {
    Set-Content $Profile -value $currentProfileScript -Force
}

Describe "Install-Posh-HG" {

    It "WillRemoveOldExampleProfile" {
        Cleanup
        Setup-Profile
        try{
            CINST Posh-git-Hg -Version 1.0.1

            RunInstall

            $newProfile = (Get-Content $Profile)
            ($newProfile -Contains ". 'C:\Chocolatey\lib\posh-git-hg.1.0.1\profile.example.ps1'").should.be($false)
        }
        catch {
            write-host (Get-Content $Profile)
            throw
        }
        finally {Clean-Environment}
    }

    It "WillMovePromptOverrideToBottom" {
        Cleanup
        Setup-Profile
        try{
            RunInstall

            . $Profile

            $newProfile = (Get-Content $Profile)
            ($newProfile -like "function Prompt() {if(Test-Path Function:\PrePoshHGPrompt){PrePoshHGPrompt}}").Count.should.be(0)
            $newPrompt = (Get-Content function:\prompt)
            ($newPrompt -Contains "PoshHGPrompt").should.be($false)
        }
        catch {
            write-host (Get-Content $Profile)
            throw
        }
        finally {Clean-Environment}
    }

}