function Insert-Script([ref]$originalScript, $script) {
    if(!($originalScript.Value -Contains $script)) { $originalScript.Value += $script }
}

try {
    if((Test-Path $PROFILE)) {
        $oldProfile = [string[]](Get-Content $PROFILE)
    }
    else {
        Write-Host "Creating PowerShell profile...`n$PROFILE"
        New-Item $PROFILE -Force -Type File
    }

    $tools = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    if($oldProfile) {
        $newProfile = @()
        $lib = (Split-Path(Split-Path $tools -parent) -parent)
        #Clean out old profiles
        foreach($line in $oldProfile) {
            foreach($path in (([array](dir $lib\posh-hg.*)))) {
                if((Join-Path $path "tools") -ne $tools) {
                    $line = $line.replace(". '$path\tools\posh-hg\profile.example.ps1'", "")
                }
                $line = $line.replace(". '$path\tools\posh-hg\profile.example-ps3.ps1'", "")
            }
            if($line.Trim().Length -gt 0) {
                $newProfile += $line
            }
        }
        #Save any previous Prompt logic
        Insert-Script ([REF]$newProfile) "if(Test-Path Function:\Prompt) {Rename-Item Function:\Prompt PrePoshHGPrompt -Force}"
        Set-Content -path $profile  -value $newProfile -Force
    }
    
    #If Mercurial is installed in same session, the path set will not be present here and posh-hg install will fail
    if(!(Get-Command hg -ErrorAction SilentlyContinue)) {
        if( test-path "$env:programfiles\Mercurial" ) {$mPath="$env:programfiles\Mercurial"} else { $mPath = "${env:programfiles(x86)}\Mercurial" }
        Install-ChocolateyPath $mPath
        $aliasedHG = $true
    }

    #for PS 3.0 TabExpansion function won't exist and podh-hg install will throw error
    $newProfile = [string[]](Get-Content $PROFILE)
    Insert-Script ([REF]$newProfile) "if(!(Test-Path function:\TabExpansion)) { New-Item function:\TabExpansion -value '' | out-null }"
    Set-Content -path $profile  -value $newProfile -Force

    Install-ChocolateyZipPackage 'posh-hg' 'c:\dev\autobox\posh-hg.zip' $tools
    $install = (Get-Item "$tools\*\install.ps1")
    & $install

    if($oldProfile) {
        $newProfile = [string[]](Get-Content $PROFILE)
        Insert-Script ([REF]$newProfile) "Rename-Item Function:\Prompt PoshHGPrompt -Force"
        Insert-Script ([REF]$newProfile) "function Prompt() {if(Test-Path Function:\PrePoshHGPrompt){PrePoshHGPrompt}PoshHGPrompt}"
        Set-Content -path $profile  -value $newProfile -Force
    }

    if($aliasedHG) {
        Write-Host 'chocolatey sucessfully installed both Mercurial and posh-hg'
        Write-Host 'Changes will be applied to all new shells'
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
