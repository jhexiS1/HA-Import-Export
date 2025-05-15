param (
  [string]$mode,
  [string]$file,
  [string]$folder,
  [string]$url,
  [string]$token,
  [string]$targetUrl,
  [string]$targetToken
)

function Import-Workflow($wfFile, $targetUrl, $targetToken) {
  Write-Host "📤 Importing $wfFile"
  $body = Get-Content $wfFile -Raw
  $headers = @{
    "Authorization" = "ApiToken $targetToken"
    "Content-Type" = "application/json"
  }
  $uri = "$targetUrl/web/api/v2.1/hyperautomation/workflows/import"
  try {
    $resp = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body
    Write-Host "✅ Imported: $wfFile"
  } catch {
    Write-Host "❌ Failed: $wfFile"
    Write-Host $_.Exception.Message
  }
}

function Export-Workflows($srcUrl, $srcToken, $outFolder) {
  $headers = @{
    "Authorization" = "ApiToken $srcToken"
    "Content-Type" = "application/json"
  }
  $listResp = Invoke-RestMethod "$srcUrl/web/api/v2.1/hyperautomation/workflows" -Headers $headers
  $listResp.data | ForEach-Object {
    $wfId = $_.id
    $wfDetail = Invoke-RestMethod "$srcUrl/web/api/v2.1/hyperautomation/workflows/$wfId" -Headers $headers
    $wfName = $wfDetail.data.name -replace ' ', '_'
    $filePath = Join-Path $outFolder "$wfName.json"
    $wfDetail.data | ConvertTo-Json -Depth 10 | Out-File -Encoding UTF8 -FilePath $filePath
    Write-Host "✅ Exported: $filePath"
  }
}

if ($mode -eq "export") {
  Export-Workflows $url $token $folder
} elseif ($mode -eq "import") {
  if ($file) {
    Import-Workflow $file $url $token
  } elseif ($folder) {
    Get-ChildItem -Path $folder -Filter *.json | ForEach-Object {
      Import-Workflow $_.FullName $url $token
    }
  }
} elseif ($mode -eq "transfer") {
  $tempDir = "./tmp_export"
  New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
  Export-Workflows $url $token $tempDir
  Get-ChildItem -Path $tempDir -Filter *.json | ForEach-Object {
    Import-Workflow $_.FullName $targetUrl $targetToken
  }
}
