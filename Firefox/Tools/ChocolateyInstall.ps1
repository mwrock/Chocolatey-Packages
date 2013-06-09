$packageName = 'firefox'
$fileType = 'exe'
$version = '21.0'
$silentArgs = '-ms'
$language1 = (Get-Culture).Name # Get language and country code separated by hyphen
$language2 = "$language1" -replace '-[a-z]{2}', '' # Remove country code and hyphen
$language3 = "en-US" # Fallback language if others fail
$url1 = "http://download.mozilla.org/?product=firefox-$version&os=win&lang=$language1"
$url2 = "http://download.mozilla.org/?product=firefox-$version&os=win&lang=$language2"
$url3 = "http://download.mozilla.org/?product=firefox-$version&os=win&lang=$language3"


try {
    Install-ChocolateyPackage $packageName $fileType $silentArgs $url1
    Write-ChocolateySuccess "$packageName"
} catch {
    
    try {
        Install-ChocolateyPackage $packageName $fileType $silentArgs $url2
        Write-ChocolateySuccess "$packageName"
    } catch {
        
        try {
            Install-ChocolateyPackage $packageName $fileType $silentArgs $url3
            Write-ChocolateySuccess "$packageName"
        } catch {
            Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
            throw
        }
    }
}