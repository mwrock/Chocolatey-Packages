if(Test-Path "$env:ProgramFiles\Microsoft SDKs\Windows Azure\.NET SDK\v2.2") {
    Write-Host "Windows Azure Libraries for .net v2.2 is already installed."
    return
}
Install-ChocolateyPackage 'WindowsAzureLibsForNet' 'msi' '/quiet /norestart' 'http://download.microsoft.com/download/2/8/8/2886D7B8-3C4E-4372-8F86-474E06526299/WindowsAzureLibsForNet-x86.msi' 'http://download.microsoft.com/download/2/8/8/2886D7B8-3C4E-4372-8F86-474E06526299/WindowsAzureLibsForNet-x64.msi'