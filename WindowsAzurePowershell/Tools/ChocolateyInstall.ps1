if(${env:ProgramFiles(x86)} -ne $null){ $programFiles86 = ${env:ProgramFiles(x86)} } else { $programFiles86 = $env:ProgramFiles }
$modulePath="$programFiles86\Microsoft SDKs\Windows Azure\PowerShell\Azure\Azure.psd1"
if(Test-Path $modulePath) {
    $a=IEX (Get-content $modulePath | Out-String)
    if($a.ModuleVersion -eq "0.7.2") {
        Write-Host "Windows Azure Powershell is already installed."
        return
    }
}

Install-ChocolateyPackage 'WindowsAzurePowershell' 'msi' '/quiet /norestart' 'http://az412849.vo.msecnd.net/downloads02/windowsazure-powershell.0.7.2.1.msi'