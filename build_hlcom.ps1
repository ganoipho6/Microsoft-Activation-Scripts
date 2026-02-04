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

::  HLCOM Banner & Security Check
color 0B
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

:CheckPassword
:: Create Temp PowerShell Script
set "pass_script=%temp%\hlcom_pass_check.ps1"
echo $p = Read-Host -Prompt 'NHAP MAT KHAU' -AsSecureString; > "%pass_script%"
echo $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($p); >> "%pass_script%"
echo $plain=[System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR); >> "%pass_script%"
echo if ($plain -eq 'toiyeuhailongcomputer') { exit 0 } else { exit 1 } >> "%pass_script%"

:: Run Script
powershell -ExecutionPolicy Bypass -File "%pass_script%"
set "EXIT_CODE=%errorlevel%"

:: Cleanup Temp Script
del "%pass_script%" >nul 2>&1

:: Verify logic
if %EXIT_CODE% NEQ 0 (
    color 0C
    echo.
    echo [!] MAT KHAU SAI! HE THONG SE TU DONG KHOA LAI.
    echo.
    pause
    exit
)
color 07
cls
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

# Insert HLCOM Header after @echo off

# First, generic cleanup of previous HLCOM injections if they exist in the source (to avoid duplication and bugs)
# Matches from "::  HLCOM Banner" down to the "cls" that follows the password check.
$content = $content -replace '(?s)::\s+HLCOM Banner.*?cls\s*', ''

# Now inject the fresh, correct header
$content = $content -replace '@echo off', "@echo off`r`n$HeaderInjection"

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

Write-Host "Removing Integrity / LF Checks & Arch Re-launch..."
# Remove the "Check LF line ending" block (Principle 3)
$lfCheckPattern = '(?ms)::\s*Check LF line ending\s+pushd "%~dp0".*?popd\s+exit /b\s+\)\s+popd'
$content = $content -replace $lfCheckPattern, '@REM Integrity check removed by HLCOM'

# Disable architecture re-launching (Causes "flashing" issues when run from temp files)
$content = $content -replace '(?ms)^if exist %SystemRoot%\\Sysnative\\cmd\.exe.*?exit /b\s*\)', '@REM Arch re-launch disabled'
$content = $content -replace '(?ms)^if exist %SystemRoot%\\SysArm32\\cmd\.exe.*?exit /b\s*\)', '@REM ARM Arch re-launch disabled'

Write-Host "Localizing Menu..."
$Translations = @{
    "Activation Methods:" = "PHUONG PHAP KICH HOAT (ACTIVATION METHODS):"
    "HWID                - KICH HOAT WINDOWS VINH VIEN" = "1. Kich hoat Windows Ban quyen So (Vinh vien)"
    "Ohook               - KICH HOAT OFFICE VINH VIEN" = "2. Kich hoat Office (Vinh vien)"
    '"HWID" %_White% "                - Windows"' = '"1. Kich hoat Windows Ban quyen So (Vinh vien)" %_White% ""'
    '"Ohook" %_White% "               - Office"' = '"2. Kich hoat Office (Vinh vien)" %_White% ""'
    "TSforge             - Windows / Office / ESU" = "TSforge             - KICH HOAT WINDOWS / OFFICE / ESU"
    "Online KMS          - KICH HOAT WINDOWS / OFFICE (180 NGAY)" = "4. Kich hoat 180 ngay (Windows/Office)"
    "Check Activation Status" = "KIEM TRA TRANG THAI KICH HOAT (CHECK STATUS)"
    "Change Windows Edition" = "THAY DOI PHIEN BAN WINDOWS (CHANGE EDITION)"
    "Change Office Edition" = "THAY DOI PHIEN BAN OFFICE (CHANGE EDITION)"
    "SU CO & CHUA LOI (TROUBLESHOOT)" = "SU CO VA CHUA LOI (TROUBLESHOOT)"
    "Extras" = "TIEN ICH KHAC (EXTRAS)"
    "Help" = "TRO GIUP (HELP)"
    "Exit" = "THOAT (EXIT)"
}

foreach ($key in $Translations.Keys) {
    if ($key -eq "Exit") {
        # 'Exit' is too common, target menu specific
        $content = $content -replace "\[0\] Exit", "[0] THOAT (EXIT)"
    } else {
        $content = $content.Replace($key, $Translations[$key])
    }
}

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
