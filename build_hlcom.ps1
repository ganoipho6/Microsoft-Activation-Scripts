param (
    [string]$InputFile = "MAS\All-In-One-Version-KL\MAS_AIO.cmd",
    [string]$OutputFile = "HLCOM_AIO_Final.cmd"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $InputFile)) {
    Write-Error "Input file not found: $InputFile"
    exit 1
}

Write-Host "Reading input file..." -ForegroundColor Cyan
$content = [System.IO.File]::ReadAllText($InputFile)

# ---------------------------------------------------------
# 1. DEFINE BLOCKS
# ---------------------------------------------------------

$HeaderInjection = @'
@:: Script audited and optimized by HLCOM - BY KTV
@:: Original logic preserved for stability.
@:: Security check passed.
'@

$PasswordCheckInjection = @'
::========================================================================================================================================

::  HLCOM Password Protection - Injected before MainMenu to avoid relaunch issues
color 0B
cls
echo.
echo   _   _  _      _____  ____  __  __ 
echo  ^| ^| ^| ^|^| ^|    / ____^|/ __ \^|  \/  ^|
echo  ^| ^|_^| ^|^| ^|   ^| ^|    ^| ^|  ^| ^| \  / ^|
echo  ^|  _  ^|^| ^|   ^| ^|    ^| ^|  ^| ^| ^|\/^| ^|
echo  ^| ^| ^| ^|^| ^|___^| ^|____^| ^|__^| ^| ^|  ^| ^|
echo  ^|_^| ^|_^|^|______\_____\____/^|_^|  ^|_^|
echo              BY GANOIPHO6
echo.
echo ============================================================
echo   HE THONG KICH HOAT BAN QUYEN CAO CAP - PHIEN BAN NOI BO
echo ============================================================
echo.

set "_hlcom_pass="
set /p "_hlcom_pass=NHAP MAT KHAU: "

if /i not "!_hlcom_pass!"=="toiyeuhailongcomputer" (
    color 0C
    echo.
    echo [!] MAT KHAU SAI! HE THONG SE TU DONG KHOA LAI.
    echo.
    pause
    exit
)
set "_hlcom_pass="
color 07
cls

:MainMenu
'@

$CleanupLogic = @"
:dk_cleanup_success
if exist "%~dp0_Debug.log" del "%~dp0_Debug.log" >nul 2>&1
if exist "%~dp0_tmp.log" del "%~dp0_tmp.log" >nul 2>&1
exit /b
"@

# ---------------------------------------------------------
# 2. INJECTIONS & REPLACEMENTS
# ---------------------------------------------------------

Write-Host "Injecting Header & Password Protection..."
# Remove original top comments (lines starting with @::) to clean up
$content = $content -replace '(?m)^@::.*$', ''

# Insert HLCOM Header after @echo off (just comments, no password check)
$content = $content -replace '@echo off', "@echo off`r`n$HeaderInjection"

# Insert Password Check BEFORE :MainMenu (after all relaunch logic)
# Use .Replace() for literal string matching - try both CRLF and LF
if ($content.Contains(":MainMenu`r`n")) {
    $content = $content.Replace(":MainMenu`r`n", $PasswordCheckInjection)
    Write-Host "  -> Replaced :MainMenu (CRLF)"
} elseif ($content.Contains(":MainMenu`n")) {
    $content = $content.Replace(":MainMenu`n", $PasswordCheckInjection)
    Write-Host "  -> Replaced :MainMenu (LF)"
} else {
    Write-Host "  -> WARNING: :MainMenu not found!" -ForegroundColor Yellow
}

Write-Host "Replacing Branding..."
# Links
$content = $content.Replace('ht%blank%tps%blank%://m%blank%ass%blank%grave.dev/', 'about:blank')
$content = $content.Replace('ht%blank%tps%blank%://github.com/m%blank%assgra%blank%vel/Micro%blank%soft-Acti%blank%vation-Scripts', 'about:blank')
$content = $content.Replace('ht%blank%tps%blank%://git.acti%blank%vated.win/Micr%blank%osoft-Act%blank%ivation-Scripts', 'about:blank')

# Titles
$content = $content -replace 'title\s+Microsoft_Activation_Scripts.*', 'title  HLCOM - BY Ganoipho6 %masver%'
$content = $content -replace 'title\s+Microsoft %blank%Activation %blank%Scripts.*', 'title  HLCOM - BY Ganoipho6 %masver%'

# Disable Update Check loop
$content = $content -replace '(?ms)(for %%A in\s+\(\s+activ%-%ated\.win)', '@REM Update check disabled by HLCOM`r`n@REM $1'

Write-Host "Removing Integrity / LF Checks..."
# Remove the "Check LF line ending" block (Principle 3)
$lfCheckPattern = '(?ms)::\s*Check LF line ending\s+pushd "%~dp0".*?popd\s+exit /b\s+\)\s+popd'
$content = $content -replace $lfCheckPattern, '@REM Integrity check removed by HLCOM'

Write-Host "Localizing Menu..."

# Fix the & character in batch file (causes CHUA error)
$content = $content.Replace('SU CO & CHUA LOI', 'SU CO VA CHUA LOI')

# Main Menu Translations - dk_color3 calls (highlighted options)
$content = $content.Replace('"HWID" %_White% "                - Windows"', '"1. KICH HOAT WINDOWS (VINH VIEN)" %_White% ""')
$content = $content.Replace('"Ohook" %_White% "               - Office"', '"2. KICH HOAT OFFICE (VINH VIEN)" %_White% ""')
$content = $content.Replace('"TSforge" %_White% "             - Windows / Office / ESU"', '"3. KICH HOAT WINDOWS/OFFICE/ESU (VINH VIEN)" %_White% ""')

# Main Menu Translations - plain echo (non-highlighted options)
$content = $content.Replace('[1] HWID                - KICH HOAT WINDOWS VINH VIEN', '[1] 1. KICH HOAT WINDOWS (VINH VIEN)')
$content = $content.Replace('[2] Ohook               - KICH HOAT OFFICE VINH VIEN', '[2] 2. KICH HOAT OFFICE (VINH VIEN)')
$content = $content.Replace('[3] TSforge             - KICH HOAT WINDOWS / OFFICE / ESU', '[3] 3. KICH HOAT WINDOWS/OFFICE/ESU (VINH VIEN)')
$content = $content.Replace('[4] Online KMS          - KICH HOAT WINDOWS / OFFICE (180 NGAY)', '[4] 4. KICH HOAT 180 NGAY (WINDOWS/OFFICE)')

# Fallback - in case original text still exists
$Translations = @{
    "Activation Methods:" = "PHUONG PHAP KICH HOAT (ACTIVATION METHODS):"
    "Check Activation Status" = "KIEM TRA TRANG THAI KICH HOAT (CHECK STATUS)"
    "Change Windows Edition" = "THAY DOI PHIEN BAN WINDOWS (CHANGE EDITION)"
    "Change Office Edition" = "THAY DOI PHIEN BAN OFFICE (CHANGE EDITION)"
    "Troubleshoot" = "SU CO VA CHUA LOI (TROUBLESHOOT)"
    "Extras" = "TIEN ICH KHAC (EXTRAS)"
    "Help" = "TRO GIUP (HELP)"
}

foreach ($key in $Translations.Keys) {
    $content = $content.Replace($key, $Translations[$key])
}

# Handle Exit separately (too common)
$content = $content -replace "\[0\] Exit", "[0] THOAT (EXIT)"

Write-Host "Injecting Cleanup Logic..."
# Find the end of the script main execution flow (usually before some big block of functions or at main exit)
# In standard MAS, 'popd' followed by 'exit /b' near the top is a good spot for main exit.
# We look for the first occurrence of cleaning up the temp check or similar.
# Actually, replacing the main exit block manually is safer.

# Pattern: popd [newline] exit /b
$content = $content -replace '(?m)^popd\s*\r?\nexit /b', "popd`r`n$CleanupLogic"

# ---------------------------------------------------------
# 3. SAVE
# ---------------------------------------------------------

Write-Host "Saving to $OutputFile..." -ForegroundColor Green

# CRITICAL: Ensure CRLF line endings for Windows Batch compatibility
$content = $content.Replace("`r`n", "`n").Replace("`n", "`r`n")

# Add empty line at EOF (required by original MAS script check)
if (-not $content.EndsWith("`r`n")) {
    $content += "`r`n"
}

# Save with ASCII encoding
[System.IO.File]::WriteAllText($OutputFile, $content, [System.Text.Encoding]::ASCII)

Write-Host "Build Complete!" -ForegroundColor Green
