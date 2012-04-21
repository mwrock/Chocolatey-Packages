# Adapted from http://www.west-wind.com/Weblog/posts/197245.aspx
function Get-FileEncoding($Path) {
    $bytes = [byte[]](Get-Content $Path -Encoding byte -ReadCount 4 -TotalCount 4)

    if(!$bytes) { return 'utf8' }

    switch -regex ('{0:x2}{1:x2}{2:x2}{3:x2}' -f $bytes[0],$bytes[1],$bytes[2],$bytes[3]) {
        '^efbbbf'   { return 'utf8' }
        '^2b2f76'   { return 'utf7' }
        '^fffe'     { return 'unicode' }
        '^feff'     { return 'bigendianunicode' }
        '^0000feff' { return 'utf32' }
        default     { return 'ascii' }
    }
}

function Add-Line([string]$profileLine) {
    Write-Host "Adding $profileLine to profile..."
    @"

    $profileLine

"@ | Out-File $PROFILE -Append -Encoding (Get-FileEncoding $PROFILE)
}

function Check-Profile([string] $profileLine) {
    if(!(Select-String -Path $PROFILE -Pattern $profileLine -Quiet -SimpleMatch)) {
        Add-Line $profileLine
    }
}


try {
    if(!(Test-Path $PROFILE)) {
        Write-Host "Creating PowerShell profile...`n$PROFILE"
        New-Item $PROFILE -Force -Type File
    }

    $lib = (Split-Path -parent (Split-Path -parent (Split-Path -parent $MyInvocation.MyCommand.Definition)))
    $poshHg = ([array](dir $lib\posh-hg.*))[-1]
    Check-Profile ". '$poshHg\tools\profile.example-ps3.ps1'"    

    $binRoot = join-path $env:systemdrive 'tools'
    if($env:chocolatey_bin_root -ne $null){$binRoot = join-path $env:systemdrive $env:chocolatey_bin_root}
    $poshgitPath = join-path $binRoot 'poshgit'
    Check-Profile ". $poshgitPath\dahlbyk-posh-git-60e1ed7\profile.example.ps1"

    $tools = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    Check-Profile ". '$tools\profile.example.ps1'"    

    Write-Host 'Please reload your profile for the changes to take effect:'
    Write-Host '    . $PROFILE'
    Write-ChocolateySuccess 'posh-git-hg'
} catch {
  Write-ChocolateyFailure 'posh-git-hg' $($_.Exception.Message)
  throw
}