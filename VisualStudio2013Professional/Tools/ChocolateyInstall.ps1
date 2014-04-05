$adminFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'AdminDeployment.xml')
$customArgs = $env:chocolateyInstallArguments
$env:chocolateyInstallArguments=""
$productKey = ""

$ARGUMENTS_DELIMITER = ';'
$FEATURES_INDEX = 0
$PRODUCT_KEY_INDEX = 1

if($customArgs.Length -gt 0){
    $featuresToAdd = ($customArgs -split $ARGUMENTS_DELIMITER)[$FEATURES_INDEX]
    $productKey = ($customArgs -split $ARGUMENTS_DELIMITER)[$PRODUCT_KEY_INDEX]

    $featuresToAdd = -split $featuresToAdd
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

$installerArgs = "/Passive /NoRestart /AdminFile $adminFile /Log $env:temp\vs.log"
if($productKey -ne "") {
    $installerArgs = "${installerArgs} /ProductKey ${productKey}"
}

Install-ChocolateyPackage 'VisualStudio2013Professional' 'exe' $installerArgs 'http://download.microsoft.com/download/A/F/1/AF128362-A6A8-4DB3-A39A-C348086472CC/vs_professional_download.exe'
