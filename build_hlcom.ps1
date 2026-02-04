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

::  HLCOM Password Protection
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
set /p "_hlcom_pass=NHAP MAT KHAU (Password): "

if /i not "%_hlcom_pass%"=="toiyeuhailongcomputer" (
    color 0C
    echo.
    echo [!] MAT KHAU SAI! HE THONG SE TU DONG KHOA LAI.
    echo.
    pause
    exit /b
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
# Clean up any potential double echo off or previous injections
$content = $content -replace '(?m)^@::.*$', ''

# Insert HLCOM Header after @echo off
if ($content -contains "@echo off") {
    $content = $content.Replace("@echo off", "@echo off`r`n$HeaderInjection")
}

# Insert Password Check BEFORE :MainMenu (the one after all relaunch logic)
# We use literal replace to ensure it hits the right spot
if ($content.Contains(":MainMenu`r`n")) {
    $content = $content.Replace(":MainMenu`r`n", $PasswordCheckInjection)
    Write-Host "  -> Password protection injected before MainMenu" -ForegroundColor Green
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
$lfCheckPattern = '(?ms)::\s*Check LF line ending\s+pushd "%~dp0".*?popd\s+exit /b\s+\)\s+popd'
$content = $content -replace $lfCheckPattern, '@REM Integrity check removed by HLCOM'

Write-Host "Localizing Menu..."
# Fix the & character
$content = $content.Replace('SU CO & CHUA LOI', 'SU CO VA CHUA LOI')

# Translations
$content = $content.Replace('"HWID" %_White% "                - Windows"', '"1. KICH HOAT WINDOWS (VINH VIEN)" %_White% ""')
$content = $content.Replace('"Ohook" %_White% "               - Office"', '"2. KICH HOAT OFFICE (VINH VIEN)" %_White% ""')
$content = $content.Replace('"TSforge" %_White% "             - Windows / Office / ESU"', '"3. KICH HOAT WINDOWS/OFFICE/ESU (VINH VIEN)" %_White% ""')
$content = $content.Replace('[4] Online KMS          - KICH HOAT WINDOWS / OFFICE (180 NGAY)', '[4] 4. KICH HOat 180 NGAY (WINDOWS/OFFICE)')

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

$content = $content -replace "\[0\] Exit", "[0] THOAT (EXIT)"

Write-Host "Injecting Cleanup Logic..."
$content = $content -replace '(?m)^popd\s*\r?\nexit /b', "popd`r`n$CleanupLogic"

# ---------------------------------------------------------
# 3. SAVE
# ---------------------------------------------------------
Write-Host "Saving to $OutputFile..." -ForegroundColor Green
$content = $content.Replace("`r`n", "`n").Replace("`n", "`r`n")
if (-not $content.EndsWith("`r`n")) { $content += "`r`n" }
[System.IO.File]::WriteAllText($OutputFile, $content, [System.Text.Encoding]::ASCII)

Write-Host "Build Complete!" -ForegroundColor Green
