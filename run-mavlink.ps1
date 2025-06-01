# ---------------------------------------------------------------
# Run NuXmv, capture its entire output, keep only the lines that
# begin with "-- specification", and save them to a timestamped
# file nuxmv_output_YYYYMMDD_HHmm.txt
# ---------------------------------------------------------------

# 1) NuXmv instruction script (no comments inside the here-string)
$nuXmvCmd = @"
reset
go
check_ctlspec
check_ltlspec
quit
"@

$cmdFile = "tmp_nuxmv.cmd"
$nuXmvCmd | Set-Content -Encoding ascii $cmdFile

# 2) Run NuXmv and capture ALL output in a variable
$nuXmvOut = powershell -ExecutionPolicy Bypass -Command `
            "& nuxmv -source $cmdFile mavlink2.smv"

# 3) Keep only the property verdict lines
$specLines = $nuXmvOut | Where-Object { $_ -like '-- specification*' }

# 4) Build timestamped log file name
$timestamp = Get-Date -Format "yyyyMMdd_HHmm"
$logFile   = "nuxmv_output_${timestamp}.txt"

# 5) Save and echo
$specLines | Tee-Object -FilePath $logFile

# 6) Clean up
Remove-Item $cmdFile

Write-Host "`nNuXmv property results saved to $logFile"
