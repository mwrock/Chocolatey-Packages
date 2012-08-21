if(-not (test-path "hklm:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319\SKUs\.NETFramework,Version=v4.5")) {
Install-ChocolateyPackage 'dotnet45' 'exe' "/Passive /NoRestart /Log $env:temp\net45.log" 'http://go.microsoft.com/?linkid=9816306' -validExitCodes @(0,3010)
}
else {
     Write-Host "Microsoft .Net 4.5 Framework is already installed on your machine."
 } 
