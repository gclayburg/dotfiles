# Cursor Editor Keybindings Guide

Coming from IntelliJ IDEA Ultimate with Emacs keybindings, this guide aims to configure Cursor with similar functionality. The goal is to preserve familiar keybindings while addressing Cursor's default overrides.

## Goals

- Use Cursor with Emacs keybindings
- Maintain IntelliJ-like functionality (e.g., `ctrl+q` for quick documentation/hover)
- Fix problematic keymappings that Cursor introduces on top of VSCode and the Awesome Emacs keymap (e.g., `ctrl+k` is reserved for deleting text from the cursor to the end of the line (kill-line) )

## Configuration Location

To use these keybindings, just copy the download this [keybindings](https://raw.githubusercontent.com/gclayburg/dotfiles/refs/heads/master/keybindings.json) file from github and copy it to the cursor location.  On linux, this is in `~/.config/Cursor/User/keybindings.json`


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

| Keybinding | Action |
|------------|---------|
| `ctrl+.` | Navigate to definition |
| `ctrl+,` | Navigate back |
| `ctrl+/` | Navigate forward |
| `ctrl+c ctrl+c` | Comment line |
| `ctrl+q` | Show hover (similar to IntelliJ quick documentation) |
| `shift+F6` | Rename symbol |
| `ctrl+alt+l` | Format document (matches IntelliJ reformat) |
| `ctrl+alt+i` | Format line |
| `ctrl+alt+d` | Copy line down |
| `ctrl+alt+v` | Refactor menu |
| `alt+F12` | Toggle terminal |
| `alt+Home`      | Create new file in current directory as editor        |

### Cursor-Specific Actions

All Cursor actions are mapped under the `alt+k` chord to avoid conflicts with emacs:

| Keybinding                  | Action                                                             |
|-----------------------------|--------------------------------------------------------------------|
| `alt+k k`                   | Generate code (opens in-editor window) Cursor calls this Command K |
| `alt+k c` or `ctrl+i`       | Open 'Agent' in chat side window                                   |
| `alt+k l`                   | Open 'Ask' in chat side window                                     |
| `alt+k y`                   | Copy selection to 'Ask' chat side window                           |
| `alt+k c`                   | Copy selection to 'Agent' chat side window                         |

### Additional VSCode/IntelliJ Shortcuts

| Keybinding | Action |
|------------|---------|
| `alt+g n` | Go to next problem |
| `alt+g p` | Go to previous problem |
| `ctrl+alt+\` | Run test at cursor |

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
   
4. It seems a recent cursor update overrides the mapping of `ctrl+k` again.  Cursor wants to use it for aipopup.action.modal.generate.  We use `alt+k k` for this instead.  So we now have an explicit mapping to disable the cursor mapping of ctrl+k to aipopup.action.modal.generate.
5. Apparently, it is not possible to map the keyboard to navigate to the next reference to a keystroke like ctrl-alt-n and also map this same keystroke to find next search result.  This is possible in IntelliJ IDEA.  If you try to map it this way, it will work ONLY if you first clear prior references found before doing a search.  Very goofy.  So the workaround is to first hit ctrl-alt-m to clear any prior references search result before hitting ctrl-alt-n to find next search result.  crazy, but it sorta works I guess
6. 

## Update 2024-12-7
Cursor update trashes keyboard settings for emacs users. Emacs users use ctrl-k is for emacs kill line, and not a cursor action.
These keymaps have been updated to fix this

## Updates 2025-2-24
cursor 0.46 Changed the way the chat, composer,and agent works.  `alt+k l ` now maps to 'ask' and `alt+k c` maps to 'agent' in the chat window.  Apparently composer is not a thing anymore.

## Update 2025-3-2
Cursor version 0.46  rearranges composer keystrokes and again breaks keystrokes for emacs keymap users.
This version of cursor maps `ctrl+y`  to 'Cursor: Focus Chat Followup'. 

## Updates 2025-9-11
Cursor 1.6.6 update.  Cursor arbitrarily decides to map `ctrl+e` to 'Open Agent Window' and 'Open Editor Window'.  Of course, this breaks Emacs-MCX: Move End Of Line.  We now remap this action to `alt+k a`