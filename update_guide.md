# HLCOM Auto-Patcher Update Guide

This guide explains how to update the `HLCOM_AIO_Final.cmd` script when the original upstream repository (Massgrave) releases a new version.

## Prerequisites
- Windows with PowerShell installed.
- Internet connection (to download the new version).

## Step-by-Step Update Process

### 1. Download Latest Original Script
Download the latest `MAS_AIO.cmd` from Massgrave and place it in the project root or `MAS\All-In-One-Version-KL\`.
*Note: Ensure the file name is `MAS_AIO.cmd`.*

### 2. Run the Patcher
Open PowerShell in this directory and run:

```powershell
.\build_hlcom.ps1 -InputFile "Path\To\New\MAS_AIO.cmd"
```

If the new file is in the default location (`MAS\All-In-One-Version-KL\MAS_AIO.cmd`), just run:

```powershell
.\build_hlcom.ps1
```

### 3. Verify Output
The script will generate a new file named: **`HLCOM_AIO_Final.cmd`**.

1. Right-click `HLCOM_AIO_Final.cmd` -> **Run as Administrator**.
2. Check for:
   - "HLCOM" Title Bar.
   - ASCII Banner.
   - Password Prompt (`toiyeuhailongcomputer`).
   - Vietnamese Menu Options.
3. If everything looks good, distribute this file.

## Troubleshooting
- **Encoding Errors**: The script forces ASCII output. If characters look weird, ensure the input file was not saved as UTF-16 BOM.
- **Pattern Mismatch**: If Massgrave changes their code significantly (e.g., renames "Activation Methods"), the patcher might miss replacements. In this case, edit `build_hlcom.ps1` and update the `$Translations` or regex patterns.
