# Run setupsdk /log install.log
# Choose 'Download the Windows Software Development Kit for installation on a separate computer'
# On 'Select the features you want to install' only select 'Debugging Tools for Windows'
#
# Then update the download path to point to where the installer saved the files
param(
    $DownloadPath = "C:\Users\Administrator\Downloads\Windows Kits\10\StandaloneSDK\Installers"
)

$content = (Get-Content install.log)

"`$files = @{"
$content | Where-Object { $_ -match "download from: (?<url>.*)$" } | ForEach-Object {

    $file = [uri] $Matches['url']

    $unencodedFilename = [System.IO.Path]::GetFileName($file.OriginalString)

    $info = Get-FileHash -Path ([System.IO.Path]::Combine($DownloadPath, $unencodedFilename)) -Algorithm MD5

    "  [uri] `"$($file.AbsoluteUri)`" = `"$($info.Hash)`";"
}

"}"