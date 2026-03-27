# Toggle Vertical Tabs — Chrome Extension

Keyboard shortcut (`Ctrl+S`) to collapse/expand the **native vertical tab bar** of Google Chrome on macOS.

Chrome doesn't expose any extension API or built-in shortcut to toggle the vertical tab strip. This extension works around that limitation by using **Native Messaging** to call an **AppleScript** that clicks the native "Collapse Tabs" / "Expand Tabs" button via macOS Accessibility.

## How it works

```
Ctrl+S → Chrome Extension → Native Messaging → shell script → AppleScript → clicks "Collapse Tabs" button
```

1. The extension registers a keyboard shortcut via Chrome's `commands` API
2. On keypress, it sends a message to a local **native messaging host** (`com.tabbar.toggle`)
3. The host runs an AppleScript that navigates Chrome's accessibility tree and clicks the collapse/expand button
4. The button toggles between "Collapse Tabs" and "Expand Tabs" automatically

## Permissions

> **This extension requests only one permission and runs zero remote code.**

| Permission | Why | What it does |
|---|---|---|
| **`nativeMessaging`** | Required to communicate with the local shell script that performs the toggle | Allows the extension to send a JSON message to a pre-registered local process via stdio. **No network access, no tab data, no browsing history.** |

The native messaging host is a shell script that lives on your machine — you install it yourself and can read every line of it. It runs `osascript` (AppleScript) to click a button in Chrome's UI via macOS Accessibility.

### macOS Accessibility

The AppleScript uses **System Events** to interact with Chrome's UI. macOS requires explicit permission for this:

**System Settings > Privacy & Security > Accessibility** — add Google Chrome (or your terminal, if testing manually).

Without this permission the toggle silently fails.

## Requirements

- macOS (uses AppleScript + System Events)
- Google Chrome with vertical tabs enabled
- Node.js 18+ (build only)
- Accessibility permission for Chrome

## Enabling vertical tabs in Chrome

If you don't have vertical tabs yet:

1. Open `chrome://flags/#vertical-tabs`
2. Set the flag to **Enabled**
3. Restart Chrome
4. Right-click the tab bar and select **"Move Tabs To The Side"**

After that the vertical tab strip appears on the left side of the window with a collapse/expand button at the top.

## Install

### 1. Build the extension

```bash
npm install
npm run build
```

### 2. Load in Chrome

1. Open `chrome://extensions`
2. Enable **Developer mode** (toggle in the top right)
3. Click **Load unpacked** and select the `dist/` folder
4. Copy the **extension ID** shown under "Toggle Vertical Tabs"

### 3. Install the native messaging host

```bash
./host/install.sh <your-extension-id>
```

This creates a manifest at `~/Library/Application Support/Google/Chrome/NativeMessagingHosts/com.tabbar.toggle.json` pointing to the local `host/toggle-tabbar.sh` script.

### 4. Grant Accessibility permission

**System Settings > Privacy & Security > Accessibility** — make sure Google Chrome is listed and enabled.

### 5. Use it

Press `Ctrl+S` in any Chrome window to collapse or expand the vertical tab bar.

To change the shortcut: `chrome://extensions/shortcuts`.

## Scripts

| Command | Description |
|---|---|
| `npm run build` | Compile TypeScript + copy assets to `dist/` |
| `npm run watch` | Compile TypeScript in watch mode |
| `npm run typecheck` | Type-check without emitting |
| `npm run clean` | Remove `dist/` |

## Troubleshooting

**Nothing happens on Ctrl+S**
- Check `chrome://extensions/shortcuts` — make sure the shortcut is registered
- Open the extension's service worker console (click "Inspect views" in `chrome://extensions`) for errors
- Verify the native host is installed: `cat ~/Library/Application\ Support/Google/Chrome/NativeMessagingHosts/com.tabbar.toggle.json`

**"Access not allowed" or native messaging errors**
- Re-run `./host/install.sh <extension-id>` with the correct ID
- Make sure `host/toggle-tabbar.sh` is executable (`chmod +x host/toggle-tabbar.sh`)

**AppleScript does nothing**
- Grant Accessibility permission to Chrome in System Settings
- Test manually: `osascript host/toggle-tabbar.sh` won't work (it expects stdin), but you can test the AppleScript directly:
  ```bash
  osascript -e '
  tell application "System Events"
      tell process "Google Chrome"
          set base to group 1 of group 1 of group 1 of group 1 of window 1
          click button 1 of group 1 of UI element 3 of base
      end tell
  end tell'
  ```

**Shortcut conflicts with "Save Page"**
- Change the shortcut in `chrome://extensions/shortcuts` to something else (e.g., `Ctrl+Shift+S`)

## Limitations

- **macOS only** — relies on AppleScript and System Events
- **Chrome only** — the accessibility tree path is specific to Google Chrome
- The accessibility tree structure may change across Chrome versions — if the toggle breaks after a Chrome update, run `host/discover.sh` to re-map the UI elements

## License

MIT
