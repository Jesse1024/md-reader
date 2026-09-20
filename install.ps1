$ErrorActionPreference = 'Continue'

$src = Split-Path -Parent $MyInvocation.MyCommand.Path
$dest = Join-Path $env:LOCALAPPDATA 'MDReader'
$desktop = [Environment]::GetFolderPath('Desktop')

# 定位浏览器：优先 Edge，其次 Chrome
$browser = $null
$browserName = ''
$candidates = @(
  @{ p = 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'; n = 'Edge' },
  @{ p = 'C:\Program Files\Microsoft\Edge\Application\msedge.exe';        n = 'Edge' },
  @{ p = 'C:\Program Files\Google\Chrome\Application\chrome.exe';        n = 'Chrome' },
  @{ p = 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe';  n = 'Chrome' }
)
foreach ($c in $candidates) {
  if (Test-Path $c.p) { $browser = $c.p; $browserName = $c.n; break }
}

if (-not $browser) {
  Write-Host ''
  Write-Host 'No supported browser found (Edge / Chrome).'
  Write-Host 'Please open index.html manually with any modern browser.'
  exit 1
}

Write-Host '=============================================='
Write-Host '  MD Reader - installer'
Write-Host '=============================================='
Write-Host ''
Write-Host "[1/3] Copying files to $dest ..."
New-Item -ItemType Directory -Force -Path $dest | Out-Null
Copy-Item (Join-Path $src 'index.html') (Join-Path $dest 'index.html') -Force
if (Test-Path (Join-Path $src 'icon.ico')) {
  Copy-Item (Join-Path $src 'icon.ico') (Join-Path $dest 'icon.ico') -Force
}

Write-Host "[2/3] Creating desktop shortcut (using $browserName) ..."
$url = 'file:///' + ((($dest -replace '\\','/') -replace ' ','%20')) + '/index.html'
$lnkPath = Join-Path $desktop 'MD Reader.lnk'
$ws = New-Object -ComObject WScript.Shell
$lnk = $ws.CreateShortcut($lnkPath)
$lnk.TargetPath = $browser
$lnk.Arguments = '--app="' + $url + '"'
$lnk.WorkingDirectory = $dest
if (Test-Path (Join-Path $dest 'icon.ico')) { $lnk.IconLocation = Join-Path $dest 'icon.ico' }
$lnk.Save()

Write-Host "[3/3] Done. A 'MD Reader' shortcut is now on your desktop."
Write-Host 'Double-click it to open the reader.'
