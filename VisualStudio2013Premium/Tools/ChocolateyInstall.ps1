$adminFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'AdminDeployment.xml')
$customArgs = $env:chocolateyInstallArguments
$env:chocolateyInstallArguments=""
if($customArgs.Length -gt 0){
    $featuresToAdd = -split $customArgs
    [xml]$adminXml=Get-Content $adminFile
    $featuresToAdd | % {
        $feature=$_
        $node=$adminXml.DocumentElement.SelectableItemCustomizations.ChildNodes | ? {$_.Id -eq "$feature"}
        if($node -ne $null){
            $node.Selected="yes"
        }
    }
    $adminXml.Save($adminFile)
}
Install-ChocolateyPackage 'VisualStudio2013Premium' 'exe' "/Passive /NoRestart /AdminFile $adminFile /Log  $env:temp\vs.log" 'http://download.microsoft.com/download/D/B/D/DBDEE6BB-AF28-4C76-A5F8-710F610615F7/vs_premium_download.exe'
 