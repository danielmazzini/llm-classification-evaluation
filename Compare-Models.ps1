param(
    [Parameter(Mandatory = $true)][string[]]$Models,
    [string]$Endpoint = 'http://localhost:11434',
    [string]$OutputDirectory = 'reports'
)
$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null
$reports = @()
$failed = $false
for ($i = 0; $i -lt $Models.Count; $i++) {
    $path = Join-Path $OutputDirectory ("model-{0}.json" -f $i)
    if (Test-Path $path) { Remove-Item $path }
    dotnet run --project $PSScriptRoot -- --model $Models[$i] --endpoint $Endpoint --output $path
    if ($LASTEXITCODE -ne 0 -or !(Test-Path $path)) { Write-Warning "Execution failed: $($Models[$i])"; $failed = $true }
    if (Test-Path $path) { $reports += Get-Content -Raw $path | ConvertFrom-Json }
}
if ($reports.Count -ne $Models.Count -or @($reports.datasetSha256 | Select-Object -Unique).Count -ne 1 -or @($reports.instructionsSha256 | Select-Object -Unique).Count -ne 1) { $failed = $true; Write-Warning 'Comparison incomplete or incompatible.' }
$reports | Select-Object model, accuracy, macroF1, technicalErrors, durationMs | Format-Table
if ($failed) { exit 1 }
