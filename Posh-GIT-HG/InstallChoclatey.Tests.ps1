. ../Test-Helpers.ps1

function BuildAndCopy($path) {
    $nuspec = Get-item $path\*.nuspec
    cpack $nuspec
}

BuildAndCopy ..\posh-hg
BuildAndCopy ..\..\nugetpackages\poshGit

if(Test-Path $Profile) { $currentProfileScript = (Get-Content $Profile) }

function Setup-Profile {
    $profileScript = @"
function Prompt() {if(Test-Path Function:\PrePoshHGPrompt){PrePoshHGPrompt}}
function prompt(){ `$host.ui.RawUI.WindowTitle = `$(get-location) }
. '$env:ChocolateyInstall\lib\posh-git-hg.1.0.1\profile.example.ps1'
if(Test-Path Function:\Prompt) {Rename-Item Function:\Prompt PrePoshHGPrompt -Force}
if(!(Test-Path function:\TabExpansion)) { New-Item function:\Global:TabExpansion -value '' | Out-Null }
# Load posh-hg example profile
. '$env:ChocolateyInstall\lib\Posh-HG.1.1.0.20120526\posh-hg\profile.example.ps1'
Rename-Item Function:\Prompt PoshHGPrompt -Force
function Prompt() {if(Test-Path Function:\PrePoshHGPrompt){PrePoshHGPrompt}PoshHGPrompt}
"@
    Set-Content $Profile -value $profileScript -Force
}

function Clean-Environment {
    Set-Content $Profile -value $currentProfileScript -Force
}

Describe "Install-Posh-Git-HG" {

    It "WillRemoveOldExampleProfile" {
        Cleanup
        Setup-Profile
        try{
            CINST Posh-git-Hg -Version 1.0.1 -source (Resolve-Path .)

            RunInstall

            $newProfile = (Get-Content $Profile)
            ($newProfile -Contains ". '$env:ChocolateyInstall\lib\posh-git-hg.1.0.1\profile.example.ps1'").should.be($false)
        }
        catch {
            write-host (Get-Content $Profile)
            throw
        }
        finally {Clean-Environment}
    }

    It "WillRemoveOldPromptOverride" {
        Cleanup
        Setup-Profile
        try{
            RunInstall

            . $Profile

            $newPrompt = (Get-Content function:\Prompt)
            ($newPrompt -like "*if(Test-Path Function:\PrePoshHGPrompt){PrePoshHGPrompt}PoshHGPrompt").should.be($false)
        }
        catch {
            write-host (Get-Content $Profile)
            write-host (Get-Content function:\Prompt)
            throw
        }
        finally {Clean-Environment}
    }

    It "WillNotWriteVcsTwiceForHG" {
        Cleanup
        Cleanup Posh-GIT-HG
        Cleanup PoshGit
        Cleanup Posh-HG
        Setup-Profile
        try{
            Remove-Item $Profile -Force
            Add-Content $profile -value "function Prompt(){ `$host.ui.RawUI.WindowTitle = `"My Prompt`" }" -Force
            $env:poshGit = join-path (Resolve-Path ..\..\nugetpackages\poshgit\Tests ) dahlbyk-posh-git-60be436.zip
            RunInstall
            mkdir ..\..\PoshHgTest
            Pushd ..\..\PoshHgTest
            $tempPWD = $PWD
            hg init
            . $Profile
            $global:wh=""
            New-Item function:\global:Write-Host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) try{Write-Output `$object;if(`$poshScope -eq 0){[string]`$global:wh += `$object.ToString()}} catch{}"

            Prompt

            Popd
            $wh.should.be("$tempPWD [default tip]")
            $host.ui.RawUI.WindowTitle.should.be("My Prompt")
        }
        catch {
            if( Test-Path function:\global:Write-Host ) {Remove-Item function:\global:Write-Host}
            write-output (Get-Content $Profile)
            write-output (Get-Content function:\Prompt)
            throw
        }
        finally {
            Clean-Environment
            if( Test-Path function:\global:Write-Host ) {Remove-Item function:\Write-Host}
            if( Test-Path ..\..\PoshHgTest ) {Remove-Item ..\..\PoshHgTest -Force -Recurse}
        }
    }

    It "WillNotWriteVcsTwiceForIfInstallingPoshGitFirst" {
        Cleanup
        Cleanup Posh-GIT-HG
        Cleanup PoshGit
        Cleanup Posh-HG
        Setup-Profile
        try{
            Remove-Item $Profile -Force
            $env:poshGit = join-path (Resolve-Path ..\..\nugetpackages\poshgit\Tests ) dahlbyk-posh-git-60be436.zip
            CINST Poshgit -source (Resolve-Path .)
            RunInstall
            mkdir ..\..\PoshHgTest
            Pushd ..\..\PoshHgTest
            $tempPWD = $PWD
            hg init
            . $Profile
            $global:wh=""
            New-Item function:\global:Write-Host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) try{Write-Output `$object;if(`$poshScope -eq 0){[string]`$global:wh += `$object.ToString()}} catch{}"

            Prompt

            Popd
            $wh.should.be("$tempPWD [default tip]")
        }
        catch {
            if( Test-Path function:\global:Write-Host ) {Remove-Item function:\global:Write-Host}
            write-output (Get-Content $Profile)
            write-output (Get-Content function:\Prompt)
            throw
        }
        finally {
            #write-output (Get-Content $Profile)
            Clean-Environment
            if( Test-Path function:\global:Write-Host ) {Remove-Item function:\Write-Host}
            if( Test-Path ..\..\PoshHgTest ) {Remove-Item ..\..\PoshHgTest -Force -Recurse}
        }
    }
}