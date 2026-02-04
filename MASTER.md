# MASTER.md - Project Rules for HLCOM Activation Scripts

## Core Principles
1.  **Output Format:** All generated script outputs (`.cmd`, `.ps1`) **MUST** use `CRLF` (Windows format) and `ANSI/ASCII` encoding.
2.  **Workflow:** Always prioritize fixing issues by updating the build system (`build_hlcom.ps1`). **Do NOT** perform manual edits on final output files (`HLCOM_AIO_Final.cmd`).
3.  **Anti-Tamper Mitigation:** Remove or neutralize original integrity/anti-tamper/LF-check code blocks from the upstream script to prevent false-positive errors caused by rebranding/modifications.

## Technical Standards
- **Branding:** HLCOM - BY Ganoipho6.
- **Language:** Vietnamese (No Accents/Khong Dau) for CMD interface.
- **Security:** Password protection using `toiyeuhailongcomputer` with secure input masking.
- **Deployment:** Maintain `launch.ps1` for one-click remote execution via GitHub RAW.
