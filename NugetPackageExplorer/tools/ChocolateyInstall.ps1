try {

    Start-Process "http://npe.codeplex.com/releases/68211/clickOnce/NuGetPackageExplorer.application"
    Write-ChocolateySuccess 'NuGet Package Explorer'
} catch {
    Write-ChocolateyFailure 'NuGet Package Explorer' $($_.Exception.Message)
    throw 
}