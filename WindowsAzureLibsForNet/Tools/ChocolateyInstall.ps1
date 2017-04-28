if(Test-Path "$env:ProgramFiles\Microsoft SDKs\Azure\.NET SDK\v2.9") {
    Write-Host "Windows Azure Libraries for .net v2.9 is already installed."
    return
}
Install-ChocolateyPackage 'WindowsAzureLibsForNet' 'msi' '/quiet /norestart' 'https://download.microsoft.com/download/B/4/A/B4A8422F-C564-4393-80DA-6865A8C4B32D/MicrosoftAzureLibsForNet-x86.msi' 'https://download.microsoft.com/download/B/4/A/B4A8422F-C564-4393-80DA-6865A8C4B32D/MicrosoftAzureLibsForNet-x64.msi'