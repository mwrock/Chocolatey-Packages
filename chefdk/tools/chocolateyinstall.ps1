try {
    $name = 'chefdk'
    $version = '2.0.26'
    $url = "https://packages.chef.io/stable/windows/2012r2/chefdk-$version-1-x86.msi"

    $url64 = "https://packages.chef.io/stable/windows/2012r2/chefdk-$version-1-x86.msi"
    $installerType = 'MSI'
    $silentArgs = "/qn /quiet /norestart"
    $validExitCodes = @(0,3010)

    $SHA256Checksum = 'd72cf4f86efc4b39be9c4e2ea677a414ccf7900b8f5a521711e706ed1737f31a'
    Install-ChocolateyPackage "$name" "$installerType" "$silentArgs" "$url" "$url64" -validExitCodes $validExitCodes -checksum $SHA256Checksum -checksumtype 'sha256'
} catch {
    Write-ChocolateyFailure $name $($_.Exception.Message)
throw
}
