# Cursor Editor Keybindings Guide

Coming from IntelliJ IDEA Ultimate with Emacs keybindings, this guide aims to configure Cursor with similar functionality. The goal is to preserve familiar keybindings while addressing Cursor's default overrides.

## Goals

- Use Cursor with Emacs keybindings
- Maintain IntelliJ-like functionality (e.g., `ctrl+q` for quick documentation/hover)
- Fix problematic keymappings that Cursor introduces on top of VSCode and the Awesome Emacs keymap (e.g., `ctrl+k` is reserved for deleting text from the cursor to the end of the line (kill-line) )

## Configuration Location

These keybindings are saved in [`~/.config/Cursor/User/keybindings.json`](https://raw.githubusercontent.com/gclayburg/dotfiles/refs/heads/master/keybindings.json)

## Keybinding Categories

### Window Management

| Keybinding | Action |
|------------|---------|
| `ctrl+x 8` | Split window horizontal (matches IntelliJ) |
| `ctrl+x 9` | Split window vertical (matches IntelliJ) |
| `ctrl+x ctrl+o` | Go to file (similar to IntelliJ view->recent files) |

### Search/Find

| Keybinding | Action |
|------------|---------|
| `ctrl+shift+alt+n` | Add selection to next find match (multi-cursor) |
| `ctrl+shift+alt+p` | Add selection to previous find match (multi-cursor) |
| `ctrl+alt+/` | Find references to symbol at cursor |
| `ctrl+alt+n` | Go to next search result in editor |
| `ctrl+alt+p` | Go to previous search result in editor |

### Selection

| Keybinding | Action                                                                                                                                                                                                                                                                                          |
|------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `ctrl+alt+w` | Expand selection                                                                                                                                                                                                                                                                                |
| `ctrl+alt+shift+w` | Shrink selection                                                                                                                                                                                                                                                                                |
| `ctrl+alt+e` | Expand line selection  Out of the box, VScode will map this to ctrl-p  It seems the Awesome Emacs Keymap hides this when it maps it to move cursor to previous line.  This action is closer to what IntelliJ does with ctrl+alt+w in some cases.  Apparently, there is no shrink line selection |
| `shift+alt+n` | Move line down    (vscode is very close to Intellij but Intellij is smarter about moving to code blocks that make sense)                                                                |
| `shift+alt+p` | Move line up                                                                                                                                                                                                                                                                                    |
| `alt+h` | Select previous tab                                                                                                                                                                                                                                                                             |
| `alt+l` | Select next tab                                                                                                                                                                                                                                                                                 |

### Code/Refactoring

| Keybinding      | Action                                                |
|-----------------|-------------------------------------------------------|
| `ctrl+.`        | Navigate to definition                                |
| `ctrl+,`        | Navigate back                                         |
| `ctrl+/`        | Navigate forward                                      |
| `ctrl+c ctrl+c` | Comment line                                          |
| `ctrl+q`        | Show hover (similar to IntelliJ quick documentation)  |
| `shift+F6`      | Rename symbol                                         |
| `ctrl+alt+l`    | Format document (matches IntelliJ reformat)           |
| `ctrl+alt+i`    | Format line                                           |
| `ctrl+alt+d`    | Copy line down                                        |
| `ctrl+alt+v`    | Refactor code selection (extract to interface/method) |
| `ctrl+alt+m`    | Refactor code selection (extract to interface/method) |
| `alt+F12`       | Toggle terminal                                       |
| `alt+Home`      | Create new file in current directory as editor        |


### Cursor-Specific Actions

All Cursor actions are mapped under the `alt+k` chord to avoid conflicts:

| Keybinding            | Action                                          |
|-----------------------|-------------------------------------------------|
| `alt+k k`             | Generate code (opens in-editor window)          |
| `alt+k c` or `ctrl+i` | Open cursor composer in side window  Now called 'Agent' |
| `alt+k m`             | Open cursor in side window  Now called 'Manual' |
| `alt+k l` | Open/new chat window   Now called 'Ask'                |

| `alt+k i` or `ctrl+shift+i` | Open cursor composer in big window                     |
| `alt+k alt+l` | Show chat history window                               |
| `alt+k y` | Copy selection to chat window                          |

### Additional VSCode/IntelliJ Shortcuts

| Keybinding | Action |
|------------|---------|
| `alt+g n` | Go to next problem |
| `alt+g p` | Go to previous problem |

### Java specific
| Keybinding | Action                                                                                                     |
|------------|------------------------------------------------------------------------------------------------------------|
| `ctrl+u`   | Java: Go to super implementation (yes, this overrides with Cursor Undo AND Emacs-MCX: Universal Argument*) |

*I don't use these commands from the keyboard, so I didn't bother trying to map these to something else


## Ubuntu Notes

To disable Ubuntu's emoji picker on `ctrl+.`, run:
```bash
gsettings set org.freedesktop.ibus.panel.emoji hotkey "[]"
```

## Known Issues

1. Emacs controls don't work in cursor composer:
   - Basic navigation (`ctrl+n`, `ctrl+p`, `ctrl+a`) fails
   - Forces use of arrow keys
   - `ctrl+a` uses Windows convention (select all)

2. Problematic bindings:
   - vscode/cursor has No action for navigate to next/prev method (`alt+n`,`alt+p`)
   - insert selection into chat doesn't recognize Emacs kill ring
   - `Tab` key will always be different between Cursor and IntelliJ.

3. Removed/hidden keybindings:
   - `alt+l` (Transform to lowercase) from Awesome Emacs keymap

Update 2024-12-7
Cursor update trashes keyboard settings for emacs users. Emacs users use ctrl-k is for emacs kill line, and not a cursor action.
These keymaps have been updated to fix this

Update 2025-3-2
Cursor version 0.46  rearranges composer keystrokes and again breaks keystrokes for emacs keymap users.
This version of cursor maps ctrl-y  to 'Cursor: Focus Chat Followup'.  Wait.  Does it?  why did it just start working after
I brought up the keyboard shortcuts settings and clicked on 'record keys'.  This does not make sense?

This interferes with the emacs standard where
ctrl-y maps to 'Yank'. 

