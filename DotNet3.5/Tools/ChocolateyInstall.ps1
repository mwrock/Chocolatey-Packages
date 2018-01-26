$ErrorActionPreference = 'Stop'

# Capturing Package Parameters.
$UserArguments = @{}
if ($env:chocolateyPackageParameters) {
   $match_pattern = "\/(?<option>([a-zA-Z]+)):(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
   $option_name = 'option'
   $value_name = 'value'

   if ($env:chocolateyPackageParameters -match $match_pattern ){
      $results = $env:chocolateyPackageParameters | Select-String $match_pattern -AllMatches
      $results.matches | ForEach-Object {$UserArguments.Add(
                           $_.Groups[$option_name].Value.Trim(),
                           $_.Groups[$value_name].Value.Trim())
                        }
   } else { Throw 'Package Parameters were found but were invalid (REGEX Failure)' }
} else { Write-Debug 'No Package Parameters Passed in' }

$InstallArgs = ''
if ($UserArguments.ContainsKey('Source')) {
   if (test-path $UserArguments['Source']) {
      $InstallArgs = "/Source:$UserArguments['Source']"
   } else {
      Throw "The source path '$($UserArguments['Source'])' is not available."
   }
}

if(-not (test-path "hklm:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5")) {
  if((wmic os get caption | Out-String).Contains("Server")) {
      $packageArgs = "/c DISM /Online /NoRestart /Enable-Feature /FeatureName:NetFx3ServerFeatures"
      $statements = "cmd.exe $packageArgs $InstallArgs"
      Start-ChocolateyProcessAsAdmin "$statements" -minimized -nosleep -validExitCodes @(0, 1)
  }
  $packageArgs = "/c DISM /Online /NoRestart /Enable-Feature /FeatureName:NetFx3"
  $statements = "cmd.exe $packageArgs $InstallArgs"
  Start-ChocolateyProcessAsAdmin "$statements" -minimized -nosleep -validExitCodes @(0)
}
else {
     Write-Host "Microsoft .Net 3.5 Framework is already installed on your machine."
 } 
