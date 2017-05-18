if(Test-Path "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\Storage Emulator\AzureStorageEmulator.exe") {
    Write-Host "Microsoft Azure Storage Emulator v4.3 is already installed."
    return
}
Install-ChocolateyPackage 'MicrosoftAzureStorageEmulator' 'msi' '/quiet /norestart' 'https://download.microsoft.com/download/B/4/A/B4A8422F-C564-4393-80DA-6865A8C4B32D/MicrosoftAzureStorageEmulator.msi' 'https://download.microsoft.com/download/B/4/A/B4A8422F-C564-4393-80DA-6865A8C4B32D/MicrosoftAzureStorageEmulator.msi'
