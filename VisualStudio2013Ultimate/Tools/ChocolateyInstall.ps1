$adminFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'AdminDeployment.xml')
$customArgs = $env:chocolateyInstallArguments
$env:chocolateyInstallArguments=""

$MATCH_PATTERN = "/([a-zA-Z]+):([`"'])?([a-zA-Z- 0-9_]+)([`"'])?"
$PARAMATER_NAME_INDEX = 1
$VALUE_INDEX = 3

$productKey = ""

if($customArgs -match $MATCH_PATTERN ){
    
    write-debug "=====matches====="
    $customArgValues = @{ }
    $customArgs | Select-String $MATCH_PATTERN -AllMatches  | % matches | % { 
        $customArgValues.Add(
            $_.Groups[$PARAMATER_NAME_INDEX].Value.Trim(),
            $_.Groups[$VALUE_INDEX].Value.Trim()) 
    }

    if($customArgValues['Features']) {
        $featuresToAdd = -split $customArgValues['Features']
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

    if($customArgValues['ProductKey']) {
        $productKey = $customArgValues['ProductKey']
    };
}

$installerArgs = "/Passive /NoRestart /AdminFile $adminFile /Log $env:temp\vs.log"
if($productKey -ne "") {
    $installerArgs = "${installerArgs} /ProductKey ${productKey}"
}

Install-ChocolateyPackage 'VisualStudio2013Ultimate' 'exe' $installerArgs 'http://download.microsoft.com/download/C/F/B/CFBB5FF1-0B27-42E0-8141-E4D6DA0B8B13/vs_ultimate_download.exe'
