try {
    $name = 'chefdk'
    $version = '2.5.3'
    $url = "https://packages.chef.io/stable/windows/2012r2/chefdk-$version-1-x86.msi"
    $url64 = "https://packages.chef.io/stable/windows/2012r2/chefdk-$version-1-x64.msi"
    $installerType = 'MSI'
    $silentArgs = "/qn /quiet /norestart"
    $validExitCodes = @(0,3010)

    $SHA256Checksum = '656fd16842972ccb3b76560dd952aa2fd3c430be85dd5a01f2e17f3cc3002635'
    $SHA256Checksum64 = '86d8b8408e317298e04a8a96ac45be7b4885973780280239d6abdc31081adf09'
    Install-ChocolateyPackage "$name" "$installerType" "$silentArgs" "$url" "$url64" -validExitCodes $validExitCodes -checksum $SHA256Checksum -checksumtype 'sha256' -checksum64 $SHA256Checksum64 -checksumtype64 'sha256'
} catch {
    Write-ChocolateyFailure $name $($_.Exception.Message)
throw
}
