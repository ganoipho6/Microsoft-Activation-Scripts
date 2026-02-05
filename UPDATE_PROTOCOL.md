# UPDATE PROTOCOL - HLCOM AIO

Follow these steps when a new version of the upstream Microsoft-Activation-Scripts (MAS) is released to create the HLCOM version.

## Step 1: Sanitation
1. Open the new `MAS_AIO.cmd`.
2. Search for `activ%-%ated.win`.
3. Ensure all lines containing raw URLs are commented out using `@REM`.
4. Example fix:
   ```batch
   @REM activ%-%ated.win
   @REM mass%-%grave.dev
   ```

## Step 2: Inject Password Protection
1. Locate the `:skipQE` label in the script.
2. Go to the line right before `::  Run script with parameters in unattended mode`.
3. Paste the content of `.antigravity_metadata/snippets/password_block_stable.cmd`.
4. This ensures the logo and password prompt appear after Admin elevation.

## Step 3: Apply Localization (UI/UX)
1. Go to the `:MainMenu` section.
2. Use the **Localization Dictionary** in `MAINTENANCE_GUIDE.md` to find and replace menu strings.
3. **CRITICAL:** Use `[]` instead of `()` for any text in `echo` commands inside code blocks to prevent syntax errors.
4. Replace the original `dk_color3` calls for options 1, 2, and 3 with the Vietnamese versions found in `.antigravity_metadata/snippets/menu_vietnamese.cmd`.

## Step 4: Verification
1. Run the script.
2. **Test:** Verify the password prompt only appears ONCE.
3. **Test:** Type an incorrect password to verify the "Lock" logic works.
4. **Test:** Verify the Menu displays with correct colors and Vietnamese (unaccented) text.
5. **Debug:** If the window closes instantly, check the `debug.log` (if logging is enabled) or run from an existing CMD window to see the error.

## Step 5: Metadata Cleanup
Ensure any temporary `pass_script` or `debug.log` files are NOT bundled with the final release if you want a clean distribution.
