if(-not (test-path "hklm:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5")) {
    cinst netfx3 -source windowsfeatures
}
else {
     Write-Host "Microsoft .Net 3.5 Framework is already installed on your machine."
 } 
