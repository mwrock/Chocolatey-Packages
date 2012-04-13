try {
    $drop = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    Install-ChocolateyZipPackage 'sysinternals' 'https://github.com/mwrock/Chocolatey-Packages/raw/master/NugetPackageExplorer/NpeLocalExecutable.zip' $drop
    $testType = (cmd /c assoc ".nupkg")
    if($testType.Contains("=")) {
        $fileType=$testType.Split("=")[1]
    } 
    else {
        $fileType="Nuget.Package"
        cmd /c assoc ".nupkg=$fileType"
    }
    cmd /c ftype $fileType=$drop\NugetPackageExplorer.exe %1
    Write-ChocolateySuccess 'NuGet Package Explorer'
} catch {
    Write-ChocolateyFailure 'NuGet Package Explorer' $($_.Exception.Message)
    throw 
}