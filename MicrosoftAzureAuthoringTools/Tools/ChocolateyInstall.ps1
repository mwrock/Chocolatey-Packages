if(Test-Path "$env:ProgramFiles\Microsoft SDKs\Azure\.NET SDK\v2.9\bin\cspack.exe") {
    Write-Host "Microsoft Azure Authoring Tools is already installed."
    return
}
Install-ChocolateyPackage 'MicrosoftAzureAuthoringTools' 'msi' '/quiet /norestart' 'https://download.microsoft.com/download/B/4/A/B4A8422F-C564-4393-80DA-6865A8C4B32D/MicrosoftAzureAuthoringTools-x86.msi' 'https://download.microsoft.com/download/B/4/A/B4A8422F-C564-4393-80DA-6865A8C4B32D/MicrosoftAzureAuthoringTools-x64.msi'
