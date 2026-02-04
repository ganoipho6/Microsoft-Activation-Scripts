# Task: Create HLCOM Auto-Patcher System

## Status
- [x] Phase 1: Planning <!-- id: 0 -->
    - [x] Create `task_build_system.md` <!-- id: 1 -->
    - [x] Extract content blocks (Banner, Password, Translations) <!-- id: 2 -->
- [x] Phase 2: Scripting <!-- id: 3 -->
    - [x] Create `build_hlcom.ps1` (Core Patcher) <!-- id: 4 -->
    - [x] Create `update_guide.md` <!-- id: 5 -->
- [x] Phase 3: Verification <!-- id: 6 -->
    - [x] Run patcher against original backup <!-- id: 7 -->
    - [x] Verify `HLCOM_AIO_Final.cmd` integrity <!-- id: 8 -->

## Patcher Requirements
1. **Input**: Original `MAS_AIO.cmd` (from Massgrave).
2. **Operations**:
    - Inject ASCII Banner & Password Check.
    - Replace Branding (Links, Titles, Authors).
    - Localize Menu (Vietnamese).
    - Insert Cleanup Logic.
3. **Output**: `HLCOM_AIO_Final.cmd`.
