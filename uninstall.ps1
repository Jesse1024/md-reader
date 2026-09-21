$ErrorActionPreference = 'Continue'

$dest = Join-Path $env:LOCALAPPDATA 'MDReader'
$desktop = [Environment]::GetFolderPath('Desktop')
$lnk = Join-Path $desktop 'MD Reader.lnk'

Write-Host '=============================================='
Write-Host '  MD Reader - uninstaller'
Write-Host '=============================================='
Write-Host ''

$removed = $false

if (Test-Path $lnk) {
  Remove-Item $lnk -Force
  Write-Host '[1/2] Removed desktop shortcut.'
  $removed = $true
} else {
  Write-Host '[1/2] No desktop shortcut found.'
}

if (Test-Path $dest) {
  Remove-Item $dest -Recurse -Force
  Write-Host '[2/2] Removed install folder.'
  $removed = $true
} else {
  Write-Host '[2/2] No install folder found.'
}

Write-Host ''
if ($removed) {
  Write-Host 'Uninstall complete.'
} else {
  Write-Host 'Nothing to remove (already clean).'
}
