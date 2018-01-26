if(-not (test-path "hklm:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5")) {
  $osString = wmic os get caption | Out-String
  if($osString.Contains("Server")) {
    if($osString.Contains("2008")) {
      Add-WindowsFeature -Name NET-Framework-Core
	}
	else {
	  Install-WindowsFeature -Name NET-Framework-Core
	}
  }
  else {
    $packageArgs = "/c DISM /Online /NoRestart /Enable-Feature /FeatureName:NetFx3"
    $statements = "cmd.exe $packageArgs"
    Start-ChocolateyProcessAsAdmin "$statements" -minimized -nosleep -validExitCodes @(0)
  }
}
else {
  Write-Host "Microsoft .Net 3.5 Framework is already installed on your machine."
}
