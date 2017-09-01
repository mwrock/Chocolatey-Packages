try {
    $name = 'chefdk'
    $version = '2.1.11'
    $url = "https://packages.chef.io/stable/windows/2012r2/chefdk-$version-1-x86.msi"

    $url64 = "https://packages.chef.io/stable/windows/2012r2/chefdk-$version-1-x86.msi"
    $installerType = 'MSI'
    $silentArgs = "/qn /quiet /norestart"
    $validExitCodes = @(0,3010)

    $SHA256Checksum = '9f805e9b6399d293209e27eaefe7b9ad0d36db3017e2cd419b27e41cb1d3092e'
    Install-ChocolateyPackage "$name" "$installerType" "$silentArgs" "$url" "$url64" -validExitCodes $validExitCodes -checksum $SHA256Checksum -checksumtype 'sha256'
} catch {
    Write-ChocolateyFailure $name $($_.Exception.Message)
throw
}
