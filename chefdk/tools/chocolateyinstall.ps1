try {
    $name = 'chefdk'
    $version = '2.3.4'
    $url = "https://packages.chef.io/stable/windows/2012r2/chefdk-$version-1-x86.msi"
    $url64 = "https://packages.chef.io/stable/windows/2012r2/chefdk-$version-1-x64.msi"
    $installerType = 'MSI'
    $silentArgs = "/qn /quiet /norestart"
    $validExitCodes = @(0,3010)

    $SHA256Checksum = 'f8326529c16b7ade644dcaff76a74d425cd9c54f95c7ba4128d3525d836deb26'
    $SHA256Checksum64 = '7d784a45298e5c1e4ff206b73ba8544dff4e3218d7c24d5fb3cb0960fcc34322'
    Install-ChocolateyPackage "$name" "$installerType" "$silentArgs" "$url" "$url64" -validExitCodes $validExitCodes -checksum $SHA256Checksum -checksumtype 'sha256' -checksum64 $SHA256Checksum64 -checksumtype64 'sha256'
} catch {
    Write-ChocolateyFailure $name $($_.Exception.Message)
throw
}
