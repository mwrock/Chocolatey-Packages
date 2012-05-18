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
    $lib = (Split-Path -parent (Split-Path -parent (Split-Path -parent $MyInvocation.MyCommand.Definition)))
    $oldPhgProf = ". '$lib\posh-git-hg.1.0.1\profile.example.ps1'"
    (Get-Content $PROFILE) | ForEach-Object {
        % {$_ -replace $oldPhgProf, "" }
    } | Set-Content $PROFILE

    Write-Host 'Please reload your profile for the changes to take effect:'
    Write-Host '    . $PROFILE'
    Write-ChocolateySuccess 'posh-git-hg'
} catch {
  Write-ChocolateyFailure 'posh-git-hg' $($_.Exception.Message)
  throw
}