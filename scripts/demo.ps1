<#
.SYNOPSIS
  Trigger demo pipeline runs for the DirectedByMultiBay factory.
.EXAMPLE
  ./scripts/demo.ps1 success
  ./scripts/demo.ps1 fail-test -Delay 12
  ./scripts/demo.ps1 tour
#>
param(
  [ValidateSet('success', 'fail-lint', 'fail-build', 'fail-test', 'matrix', 'cancel', 'release', 'tour')]
  [string]$Scenario = 'success',
  [int]$Delay = 8,
  [string]$Repo = 'christo-albuquerque/multibay-testlot'
)

function Start-Demo([string]$failAt = 'none', [bool]$matrix = $false, [bool]$cancel = $false) {
  gh workflow run controllable.yml -R $Repo -f "fail_at=$failAt" -f "delay_seconds=$Delay" -f "matrix=$($matrix.ToString().ToLower())" -f "cancel_me=$($cancel.ToString().ToLower())"
  Write-Host "Triggered: fail_at=$failAt matrix=$matrix cancel=$cancel"
}

switch ($Scenario) {
  'success'    { Start-Demo }
  'fail-lint'  { Start-Demo -failAt lint }
  'fail-build' { Start-Demo -failAt build }
  'fail-test'  { Start-Demo -failAt test }
  'matrix'     { Start-Demo -matrix $true }
  'cancel'     { Start-Demo -cancel $true }
  'release'    { gh workflow run release.yml -R $Repo; Write-Host 'Triggered: a real release (creates a tag and GitHub Release)' }
  'tour' {
    # Idle -> success -> three failures in a row (storm clouds) -> matrix -> cancel -> a clean finish.
    Start-Demo
    Start-Sleep 45; Start-Demo -failAt build
    Start-Sleep 30; Start-Demo -failAt test
    Start-Sleep 30; Start-Demo -failAt lint
    Start-Sleep 30; Start-Demo -matrix $true
    Start-Sleep 60; Start-Demo -cancel $true
    Start-Sleep 60; Start-Demo
  }
}

Write-Host "Watch it at https://christo-albuquerque.github.io/directed-by-multibay/"
