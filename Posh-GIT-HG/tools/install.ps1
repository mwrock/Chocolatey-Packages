function isCurrentDirectoryARepository($type) {

    if ((Test-Path $type) -eq $TRUE) {
        return $TRUE
    }

    # Test within parent dirs
    $checkIn = (Get-Item .).parent
    while ($checkIn -ne $NULL) {
        $pathToTest = $checkIn.fullname + '/' + $type;
        if ((Test-Path $pathToTest) -eq $TRUE) {
            return $TRUE
        } else {
            $checkIn = $checkIn.parent
        }
    }
    return $FALSE
}

function prompt(){
    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    Write-Host($pwd) -nonewline

    if (isCurrentDirectoryARepository(".git")) {
        # Git Prompt
        $Global:GitStatus = Get-GitStatus
        Write-GitStatus $GitStatus
    } elseif (isCurrentDirectoryARepository(".hg")) {
        # Mercurial Prompt
        $Global:HgStatus = Get-HgStatus
        Write-HgStatus $HgStatus
    }

    return "> "
}