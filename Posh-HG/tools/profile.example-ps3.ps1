$tools = (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
Push-Location $tools\JeremySkinner-posh-hg-1c29345

# Load posh-hg module from current directory
Import-Module .\posh-hg

# If module is installed in a default location ($env:PSModulePath),
# use this instead (see about_Modules for more information):
# Import-Module posh-hg


# Set up a simple prompt, adding the hg prompt parts inside hg repos
function prompt {
    Write-Host($pwd) -nonewline
        
    # Mercurial Prompt
    $Global:HgStatus = Get-HgStatus
    Write-HgStatus $HgStatus
      
    return "> "
}

if(Test-Path Function:\TabExpansion) {
    if(-not (Test-Path Function:\DefaultTabExpansion)) {
        Rename-Item Function:\TabExpansion DefaultTabExpansion
    }
}

# Set up tab expansion and include hg expansion
function TabExpansion($line, $lastWord) {
    $lastBlock = [regex]::Split($line, '[|;]')[-1]
    
    switch -regex ($lastBlock) {
        # mercurial and tortoisehg tab expansion
        '(hg|thg) (.*)' { HgTabExpansion($lastBlock) }
        # Fall back on existing tab expansion
        default { DefaultTabExpansion $line $lastWord }
    }
}


Pop-Location
