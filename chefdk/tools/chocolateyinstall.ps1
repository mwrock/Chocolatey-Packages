try {
  $name = 'chefdk'
  $version = '1.0.3'
  $url = "https://packages.chef.io/stable/windows/2012r2/chefdk-$version-1-x86.msi"

  $url64 = "https://packages.chef.io/stable/windows/2012r2/chefdk-$version-1-x86.msi"
  $installerType = 'MSI'
  $silentArgs = "/qn /quiet /norestart"
  $validExitCodes = @(0,3010)

  $MD5Checksum = ''
  Install-ChocolateyPackage "$name" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes -checksum $MD5Checksum -checksumtype 'md5'
} catch {
  Write-ChocolateyFailure $name $($_.Exception.Message)
  throw
}
