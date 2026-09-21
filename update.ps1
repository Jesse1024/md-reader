$ErrorActionPreference = 'Continue'

$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$index = Join-Path $dir 'index.html'
$repo = 'Jesse1024/md-reader'

if (-not (Test-Path $index)) {
  Write-Host 'index.html not found next to this script.'
  exit 1
}

# read local version from <meta name="app-version" content="...">
$content = Get-Content $index -Raw
$localVer = ''
if ($content -match 'app-version[^0-9]*([0-9][0-9.]*)') { $localVer = $Matches[1] }
if (-not $localVer) {
  Write-Host 'Cannot read local version from index.html.'
  exit 1
}

# fetch latest release tag from GitHub
try {
  $latest = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/releases/latest" -Headers @{ 'User-Agent' = 'md-reader-updater' } -TimeoutSec 25
} catch {
  Write-Host "Failed to reach GitHub: $($_.Exception.Message)"
  exit 1
}
$remoteVer = $latest.tag_name -replace '^v', ''

function IsNewer($a, $b) {
  $A = @(($a -replace '^v', '').Split('.'))
  $B = @(($b -replace '^v', '').Split('.'))
  for ($i = 0; $i -lt 3; $i++) {
    $ai = 0; if ($A.Count -gt $i) { $ai = [int]$A[$i] }
    $bi = 0; if ($B.Count -gt $i) { $bi = [int]$B[$i] }
    if ($ai -ne $bi) { return $ai -gt $bi }
  }
  return $false
}

Write-Host ''
Write-Host "Current: v$localVer    Latest: v$remoteVer"

if (-not (IsNewer $remoteVer $localVer)) {
  Write-Host 'Already up to date. Nothing to do.'
  exit 0
}

$url = "https://cdn.jsdelivr.net/gh/$repo@$($latest.tag_name)/index.html"
Write-Host "Downloading $url ..."
try {
  Invoke-WebRequest -Uri $url -OutFile $index -UseBasicParsing -TimeoutSec 60
} catch {
  Write-Host "Download failed: $($_.Exception.Message)"
  exit 1
}

Write-Host "Updated to v$remoteVer. Restart the reader to apply."
