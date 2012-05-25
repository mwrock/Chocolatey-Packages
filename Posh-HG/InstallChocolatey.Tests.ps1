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
function Prompt(){ `$host.ui.RawUI.WindowTitle = "My Prompt" }
"@
    (Set-Content $Profile -value $profileScript -Force)
}

function Clean-Environment {
    Set-Content $Profile -value $currentProfileScript -Force
}

Describe "Install-Posh-HG" {

    It "WillUpdateOldPs3Version" {
        Cleanup
        Setup-Profile
        try{
            Add-Content $profile -value ". '$env:ChocolateyInstall\lib\Posh-HG.1.1.0.20120417\profile.example-ps3.ps1'"

            RunInstall

            $newProfile = (Get-Content $Profile)
            ($newProfile -like ". '$env:ChocolateyInstall\lib\Posh-HG.1.1.0.20120417\profile.example-ps3.ps1'").Count.should.be(0)
            ($newProfile -like ". '$chocInstallDir\*\profile.example.ps1'").Count.should.be(1)
        }
        catch {
            write-host (Get-Content $Profile)
            throw
        }
        finally {Clean-Environment}
    }

    It "WillRemvePreviousInstallVersion" {
        Cleanup
        Setup-Profile
        try{
            Add-Content $profile -value ". '$env:ChocolateyInstall\lib\Posh-HG.1.1.0.20120517\posh-hg\profile.example.ps1'"

            RunInstall

            $newProfile = (Get-Content $Profile)
            ($newProfile -like ". '$env:ChocolateyInstall\lib\Posh-HG.1.1.0.20120517\*\profile.example.ps1'").Count.should.be(0)
            ($newProfile -like ". ''").Count.should.be(0)
            ($newProfile -like ". '$chocInstallDir\*\profile.example.ps1'").Count.should.be(1)
        }
        catch {
            write-host (Get-Content $Profile)
            throw
        }
        finally {Clean-Environment}
    }

    It "WillNotAddDuplicateCallOnRepeatInstall" {
        Cleanup
        Setup-Profile
        try{
            RunInstall
            Cleanup

            RunInstall

            $newProfile = (Get-Content $Profile)
            ($newProfile -like ". '$chocInstallDir\*\profile.example.ps1'").Count.should.be(1)
        }
        catch {
            write-host (Get-Content $Profile)
            throw
        }
        finally {Clean-Environment}
    }

    It "WillPreserveOldPromptLogic" {
        Cleanup
        Setup-Profile
        try{
            RunInstall
            . $Profile
            $host.ui.RawUI.WindowTitle = "bad"

            Prompt

            $host.ui.RawUI.WindowTitle.should.be("My Prompt")
        }
        catch {
            write-host (Get-Content function:\prompt)
            throw
        }
        finally {
            Clean-Environment
        }
    }

    It "WillSucceedIfHgEnvironmentNotSet" {
        Cleanup
        Setup-Profile
        try{
            $hgPath = Remove-Path "Mercurial"
            Remove-Path "TortoiseHg"

            RunInstall

            $newProfile = (Get-Content $Profile)
            ($newProfile -like ". '$chocInstallDir\*\profile.example.ps1'").Count.should.be(1)
        }
        catch {
            write-host (Get-Content function:\prompt)
            throw
        }
        finally {
            if($hgPath){ $env:path += ";$hgPath" }
            Clean-Environment
        }
    }

    It "WillSucceedIfTabExpansionNotSet" {
        Cleanup
        Setup-Profile
        $tabExpansion = (Get-Content function:\TabExpansion)
        try{
            Remove-Item function:\TabExpansion -Force
            RunInstall
            $errorCount = 0

            try{. $Profile }
            catch { $errorCount = 1}

            $errorCount.should.be(0)
        }
        catch {
            write-host (Get-Content $Profile)
            write-host (Get-Content function:\TabExpansion)
            throw
        }
        finally {
            Clean-Environment
            Set-Content function:\TabExpansion $tabExpansion -Force
        }
    }

    It "WillOutputVcsStatus" {
        Cleanup
        Setup-Profile
        try{
            RunInstall
            mkdir PoshTest
            Pushd PoshTest
            hg init
            . $Profile
            $global:wh=""
            New-Item function:\global:Write-Host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) try{Write-Output `$object;[string]`$global:wh += `$object.ToString()} catch{}"

            Prompt

            Popd
            $wh.should.be("$pwd\PoshTest [default tip]")
        }
        catch {
            write-output (Get-Content $Profile)
            throw
        }
        finally {
            if( Test-Path function:\Write-Host ) {Remove-Item function:\Write-Host}
            if( Test-Path PoshTest ) {Remove-Item PoshTest -Force -Recurse}
            Clean-Environment
        }
    }

    It "WillSucceedOnEmptyProfile" {
        Cleanup
        Setup-Profile
        try{
            Remove-Item $Profile -Force
            RunInstall
            mkdir PoshTest
            Pushd PoshTest
            hg init
            . $Profile
            $global:wh=""
            New-Item function:\global:Write-Host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) try{Write-Output `$object;[string]`$global:wh += `$object.ToString()} catch{}"

            Prompt

            Popd
            $wh.should.be("$pwd\PoshTest [default tip]")
        }
        catch {
            write-output (Get-Content $Profile)
            throw
        }
        finally {
            if( Test-Path function:\Write-Host ) {Remove-Item function:\Write-Host}
            if( Test-Path PoshTest ) {Remove-Item PoshTest -Force -Recurse}
            Clean-Environment
        }
    }

    It "WillNotWriteVcsTwiceWhenUpgradingAfterPoshHgGitInstall" {
        Cleanup
        Cleanup Posh-GIT-HG
        Cleanup PoshGit
        Setup-Profile
        try{
            $poshGitHg = Resolve-Path ..\Posh-GIT-HG
            CINST Posh-GIT-HG -source "$poshGitHg"
            RunInstall
            mkdir ..\..\PoshTest
            Pushd ..\..\PoshTest
            $tempPWD = $PWD
            hg init
            . $Profile
            $global:wh=""
            New-Item function:\global:Write-Host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) try{Write-Output `$object;[string]`$global:wh += `$object.ToString()} catch{}"

            Prompt

            Popd
            $wh.should.be("$tempPWD [default tip]")
            $host.ui.RawUI.WindowTitle.should.be("My Prompt")
        }
        catch {
            write-output (Get-Content $Profile)
            write-output (Get-Content function:\Prompt)
            write-output (Get-Content function:\PrePoshHGPrompt)
            write-output (Get-Content function:\PoshHGPrompt)
            throw
        }
        finally {
            if( Test-Path function:\Write-Host ) {Remove-Item function:\Write-Host}
            if( Test-Path ..\..\PoshTest ) {Remove-Item ..\..\PoshTest -Force -Recurse}
            Clean-Environment
        }
    }
}