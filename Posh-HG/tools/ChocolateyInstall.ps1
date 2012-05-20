# Adapted from http://www.west-wind.com/Weblog/posts/197245.aspx
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
