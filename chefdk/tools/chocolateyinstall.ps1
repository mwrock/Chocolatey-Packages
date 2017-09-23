try {
    $name = 'chefdk'
    $version = '2.3.1'
    $url = "https://packages.chef.io/stable/windows/2012r2/chefdk-$version-1-x86.msi"

    $url64 = "https://packages.chef.io/stable/windows/2012r2/chefdk-$version-1-x64.msi"
    $installerType = 'MSI'
    $silentArgs = "/qn /quiet /norestart"
    $validExitCodes = @(0,3010)

    $SHA256Checksum = '243413a3911408763e44f487ab7ed1d7570e9a2195af5443be5f3cf9b358bc44'
    $SHA256Checksum64 = 'f0a09d973eb23127f9bc38069d188186c2de3073c2dc6efcc6f95ea7ac0bf686'
    Install-ChocolateyPackage "$name" "$installerType" "$silentArgs" "$url" "$url64" -validExitCodes $validExitCodes -checksum $SHA256Checksum -checksumtype 'sha256' -checksum64 $SHA256Checksum64 -checksumtype64 'sha256'
} catch {
    Write-ChocolateyFailure $name $($_.Exception.Message)
throw
}
