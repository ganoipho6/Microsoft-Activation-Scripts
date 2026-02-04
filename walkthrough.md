# Walkthrough: Microsoft-Activation-Scripts (MAS) Workspace

Welcome to the MAS workspace. This document provides a map of the available tools and environment requirements.

## 📂 Repository Structure

### 1. All-In-One Version (Recommended)
- **Path**: `MAS\All-In-One-Version-KL\MAS_AIO.cmd`
- **Function**: A single script containing all activation methods (HWID, Ohook, TSforge, Online KMS) and troubleshooting tools.

### 2. Separate Files Version
Located in `MAS\Separate-Files-Version\`, these scripts are modular and easier to audit individually.

#### Activators (`MAS\Separate-Files-Version\Activators\`)
- `HWID_Activation.cmd`: Permanent Windows 10/11 activation (requires internet).
- `Ohook_Activation_AIO.cmd`: Permanent Office activation (Office 2016 and later).
- `TSforge_Activation.cmd`: Traditional/KMS-based activation for Windows/Office/ESU.
- `Online_KMS_Activation.cmd`: Online KMS activation (180 days renewal).

#### Utilities (`MAS\Separate-Files-Version\`)
- `Check_Activation_Status.cmd`: Displays current activation state.
- `Change_Windows_Edition.cmd`: Switches Windows editions (e.g., Home to Pro).
- `Change_Office_Edition.cmd`: Changes Office license type (e.g., Retail to VL).
- `Troubleshoot.cmd`: Fixes common activation and system errors.
- `Extract_OEM_Folder.cmd`: Creates `$OEM$` folders for pre-activated Windows installations.

## 🛠 Prerequisites & Dependencies

Before running any scripts, ensure the following environment conditions are met:

1.  **Administrator Privileges**: **CRITICAL**. Scripts must be run as Administrator to modify system licensing.
2.  **Internet Connection**: Required for **HWID** and **Online KMS** methods.
3.  **PowerShell**: Windows PowerShell 5.1 (standard on Win10/11) is fully supported.
4.  **System Protection**: The `sppsvc` (Software Protection) service must not be disabled.
5.  **Antivirus**: Some AVs may flag these scripts as "HackTool" or "Sonbokli". Static analysis shows no malicious logic, only licensing command executions.

## ⚠️ Safety & Path Handling
- This workspace is located in a OneDrive folder with spaces in the path.
- **Rule**: Always use double quotes around paths when using terminal commands to avoid extraction/execution errors.
- **Metadata**: Local execution logs and temporary files are stored in `.antigravity_metadata/` (ignored by Git).

## 🚀 Quick Execution (Dry Run Check)
To verify your environment without activating anything, run:
```powershell
# Check Admin status
([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Check Activation status (Safe)
& "MAS\Separate-Files-Version\Check_Activation_Status.cmd"
```
