if($Boxstarter -and $Boxstarter.ContainsKey('ScriptToCall')) {
  Install-WindowsUpdate -AcceptEula
}
else {
  Write-Host 'Please install the Boxstarter.WindowsUpdate package via Boxstarter.'
  Write-Host 'This can be done by either:'
  Write-Host "1. Running 'http://boxstarter.org/package/Boxstarter.WindowsUpdate' from Internet Explorer"
  Write-Host "2. Using the Boxstarter.Chocolatey package and running 'Install-BoxstarterPackage -PackageName Boxstarter.WindowsUpdate -Credential (Get-Credential)'"
  Throw "Boxstarter.WindowsUpdate install not succesfull. See message above."
}
