try {
    $drop = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    $exe = "$drop\NugetPackageExplorer.exe"
    Install-ChocolateyZipPackage 'NugetPackageExplorer' 'http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=npe&DownloadId=500666&FileTime=129938420921170000&Build=19692' $drop
    Install-ChocolateyDesktopLink $exe
    $testType = (cmd /c assoc ".nupkg")
    if($testType -ne $null) {
        $fileType=$testType.Split("=")[1]
    } 
    else {
        $fileType="Nuget.Package"
        Start-ChocolateyProcessAsAdmin "cmd /c assoc .nupkg=$fileType"
    }
    Start-ChocolateyProcessAsAdmin "cmd /c ftype $fileType=`"$exe`" %1"
    Write-ChocolateySuccess 'NuGet Package Explorer'
} catch {
    Write-ChocolateyFailure 'NuGet Package Explorer' $($_.Exception.Message)
    throw 
}