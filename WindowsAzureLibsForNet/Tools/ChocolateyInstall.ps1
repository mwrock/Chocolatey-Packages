if(Test-Path "$env:ProgramFiles\Microsoft SDKs\Azure\.NET SDK\v2.7") {
    Write-Host "Windows Azure Libraries for .net v2.7 is already installed."
    return
}
Install-ChocolateyPackage 'WindowsAzureLibsForNet' 'msi' '/quiet /norestart' 'https://download.microsoft.com/download/0/F/E/0FE64840-9806-4D3C-9C11-84B743162618/MicrosoftAzureLibsForNet-x86.msi' 'https://download.microsoft.com/download/0/F/E/0FE64840-9806-4D3C-9C11-84B743162618/MicrosoftAzureLibsForNet-x64.msi'