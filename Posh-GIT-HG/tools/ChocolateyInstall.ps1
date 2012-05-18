# Adapted from http://www.west-wind.com/Weblog/posts/197245.aspx
try {
    $oldProfile = [string[]](Get-Content $PROFILE)
    $newProfile = @()
    $lib = (Split-Path -parent (Split-Path -parent (Split-Path -parent $MyInvocation.MyCommand.Definition)))
    $oldPhgProf = ". '$lib\posh-git-hg.1.0.1\profile.example.ps1'"
    $removePoshHGPrompt = "function Prompt() {if(Test-Path Function:\PrePoshHGPrompt){PrePoshHGPrompt}}"
    foreach($line in $oldProfile) {
        $line = $line.replace($oldPhgProf, "")
        $line = $line.replace($removePoshHGPrompt, "")
        if($line.Trim().Length -gt 0) {
            $newProfile += $line
        }        
    }
    $newProfile += $removePoshHGPrompt
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