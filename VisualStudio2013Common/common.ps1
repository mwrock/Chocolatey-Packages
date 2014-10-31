Function Initialize-VS-Settings ($vsArgs, $unattendFile)
{
	
	$result = @{ 
		"ProductKey" = ""
	}

	$MATCH_PATTERN = "/([a-zA-Z]+):([`"'])?([a-zA-Z0-9- _]+)([`"'])?"
	$PARAMATER_NAME_INDEX = 1
	$VALUE_INDEX = 3

	$productKey = ""

	#Test to see if anything was passed
	if($vsArgs -match $MATCH_PATTERN ){
	    
	    #Construct a hastable of paramaters sent
	    #Format is /Key:Value (optional quotes) - Value can have [a-zA-Z0-9- _]+

	    $vsArgValues = @{ }
	    $vsArgs | Select-String $MATCH_PATTERN -AllMatches  | % $_.matches | % { 
	        $vsArgValues.Add(
	            $_.Groups[$PARAMATER_NAME_INDEX].Value.Trim(),
	            $_.Groups[$VALUE_INDEX].Value.Trim()) 
	    }

	    #Initialize features unattended installation file
	    if($vsArgValues['Features']) {
	        $featuresToAdd = -split $vsArgValues['Features']
	        [xml]$adminXml=Get-Content $unattendFile

	        $featuresToAdd | % {
	            $feature=$_
	            $node=$adminXml.DocumentElement.SelectableItemCustomizations.ChildNodes | ? {$_.Id -eq "$feature"}
	            if($node -ne $null){
	                $node.Selected="yes"
	            }
	        }
	        $adminXml.Save($unattendFile)
	    }

	    #Return back the product key
	    if($vsArgValues['ProductKey']) {
	        $result["ProductKey"] = $vsArgValues['ProductKey']
	    };
	}

	New-Object PSObject -Property $result
}

Function Get-VS-Installer-Args ($productKey='') {
	$result = "/Passive /NoRestart /AdminFile $adminFile /Log $env:temp\vs.log"
	if($settings.ProductKey -ne "") {

	    $result = "{0} /ProductKey {1}" -f $result, $settings.ProductKey
	}

	$result
}