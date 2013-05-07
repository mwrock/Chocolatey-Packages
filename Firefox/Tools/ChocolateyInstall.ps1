$packageName = 'firefox'
$fileType = 'exe'
$version = '20.0'
$silentArgs = '-ms'
$language = (Get-Culture).Name # Get language and country code separated by hyphen
$url = "http://download.mozilla.org/?product=firefox-$version&os=win&lang=$language"

$req = [system.Net.WebRequest]::Create($url)
try {
$res = $req.GetResponse()
} catch [System.Net.WebException] {
$res = $_.Exception.Response
}
$statusCode = $res.StatusCode

if ($statusCode -eq "NotFound") {
    $language = "$language" -replace '-[a-z]{2}', ''
    $url = "http://download.mozilla.org/?product=firefox-$version&os=win&lang=$language"

    $req = [system.Net.WebRequest]::Create($url)
    try {
    $res = $req.GetResponse()
    } catch [System.Net.WebException] {
    $res = $_.Exception.Response
    }
    $statusCode = $res.StatusCode

    if ($statusCode -eq "NotFound") {
            $language = "en-US"
            $url = "http://download.mozilla.org/?product=firefox-$version&os=win&lang=$language"
        }
}

Install-ChocolateyPackage $packageName $fileType $silentArgs $url