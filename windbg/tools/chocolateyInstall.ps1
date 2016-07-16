param(
    [string] $SymbolPath = "$env:SYSTEMROOT\Symbols"
)

$ErrorActionPreference = 'Stop';

$arguments = @{}

$packageParameters = $env:chocolateyPackageParameters

# Now parse the packageParameters using good old regular expression
if ($packageParameters) {
    $match_pattern = "\/(?<option>([a-zA-Z]+)):(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
    $option_name = 'option'
    $value_name = 'value'

    if ($packageParameters -match $match_pattern ){
        $results = $packageParameters | Select-String $match_pattern -AllMatches
        $results.matches | % {
        $arguments.Add(
            $_.Groups[$option_name].Value.Trim(),
            $_.Groups[$value_name].Value.Trim())
        }
    }
    else
    {
        Throw "Package Parameters were found but were invalid (REGEX Failure)"
    }

    if ($arguments.ContainsKey("SymbolPath")) {
        $SymbolPath = $arguments["SymbolPath"]
    }
} else {
    Write-Debug "No Package Parameters Passed in"
}

$tempFolder = "$env:temp\chocolatey\windbg"
mkdir $tempFolder -ErrorAction SilentlyContinue | Out-Null

$files = @{
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/SDK%20Debuggers-x86_en-us.msi" = "5485A0196019040933CA3D2AC191ADD8";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/72bda6e16f5c7a040361c1304b4b5b36.cab" = "B613D33E83BA7957A541190495298C8C";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/d55d1e003fbb00a12c63b8f618e452bf.cab" = "1F6FDBFF5003F0C51ACACB874E261CE6";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/2c1331a0f4ecc46dfa39f43a575305e0.cab" = "252400AA6C5D21200AAB26B7DDF9E922";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/fe80f1b6d4cf60c919f4b3a0cd2f4306.cab" = "95BCDD0525D60B776154CB3BA644D0F1";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/7cb1ba9318f4b586c6a3bdd541e7f3ad.cab" = "4FD5ACDDF5A847D871D1F649B9357D61";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/a74408a87a51829b89e5282e73974d74.cab" = "6C810D6810FDE05122B529783B0F4B7F";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/8eb01de6160e8924be8582861808a9b5.cab" = "3F081494D7DAB394EB4A2328C61A8933";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/3ca392fde3898c3be052ddcddd14bb5f.cab" = "07F868A5A376E25986013105273FD4BC";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/3960f55df7c8073f3997269e5e390abc.cab" = "81FE210D77A396179E9CD38429BD5A98";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/96e8f767221532c6446fd1b8dad53b60.cab" = "7FA3C9D094EB44F965C00D3881BC4826";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/1a822224523be67061edcc97f6c0e36a.cab" = "CCAEB708D0E9ED0C20E83EE231B5D17B";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/dcb0a55d6cacaa05ead299e1d3de3c6d.cab" = "4E11957C0FEC91452AD6E8F25EB6E42E";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/baa2d817ae180ba7e772f1543c3bbdea.cab" = "C5FF97BE7BF22E3285FCC8F056601571";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/79e9b68a34bc84ab465fe1b79b84a325.cab" = "18730B9DB7CA4DEA724A79A614AF0E10";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/e8bc712abeffd7c9711ee3f55d4aa99b.cab" = "A5CFE736004236FE8CE13534AA1F9267";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/e10f9740446a96314a1731aa7cb4286a.cab" = "4B6497BBEC3221B4F11CD9B7A310CD70";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/ab8c11616091812d6c7137e366ba1d8d.cab" = "C5A87344B6DFC0713319F55721014ACD";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/4de7a1422374f98369172705b05d4bf9.cab" = "2CFEEDD8D04072993CD69D0111C949CD";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/2c1817d3f3f33cd01376c5ec441cc636.cab" = "49357E854D13B49F6CC6857788EEE3E4";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/34ee98a7c9420178c55f176f75c3fe10.cab" = "20CDBAD7500CC6D7C62F48B4C6277090";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/412c1caad96b8fe5e8f7f6735585f297.cab" = "74AD6FE4798BE84E3DF5D30EEA4CF30F";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/ba5d20281a858248e59d96d75c014391.cab" = "7127A943A5073827B4F9A5420E817640";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/437e52bd67ebe977a8957439db5ecf75.cab" = "B1901462BB2A6ECFDE18FBB06D3D88BE";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/5f7ef4904f75bf6b3b9b0f8975ad1492.cab" = "0F4F0278231DC5D86B10D7D37B8FDB0F";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/b98a31e36735eb82b3b238c68f36fbbf.cab" = "8F9439AA9C6479C4DD3056022D280A31";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/4ac48dbdddbc8ce04721f519b9cf1698.cab" = "1CE023028A276A8EB770744C9CF94A6E";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/0253f7df0974f9d7169b410d812a5385.cab" = "A421FDCD0371EDDE135924577559C60C";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/114c321d61ae77816824fed67cd25704.cab" = "8F76087A96021DF5A78390FB118905E5";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/7178f554c01f912c749b622564106b02.cab" = "69183D31031FBEBAA771B4F34AFA608B";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/3a53dffe0b4548753bc34825894f19bf.cab" = "C3B6C376C865ACC0A72ECA763C5A281C";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/X86%20Debuggers%20And%20Tools-x86_en-us.msi" = "797B3CC82C95F2D82B7EEFEE83C735A4";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/X64%20Debuggers%20And%20Tools-x64_en-us.msi" = "28C0F31D28CB266F5589A23ABB463296";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/dotNetFx45_Full_x86_x64.exe" = "D02DC8B69A702A47C083278938C4D2F1";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/Kits%20Configuration%20Installer-x86_en-us.msi" = "8668B5B4DE5F343A59381F23C52E4324";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/Windows%20SDK%20EULA-x86_en-us.msi" = "70D38BE03DEA8DF81E98AABFD521B531";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/598442d9f84639d200d4f3af477da95c.cab" = "02B5F85874DCA60D890150CB0021C1B6";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/4e2dea081242e821596b58b31bc22cca.cab" = "9DADFA94AF72E145E9E751EAA09939BE";
  [uri] "http://download.microsoft.com/download/6/A/2/6A2ECE81-C934-4E47-91CC-52DA00A65345/Installers/931721e121ef91707ddcb6cac354d95c.cab" = "3BE4AEF745068B849EB480F12FD27496";
}

foreach ($file in $files.GetEnumerator()) {    
    Get-ChocolateyWebFile -PackageName "windbg" -url $file.Key.AbsoluteUri -Checksum $file.Value -checksumType MD5 -FileFullPath ([System.IO.Path]::Combine($tempFolder, [System.IO.Path]::GetFilename($file.Key.LocalPath)))
}

Install-ChocolateyInstallPackage "windbg" "msi" "/q" "$tempFolder\SDK Debuggers-x86_en-us.msi"

if(${env:ProgramFiles(x86)} -ne $null){ $programFiles86 = ${env:ProgramFiles(x86)} } else { $programFiles86 = $env:ProgramFiles }
$windbgPath = (Join-Path $programFiles86 "Windows Kits\10\Debuggers")

[Environment]::SetEnvironmentVariable( '_NT_SYMBOL_PATH', "symsrv*symsrv.dll*$SymbolPath*http://msdl.microsoft.com/download/symbols", 'User')
$env:_NT_SYMBOL_PATH = "symsrv*symsrv.dll*$SymbolPath*http://msdl.microsoft.com/download/symbols"

$fxDir = "$env:windir\Microsoft.NET\Framework"
if(Test-Path $fxDir) {
    $frameworksx86 = dir "$fxdir\v*" | ? { $_.psiscontainer -and $_.Name -match "v[0-9]" }
}

$statement = @"
    copy-item (join-path '$($frameworksx86[-1])' "sos.dll") '$windbgPath\x86';
    copy-item '$windbgPath\x86\windbg.exe' '$windbgPath\x86\windbgx86.exe';
    Install-ChocolateyDesktopLink '$windbgPath\x64\windbg.exe';
    Install-ChocolateyDesktopLink '$windbgPath\x86\windbgx86.exe';
"@
$fxDir = "${fxdir}64"
if(Test-Path $fxDir) {
    $frameworksx64 = dir "$fxdir\v*" | ? { $_.psiscontainer -and $_.Name -match "v[0-9]"}
    $statement += @"
    copy-item (join-path '$($frameworksx64[-1])' "sos.dll") '$windbgPath\x64';
"@
    }
    
Start-ChocolateyProcessAsAdmin "$statement" -minimized -nosleep
