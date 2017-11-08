try {
    $name = 'chefdk'
    $version = '2.3.17'
    $url = "https://packages.chef.io/stable/windows/2012r2/chefdk-$version-1-x86.msi"
    $url64 = "https://packages.chef.io/stable/windows/2012r2/chefdk-$version-1-x64.msi"
    $installerType = 'MSI'
    $silentArgs = "/qn /quiet /norestart"
    $validExitCodes = @(0,3010)

    $SHA256Checksum = '303505fa88a4e5dfe232fb93381be575b8b5cc0c74469a409f9e797413abffed'
    $SHA256Checksum64 = 'e7f061260c313e4aeb6f0c0b91b45694ce95dc751ade29af3415153fb6de7179'
    Install-ChocolateyPackage "$name" "$installerType" "$silentArgs" "$url" "$url64" -validExitCodes $validExitCodes -checksum $SHA256Checksum -checksumtype 'sha256' -checksum64 $SHA256Checksum64 -checksumtype64 'sha256'
} catch {
    Write-ChocolateyFailure $name $($_.Exception.Message)
throw
}
