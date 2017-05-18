if(Test-Path "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\AzCopy") {
    Write-Host "Microsoft Azure Storage Tools is already installed."
    return
}
Install-ChocolateyPackage 'MicrosoftAzureStorageTools' 'msi' '/quiet /norestart' 'https://download.microsoft.com/download/B/4/A/B4A8422F-C564-4393-80DA-6865A8C4B32D/MicrosoftAzureStorageTools.msi' 'https://download.microsoft.com/download/B/4/A/B4A8422F-C564-4393-80DA-6865A8C4B32D/MicrosoftAzureStorageTools.msi'
