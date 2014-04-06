$adminFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'AdminDeployment.xml')
$customArgs = $env:chocolateyInstallArguments
$env:chocolateyInstallArguments=""
$extraArgs = @()
if($customArgs.Length -gt 0){
    $featuresToAdd = -split $customArgs
    [xml]$adminXml=Get-Content $adminFile
    $featuresToAdd | % {
        $feature=$_
        $node=$adminXml.DocumentElement.SelectableItemCustomizations.ChildNodes | ? {$_.Id -eq "$feature"}
        if($node -ne $null){
            $node.Selected="yes"
        }
        else {
            $extraArgs += $feature
        }
    }
    $adminXml.Save($adminFile)
}
if($extraArgs.Count -gt 0){
    $extraArgs = $extraArgs -join " "
}
else {
    $extraArgs=$null
}
Install-ChocolateyPackage 'VisualStudio2013Ultimate' 'exe' "/Passive /NoRestart /AdminFile $adminFile /Log $env:temp\vs.log $extraArgs" 'http://download.microsoft.com/download/C/F/B/CFBB5FF1-0B27-42E0-8141-E4D6DA0B8B13/vs_ultimate_download.exe'
