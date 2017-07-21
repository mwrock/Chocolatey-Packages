try {
    $name = 'chefdk'
    $version = '2.0.28'
    $url = "https://packages.chef.io/stable/windows/2012r2/chefdk-$version-1-x86.msi"

    $url64 = "https://packages.chef.io/stable/windows/2012r2/chefdk-$version-1-x86.msi"
    $installerType = 'MSI'
    $silentArgs = "/qn /quiet /norestart"
    $validExitCodes = @(0,3010)

    $SHA256Checksum = '6967d43b14a358a5ee743f514b63d7e78cc9ca0789ce982577b31a759aecd3d0'
    Install-ChocolateyPackage "$name" "$installerType" "$silentArgs" "$url" "$url64" -validExitCodes $validExitCodes -checksum $SHA256Checksum -checksumtype 'sha256'
} catch {
    Write-ChocolateyFailure $name $($_.Exception.Message)
throw
}
