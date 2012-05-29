function Insert-Script([ref]$originalScript, $script) {
    if(!($originalScript.Value -Contains $script)) { $originalScript.Value += $script }
}

try {
    $tools = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    $poshHgInstall = if($env:poshHgZip -ne $null){ $env:poshHgZip } else {'https://github.com/JeremySkinner/posh-hg/zipball/master'}
    $newPromptOverride = "function Prompt() {if(Test-Path Function:\PrePoshHGPrompt){++`$global:poshScope; New-Item function:\script:Write-host -value `"param([object] ```$object, ```$backgroundColor, ```$foregroundColor, [switch] ```$nonewline) `" -Force | Out-Null;`$private:p = PrePoshHGPrompt; if(--`$global:poshScope -eq 0) {Remove-Item function:\Write-Host -Force}}PoshHGPrompt}"
    Install-ChocolateyZipPackage 'posh-hg' $poshHgInstall $tools

    if(Test-Path $PROFILE) {
        $oldProfile = [string[]](Get-Content $PROFILE)
        $newProfile = @()
        $lib = "$env:chocolateyInstall\lib"
        #Clean out old profiles
        $phg = Get-Item "$tools\*posh-hg*\profile.example.ps1"
        foreach($line in $oldProfile) {
            if($line.Contains("function Prompt() {if(Test-Path Function:\PrePoshHGPrompt){PrePoshHGPrompt}PoshHGPrompt}")){ $line=$newPromptOverride }
            if($line.Contains("profile.example-ps3.ps1")){ $line="" }
            elseif($line.ToLower().Contains("$lib\posh-hg.".ToLower())) { $line = ". '$phg'" }
            if($line.Trim().Length -gt 0) {  $newProfile += $line }
        }
        #Save any previous Prompt logic
        Insert-Script ([REF]$newProfile) "if(Test-Path Function:\Prompt) {Rename-Item Function:\Prompt PrePoshHGPrompt -Force}"
        Set-Content -path $profile -value $newProfile -Force
    }
    else {
        Write-Host "Creating PowerShell profile...`n$PROFILE"
        New-Item $PROFILE -Force -Type File
    }

    #If Mercurial is installed in same session, the path set will not be present here and posh-hg install will fail
    if(!(Get-Command hg -ErrorAction SilentlyContinue)) {
        if( test-path "$env:programfiles\Mercurial" ) {$mPath="$env:programfiles\Mercurial"} else { $mPath = "${env:programfiles(x86)}\Mercurial" }
        $env:Path += ";$mPath"
        $aliasedHG = $true
    }

    #for PS 3.0 TabExpansion function won't exist and podh-hg install will throw error
    $newProfile = [string[]](Get-Content $PROFILE)
    Insert-Script ([REF]$newProfile) "if(!(Test-Path function:\TabExpansion)) { New-Item function:\Global:TabExpansion -value '' | Out-Null }"
    Set-Content -path $profile  -value $newProfile -Force

    $install = (Get-Item "$tools\*\install.ps1")
    & $install

    #Preserve any prior prompt logic but hide its output
    $newProfile = [string[]](Get-Content $PROFILE)
    Insert-Script ([REF]$newProfile) "Rename-Item Function:\Prompt PoshHGPrompt -Force"
    Insert-Script ([REF]$newProfile) $newPromptOverride
    Set-Content -path $profile  -value $newProfile -Force

    if($aliasedHG) {
        Write-Host 'chocolatey sucessfully installed both Mercurial and posh-hg'
        Write-Host 'Changes will be applied to all new shells'
    }

    Write-ChocolateySuccess 'posh-hg'
} 
catch {
  try {
    if($oldProfile){ Set-Content -path $PROFILE -value $oldProfile -Force }
  }
  catch{}
  Write-ChocolateyFailure 'posh-hg' $($_.Exception.Message)
  throw
}
