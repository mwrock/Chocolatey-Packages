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
Install-ChocolateyPackage 'VisualStudio2013Professional' 'exe' "/Passive /NoRestart /AdminFile $adminFile /Log $env:temp\vs.log" 'http://download.microsoft.com/download/A/F/1/AF128362-A6A8-4DB3-A39A-C348086472CC/vs_professional_download.exe'
