try {
    $name = 'chefdk'
    $version = '2.2.1'
    $url = "https://packages.chef.io/stable/windows/2012r2/chefdk-$version-1-x86.msi"

    $url64 = "https://packages.chef.io/stable/windows/2012r2/chefdk-$version-1-x86.msi"
    $installerType = 'MSI'
    $silentArgs = "/qn /quiet /norestart"
    $validExitCodes = @(0,3010)

    $SHA256Checksum = 'd8761b0def610e65fdfbe0530715da613c4a4dff33da4c86ce493d7fab1fc086'
    Install-ChocolateyPackage "$name" "$installerType" "$silentArgs" "$url" "$url64" -validExitCodes $validExitCodes -checksum $SHA256Checksum -checksumtype 'sha256'
} catch {
    Write-ChocolateyFailure $name $($_.Exception.Message)
throw
}
