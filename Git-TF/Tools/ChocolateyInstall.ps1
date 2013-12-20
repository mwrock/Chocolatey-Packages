try {
    $tools = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    Install-ChocolateyZipPackage 'Git-TF' 'http://download.microsoft.com/download/A/E/2/AE23B059-5727-445B-91CC-15B7A078A7F4/git-tf-2.0.3.20131219.zip' $tools
    $gitTfDir = (Get-Item $tools\git*)
    $path = [Environment]::GetEnvironmentVariable('Path', 'User')
    if($path) {
        $paths = ($path -split ';' | ?{ !($_.ToLower() -match "\\git-tf\.")}) -join ';'
        [Environment]::SetEnvironmentVariable('Path', $paths, 'User')
        write-host "set new path to $paths"
        $env:path = ($env:path -split ';' | ?{ !($_.ToLower() -match "\\git-tf\.")}) -join ';'
        write-host "set current path to $($env:path)"
    }
    Install-ChocolateyPath "$GitTfDir"
    Write-ChocolateySuccess 'Git-TF'
} catch {
  Write-ChocolateyFailure 'Git-TF' $($_.Exception.Message)
  throw
}