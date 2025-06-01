# run-mavlink_chacha.ps1
# ---------------------------------------------------------------
$nuXmvCmd = @"
reset
go
check_ctlspec
check_ltlspec
quit
"@

$tmp = "tmp_chacha.cmd"
$nuXmvCmd | Set-Content -Encoding ascii $tmp

$out = powershell -ExecutionPolicy Bypass -Command `
       "& nuxmv -source $tmp mavlink2_chacha.smv"

$verdicts = $out | Where-Object { $_ -like '-- specification*' }

$when = Get-Date -Format "yyyyMMdd_HHmm"
$log  = "nuxmv_chacha_${when}.txt"

$verdicts | Tee-Object -FilePath $log

Remove-Item $tmp
Write-Host "`nResults saved to $log"
