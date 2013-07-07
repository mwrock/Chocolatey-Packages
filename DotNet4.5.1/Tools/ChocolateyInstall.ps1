if(-not (test-path "hklm:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319\SKUs\.NETFramework,Version=v4.5.1")) {
Install-ChocolateyPackage 'dotnet451' 'exe' "/Passive /NoRestart /Log $env:temp\net451.log" 'http://go.microsoft.com/?linkid=9831985' -validExitCodes @(0,3010)
}
else {
     Write-Host "Microsoft .Net 4.5.1 Framework is already installed on your machine."
 } 
