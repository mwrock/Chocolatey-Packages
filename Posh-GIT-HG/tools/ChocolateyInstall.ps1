try {
    $oldProfile = [string[]](Get-Content $PROFILE)
    $newProfile = @()
    $lib = (Split-Path -parent (Split-Path -parent (Split-Path -parent $MyInvocation.MyCommand.Definition)))
    $oldPhgProf = ". '$lib\posh-git-hg.1.0.1\profile.example.ps1'"
    $oldPromptOverride = "function Prompt() {if(Test-Path Function:\PrePoshHGPrompt){PrePoshHGPrompt}PoshHGPrompt}"
    $newPromptOverride = "function Prompt() {if(Test-Path Function:\PrePoshHGPrompt){++`$global:poshScope; New-Item function:\script:Write-host -value `"param([object] ```$object, ```$backgroundColor, ```$foregroundColor, [switch] ```$nonewline) `" -Force | Out-Null;`$private:p = PrePoshHGPrompt; if(--`$global:poshScope -eq 0) {Remove-Item function:\Write-Host -Force}}PoshHGPrompt}"
    foreach($line in $oldProfile) {
        $line = $line.replace($oldPhgProf, "")
        $line = $line.replace($newPromptOverride, "")
        $line = $line.replace($oldPromptOverride, "")
        if($line.Trim().Length -gt 0) {
            $newProfile += $line
        }        
    }
    $newProfile += $newPromptOverride
    Set-Content -path $profile  -value $newProfile -Force
    Write-Host 'Please reload your profile for the changes to take effect:'
    Write-Host '    . $PROFILE'
    Write-ChocolateySuccess 'posh-git-hg'
} catch {
  try {
    if($oldProfile){
        Set-Content -path $PROFILE -value $oldProfile -Force
    }
  }
  catch{}
  Write-ChocolateyFailure 'posh-git-hg' $($_.Exception.Message)
  throw
}