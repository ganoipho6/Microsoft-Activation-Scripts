# MAINTENANCE GUIDE - HLCOM AIO SCRIPT

## 1. Architecture & Critical Logic

### Password Logic and Self-Elevation
One of the most critical fixes is the placement of the Password Check.
- **Problem:** If placed at the beginning, the user is prompted for a password twice. This happens because the script checks for Admin rights and re-launches itself if they are missing.
- **Solution:** The `:CheckPassword` block MUST be placed after the `:skipQE` label. This ensures the script has already finished its self-elevation process and is running as the final Administrator process before asking for credentials.

### Syntax Fixes for Stability
Upstream MAS script contains raw URLs inside blocks that might be misinterpreted by the CMD parser if not handled correctly.
- **URL Sanitization:** Always use `@REM` to comment out raw domains like `activated.win` or `massgrave.dev`. If left as plain text, CMD tries to execute them as commands, leading to "not recognized command" errors.
- **Parentheses in Echo:** Avoid using `()` inside `IF/ELSE` blocks for `echo` commands. Use `[]` instead (e.g., `[Nen dung]` instead of `(Nen dung)`). This prevents the parser from prematurely closing the block.

## 2. Localization Dictionary

When updating, replace the original English menu strings with these Vietnamese versions:

| English Key (Original) | Vietnamese Value (Modified) |
| :--- | :--- |
| `PHUONG PHAP KICH HOAT (ACTIVATION METHODS):` | `CAC PHUONG PHAP KICH HOAT BAN QUYEN:` |
| `HWID` / `Kich hoat Windows vinh vien` | `Windows Vinh Vien` / `Kich hoat Windows HWID` |
| `Ohook` / `Kich hoat Office vinh vien` | `Office Vinh Vien` / `Kich hoat Office Ohook` |
| `TSforge` / `Windows / Office / ESU` | `Kich Hoat Nang Cao` / `Windows / Office / ESU` |
| `Online KMS` / `180 ngay - Tu dong gia han` | `Kich Hoat Qua KMS` / `Gia han tu dong` |
| `Check Status` | `Kiem tra tinh trang Ban quyen hien tai` |
| `Change Windows Edition` | `Thay doi phien ban Windows [Pro, Enterprise...]` |
| `Change Office Edition` | `Thay doi phien ban Office [Retail, Volume...]` |
| `Troubleshoot` | `Cong cu Sua loi va Khac phuc su co` |
| `Extras` | `Cac cong cu va Tien ich mo rong khac` |
| `Help` | `Huong dan su dung va Tro giup` |
| `Exit` | `Thoat khoi ung dung` |

## 3. Anti-Tamper & Integrity
The upstream script might have integrity checks or signature verification.
- **Action:** Ensure any "@REM Integrity check removed by HLCOM" comments remain in place if you modify the code, as changing one character can break original checksums (if any are active).
- **Line Endings:** Always save the file with `CRLF` (Windows) line endings to ensure maximum compatibility with the legacy CMD parser.
