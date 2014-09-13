$version = '0.8.8'

if(!(Test-Path "HKLM:\Software\Microsoft\PowerShell\3")){
    Write-Host "Windows Azure Powershell requires Powershell version 3 or greater."
    return
}

if(${env:ProgramFiles(x86)} -ne $null){ $programFiles86 = ${env:ProgramFiles(x86)} } else { $programFiles86 = $env:ProgramFiles }
$modulePath="$programFiles86\Microsoft SDKs\Windows Azure\PowerShell\Azure\Azure.psd1"
if(Test-Path $modulePath) {
    $a=IEX (Get-content $modulePath | Out-String)
    if($a.ModuleVersion -eq $version) {
        Write-Host "Windows Azure Powershell is already installed."
        return
    }
}

Install-ChocolateyPackage 'WindowsAzurePowershell' 'msi' '/quiet /norestart' "http://az412849.vo.msecnd.net/downloads03/azure-powershell.0.8.8.msi"
