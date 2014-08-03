try {
    Update-ExecutionPolicy Unrestricted
    Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions
    Enable-RemoteDesktop

    cinst console2
    cinst sublimetext3

    $sublimeDir = "$env:programfiles\Sublime Text 3"
    $sublimeUserDir = "$env:appdata\Sublime Text 3"
    Get-ChildItem $env:programdata\Chocolatey\lib\console* | % {$consoleDir = $_}

    Install-ChocolateyPinnedTaskBarItem "$consoleDir\tools\console2\console.exe"
    Install-ChocolateyPinnedTaskBarItem "$sublimeDir\sublime_text.exe"

    Install-ChocolateyFileAssociation ".txt" "$sublimeDir\sublime_text.exe"

    mkdir $sublimeUserDir -Force
    mkdir $env:appdata\console -Force
    
    copy-item (Join-Path "$(Get-PackageRoot($MyInvocation))\sublime text 3" '*') -Force -Recurse $sublimeUserDir
    copy-item (Join-Path "$(Get-PackageRoot($MyInvocation))" 'console.xml') -Force $env:appdata\console\console.xml
    
    Write-ChocolateySuccess 'wrocklight'
} catch {
  Write-ChocolateyFailure 'wrocklight' $($_.Exception.Message)
  throw
}