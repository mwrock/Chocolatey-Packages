$ieKey="HKLM:\Software\Microsoft\Internet Explorer"
if(Get-ItemProperty -Path $ieKey -Name "SvcUpdateVersion" -ErrorAction SilentlyContinue){
    $ieVersion=(Get-ItemProperty -Path $ieKey -Name "SvcUpdateVersion").svcUpdateVersion
    $hasIE10 = $ieVersion.StartsWith("10.")
}

if($hasIE10 -ne $true){
    Write-Host "Downloading and installing IE" -ForeGroundColor green
    Write-Host "This is required by Visual Studio 2013." -ForeGroundColor green
    write-Host "This install will likely require your computer to be restarted before finishing the Visual Studio Install." -ForeGroundColor green
    Write-Host "If this install results in an error due to a required reboot, rerun the visual studio install after you reboot." -ForeGroundColor green
    Write-Host "Be sure to use the Chocolatey -Force argument:" -ForeGroundColor green
    Write-Host "CINST VisualStudio2013Ultimate -Force" -ForeGroundColor green
    $urlToWin7_32bit = "http://download.microsoft.com/download/8/A/C/8AC7C482-BC74-492E-B978-7ED04900CEDE/IE10-Windows6.1-x86-en-us.exe"
    $urlToWin7_64bit = "http://download.microsoft.com/download/C/E/0/CE0AB8AE-E6B7-43F7-9290-F8EB0EA54FB5/IE10-Windows6.1-x64-en-us.exe"
    try{
        Install-ChocolateyPackage 'IE10' 'exe' '/Passive /NoRestart' "$urlToWin7_32bit" "$urlToWin7_64bit"
    }
    catch{
         $ex=$_
        if ($ex -ne $null -and ($ex -match "code was '(-?\d+)'")) {
            $errorCode=$matches[1]
            if($errorCode=3010){
                Write-Error "Installation of IE10 which is required for Visual Studio 2013 Requires a reboot. Reboot your computer and try to install Visual Studio 2013 again with the -Force argument."
            }
        }
    }
}

if($errorCode -eq $null){
    $adminFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'AdminDeployment.xml')
    Install-ChocolateyPackage 'VisualStudio2013Ultimate' 'exe' "/Passive /NoRestart /AdminFile $adminFile /Log $env:temp\vs.log" 'http://download.microsoft.com/download/1/C/1/1C18413B-83AA-4108-A9F9-CE63F2990126/vs_ultimate_download.exe'
}
