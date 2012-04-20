if(!(Test-Path $PROFILE)) {
    Write-Host "Creating PowerShell profile...`n$PROFILE"
    New-Item $PROFILE -Force -Type File
}
else {
    & $profile
}

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

$module = Get-Module | Where-Object {$_.Name -eq "posh-hg"}
if($module -eq $null) {
    $tools = ([array](dir $env:ChocolateyInstall\lib\posh-hg.*))[-1]
    $profileLine = ". '$tools\profile.example-ps3.ps1'"    
    Write-Host "Adding posh-hg to profile..."
    @"

    # Load posh-hg example profile
    $profileLine

"@ | Out-File $PROFILE -Append -Encoding (Get-FileEncoding $PROFILE)
}

$module = Get-Module | Where-Object {$_.Name -eq "posh-git"}
if($module -eq $null) {
    $binRoot = join-path $env:systemdrive 'tools'
    if($env:chocolatey_bin_root -ne $null){$binRoot = join-path $env:systemdrive $env:chocolatey_bin_root}
    $poshgitPath = join-path $binRoot 'poshgit'
    $profileLine = ". '$poshgitPath\profile.example.ps1'"    
    Write-Host "Adding posh-git to profile..."
    @"

    # Load posh-git example profile
    $profileLine

"@ | Out-File $PROFILE -Append -Encoding (Get-FileEncoding $PROFILE)
}

$tools = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$profileLine = ". '$tools\profile.example.ps1'"    
Write-Host "Adding posh-git-hg to profile..."
@"

# Load posh-hg-git example profile
$profileLine

"@ | Out-File $PROFILE -Append -Encoding (Get-FileEncoding $PROFILE)

Write-Host 'Please reload your profile for the changes to take effect:'
Write-Host '    . $PROFILE'
