if(-not (test-path "hklm:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5")) {
  $packageArgs = "/c DISM /Online /NoRestart /Enable-Feature /FeatureName:NetFx3ServerFeatures"
  $statements = "cmd.exe $packageArgs"
  Start-ChocolateyProcessAsAdmin "$statements" -minimized -nosleep -validExitCodes @(0, 1)

  $packageArgs = "/c DISM /Online /NoRestart /Enable-Feature /FeatureName:NetFx3"
  $statements = "cmd.exe $packageArgs"
  Start-ChocolateyProcessAsAdmin "$statements" -minimized -nosleep -validExitCodes @(0)
}
else {
     Write-Host "Microsoft .Net 3.5 Framework is already installed on your machine."
 } 
