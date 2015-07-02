function Get-CurrentUser {
  $identity  = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $parts = $identity.Name -split "\\"
  return @{Domain=$parts[0];Name=$parts[1]}
}

function Restart-Explorer {
  Write-Host "Restarting the Windows Explorer process..."
  $user = Get-CurrentUser
  $explorer = Get-Process -Name explorer -IncludeUserName -ErrorAction SilentlyContinue
  
  if($explorer -ne $null) { 
      $explorer | ? { $_.UserName -eq "$($user.Domain)\$($user.Name)"} | Stop-Process -Force
  }

  Start-Sleep 1

  if(!(Get-Process -Name explorer -ErrorAction SilentlyContinue)) {
      start-Process -FilePath explorer
  }
}

try {
  Write-Host "Disabling IE Enhanced Security Configuration (ESC)."
  $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
  $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
  if(Test-Path $AdminKey){    
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0    
  }
  if(Test-Path $UserKey) {    
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0    
  }

  Write-Host "Disabling Server Manager opening at logon."
  $Key = "HKLM:\SOFTWARE\Microsoft\ServerManager"
  if(Test-Path $Key){  
    Set-ItemProperty -Path $Key -Name "DoNotOpenServerManagerAtLogon" -Value 1
  }

  Write-Host "Adjusting win explorer options to display hiden files, folders and extensions."
  $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
  if(Test-Path -Path $Key) {  
    Set-ItemProperty $Key Hidden 1  
    Set-ItemProperty $Key HideFileExt 0  
    Set-ItemProperty $Key ShowSuperHidden 1
  }

  Restart-Explorer
  
  Write-ChocolateySuccess 'win-no-annoy'
} catch {
  Write-ChocolateyFailure 'win-no-annoy' $($_.Exception.Message)
  throw
}
