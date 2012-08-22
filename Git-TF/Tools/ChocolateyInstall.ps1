try {
    $tools = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    Install-ChocolateyZipPackage 'Git-TF' 'http://download.microsoft.com/download/A/E/2/AE23B059-5727-445B-91CC-15B7A078A7F4/git-tf-1.0.0.20120809.zip' $tools
    $gitTfDir = (Get-Item $tools\git*)
    Install-ChocolateyPath "$GitTfDir"
    Write-ChocolateySuccess 'Git-TF'
} catch {
  Write-ChocolateyFailure 'Git-TF' $($_.Exception.Message)
  throw
}