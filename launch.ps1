$ErrorActionPreference = "Stop"
$RepoURL = "https://raw.githubusercontent.com/ganoipho6/Microsoft-Activation-Scripts/master/HLCOM_AIO_Final.cmd"
$TempPath = "$env:temp\HLCOM_AIO.cmd"

# --- Admin Check ---
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "==========================================================" -ForegroundColor Yellow
    Write-Host "   YEU CAU QUYEN ADMIN! DANG KHOI DONG LAI..." -ForegroundColor Yellow
    Write-Host "==========================================================" -ForegroundColor Yellow
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm https://raw.githubusercontent.com/ganoipho6/Microsoft-Activation-Scripts/master/launch.ps1 | iex`"" -Verb RunAs
    exit
}
# -------------------

try {
    Write-Host "Dang ket noi den may chu HLCOM..." -ForegroundColor Cyan
    # Download the CMD file
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $RepoURL -OutFile $TempPath -UseBasicParsing
    
    if (Test-Path $TempPath) {
        Write-Host "Tai xuong thanh cong! Dang xu ly..." -ForegroundColor Green
        
        # CRITICAL: Convert LF to CRLF (GitHub raw serves LF endings)
        $rawContent = [System.IO.File]::ReadAllText($TempPath)
        $crlfContent = $rawContent.Replace("`r`n", "`n").Replace("`n", "`r`n")
        
        # Ensure empty line at EOF
        if (-not $crlfContent.EndsWith("`r`n")) {
            $crlfContent += "`r`n"
        }
        
        [System.IO.File]::WriteAllText($TempPath, $crlfContent, [System.Text.Encoding]::ASCII)
        
        Write-Host "Dang khoi dong..." -ForegroundColor Green
        # Execute CMD script and wait for it to finish
        Start-Process cmd.exe -ArgumentList "/c `"$TempPath`"" -Wait
    } else {
        throw "Khong tim thay file sau khi tai."
    }
}
catch {
    Write-Error "Loi: Khong the tai xuong script. Vui long kiem tra ket noi internet."
    Write-Error $_.Exception.Message
}
finally {
    # Cleanup
    if (Test-Path $TempPath) {
        Remove-Item $TempPath -Force -ErrorAction SilentlyContinue
    }
}
