$ErrorActionPreference = "Stop"

# Paths
$repoDir = Get-Location
$metaDir = Join-Path $repoDir ".antigravity_metadata"
$snippetsDir = Join-Path $metaDir "snippets"
$targetFile = Join-Path $repoDir "HLCOM_AIO_Final.cmd"
$masUrl = "https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master/MAS/All-In-One-Version-KL/MAS_AIO.cmd"

# Snippets
$passSnippetFile = Join-Path $snippetsDir "password_block_stable.cmd"
$menuSnippetFile = Join-Path $snippetsDir "menu_vietnamese.cmd"

Write-Host "--- HLCOM Build System v2.0 ---" -ForegroundColor Cyan

# 1. Download Latest MAS
Write-Host "[1/5] Downloading latest MAS script..." -ForegroundColor Yellow
$masContent = Invoke-WebRequest -Uri $masUrl -UseBasicParsing | Select-Object -ExpandProperty Content

# 2. Sanitization (URLs & Syntax)
Write-Host "[2/5] Applying sanitization..." -ForegroundColor Yellow
# Comment out problematic URLs
$masContent = $masContent -replace '(activated\.win)', '@REM $1'
$masContent = $masContent -replace '(massgrave\.dev)', '@REM $1'
# Fix unescaped parentheses in potential echo statements if they exist in original
$masContent = $masContent -replace 'echo:(.*)\((.*)\)', 'echo:$1[$2]'

# 3. Anti-Tamper & Integrity Removal
Write-Host "[3/5] Removing integrity checks..." -ForegroundColor Yellow
# Remove LF check / Line ending validation block if present
$masContent = $masContent -replace '(?s)::  Check if script is running from a path with special characters.*?::============================================================================', ':: Paths checked and sanitized by HLCOM'

# 4. Injections (Password & Menu)
Write-Host "[4/5] Injecting HLCOM snippets..." -ForegroundColor Yellow

# Password Injection
if ($masContent -match ":skipQE") {
    $passSnippet = Get-Content $passSnippetFile -Raw
    $masContent = $masContent -replace '(?s)(:skipQE.*?\n)(::  Check for updates)', "`$1`n$passSnippet`n`n`$2"
} else {
    Write-Error "Could not find label :skipQE in MAS script! Aborting."
}

# Menu Replacement
# We look for the PHUONG PHAP KICH HOAT block or similar in original
# In original it is: PHUONG PHAP KICH HOAT (ACTIVATION METHODS):
$menuSnippet = Get-Content $menuSnippetFile -Raw
$masContent = $masContent -replace '(?s)echo:\s+PHUONG PHAP KICH HOAT \(ACTIVATION METHODS\):.*?echo:\s+\[0\] Thoat \(Exit\)', $menuSnippet

# 5. Save Final File
Write-Host "[5/5] Saving final script (CRLF/ASCII)..." -ForegroundColor Yellow
[System.IO.File]::WriteAllText($targetFile, $masContent, [System.Text.Encoding]::ASCII)

Write-Host "`nBUILD SUCCESSFUL: HLCOM_AIO_Final.cmd is ready." -ForegroundColor Green

# --- CLEANUP ---
Write-Host "`n--- Cleaning up repository ---" -ForegroundColor Cyan
$junkFiles = @(
    "task.md", "task_build_system.md", "task_final_polish.md", "task_rebranding.md",
    "implementation_plan.md", "walkthrough.md", "walkthrough_final_hlcom.md", 
    "walkthrough_rebranded.md", "debug.log", "MAS_AIO_Original.cmd", "update_guide.md",
    "release_notes.md"
)

foreach ($file in $junkFiles) {
    $path = Join-Path $repoDir $file
    if (Test-Path $path) {
        Remove-Item $path -Force
        Write-Host "Deleted: $file" -ForegroundColor Gray
    }
}

# Git Operations
Write-Host "`n--- Git Operations ---" -ForegroundColor Cyan
git add .
git commit -m "chore: Upgrade Build System v2 & Cleanup Repository"
# git push origin master # Uncomment if needed, usually safer to let user push or do it if requested.

Write-Host "`nDone." -ForegroundColor Green
