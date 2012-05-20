# Adapted from http://www.west-wind.com/Weblog/posts/197245.aspx
try {
    if((Test-Path $PROFILE)) {
        $oldProfile = [string[]](Get-Content $PROFILE)
    }

    $tools = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    $emptyTabExpansion = "if(!(Test-Path function:\TabExpansion)) { New-Item function:\TabExpansion -value '' | out-null }"

    if($oldProfile) {
        $newProfile = @()
        $lib = (Split-Path(Split-Path $tools -parent) -parent)
        $promptCheck = "if(Test-Path Function:\Prompt) {Rename-Item Function:\Prompt PrePoshHGPrompt -Force}"
        $poshPromptRename = "Rename-Item Function:\Prompt PoshHGPrompt -Force"
        $newPrompt = "function Prompt() {if(Test-Path Function:\PrePoshHGPrompt){PrePoshHGPrompt}PoshHGPrompt}"
        foreach($line in $oldProfile) {
            foreach($path in (([array](dir $lib\posh-hg.*)))) {
                write-host "ps3: $path\tools\profile.example-ps3.ps1"
                $line = $line.replace(". '$path\tools\profile.example.ps1'", "")
                $line = $line.replace(". '$path\tools\profile.example-ps3.ps1'", "")
            }
            $line = $line.replace($promptCheck, "")
            $line = $line.replace($poshPromptRename, "")
            $line = $line.replace($newPrompt, "")
            $line = $line.replace($emptyTabExpansion, "")
            if($line.Trim().Length -gt 0) {
                $newProfile += $line
            }
        }
        $newProfile += $promptCheck
        Set-Content -path $profile  -value $newProfile -Force
    }
    
    if(!(Get-Command hg -ErrorAction SilentlyContinue)) {
        if( test-path "$env:programfiles\Mercurial" ) {$mPath="$env:programfiles\Mercurial"} else { $mPath = "${env:programfiles(x86)}\Mercurial" }
        Install-ChocolateyPath $mPath
    }

    Install-ChocolateyZipPackage 'posh-hg' '\\vboxsvr\autobox\posh-hg.zip' $tools

    if(!(Test-Path $PROFILE)) {
        Write-Host "Creating PowerShell profile...`n$PROFILE"
        New-Item $PROFILE -Force -Type File
    }
    $newProfile = [string[]](Get-Content $PROFILE)
    $newProfile += $emptyTabExpansion
    Set-Content -path $profile  -value $newProfile -Force

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
