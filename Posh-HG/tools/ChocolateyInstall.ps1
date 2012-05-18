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

try {
    if((Test-Path $PROFILE)) {
        $oldProfile = [string[]](Get-Content $PROFILE)
    }

    $tools = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    if($oldProfile) {
        $newProfile = @()
        $lib = (Split-Path(Split-Path $tools -parent) -parent)
        $promptCheck = "if(Test-Path Function:\Prompt) {Rename-Item Function:\Prompt PrePoshHGPrompt -Force}"
        $poshPromptRename = "Rename-Item Function:\Prompt PoshHGPrompt -Force"
        $newPrompt = "function Prompt() {if(Test-Path Function:\PrePoshHGPrompt){PrePoshHGPrompt}PoshHGPrompt}"
        foreach($line in $oldProfile) {
            foreach($path in (([array](dir $lib\posh-hg.*)))) {
                $line = $line.replace(". '$path\tools\profile.example.ps1'", "")
                $line = $line.replace(". '$path\tools\profile.example-ps3.ps1'", "")
            }
            $line = $line.replace($promptCheck, "")
            $line = $line.replace($poshPromptRename, "")
            $line = $line.replace($newPrompt, "")
            if($line.Trim().Length -gt 0) {
                $newProfile += $line
            }
        }
        $newProfile += $promptCheck
        Set-Content -path $profile  -value $newProfile -Force
    }

    Install-ChocolateyZipPackage 'posh-hg' 'c:\dev\posh-hg.zip' $tools

    $install = (Get-Item "$tools\*\install.ps1")
    & $install

    if($oldProfile) {
        $newProfile = [string[]](Get-Content $PROFILE)
        $newProfile += $poshPromptRename
        $newProfile += $newPrompt
        Set-Content -path $profile  -value $newProfile -Force
    }

    $prof = (Get-Item "$tools\*\profile.example.ps1")
@"
if(Test-Path Function:\TabExpansion) {
    if(-not (Test-Path Function:\DefaultTabExpansion)) {
        Rename-Item Function:\TabExpansion DefaultTabExpansion
    }
}

# Set up tab expansion and include hg expansion
function TabExpansion(`$line, `$lastWord) {
    `$lastBlock = [regex]::Split(`$line, '[|;]')[-1]
    
    switch -regex (`$lastBlock) {
        # mercurial and tortoisehg tab expansion
        '(hg|thg) (.*)' { HgTabExpansion(`$lastBlock) }
        # Fall back on existing tab expansion
        default { DefaultTabExpansion `$line `$lastWord }
    }
}
"@ | Out-File $prof -Append -Encoding (Get-FileEncoding $prof)

    Write-ChocolateySuccess 'posh-hg'
} catch {
  try {
    if($oldProfile){
        Set-Content -path $PROFILE -value $oldProfile -Force
    }
  }
  catch{}
  Write-ChocolateyFailure 'posh-hg' $($_.Exception.Message)
  throw
}
