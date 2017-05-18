if(Test-Path "$env:ProgramFiles\Microsoft SDKs\Azure\Emulator\DFUI.exe") {
    Write-Host "Microsoft Azure Compute Emulator is already installed."
    return
}
Install-ChocolateyPackage 'MicrosoftAzureComputeEmulator' 'exe' '/quiet /norestart' 'https://download.microsoft.com/download/B/4/A/B4A8422F-C564-4393-80DA-6865A8C4B32D/MicrosoftAzureComputeEmulator-x86.exe' 'https://download.microsoft.com/download/B/4/A/B4A8422F-C564-4393-80DA-6865A8C4B32D/MicrosoftAzureComputeEmulator-x64.exe'
