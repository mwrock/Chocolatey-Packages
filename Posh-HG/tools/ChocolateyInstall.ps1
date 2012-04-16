try {
    $tools = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

    Install-ChocolateyZipPackage 'posh-hg' 'https://github.com/JeremySkinner/posh-hg/zipball/1.1' $tools

    & $tools/install.ps1

    Write-ChocolateySuccess 'posh-hg'
} catch {
  Write-ChocolateyFailure 'posh-hg' $($_.Exception.Message)
  throw
}
