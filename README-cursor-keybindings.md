# Cursor Editor Keybindings Guide

[Cursor](https://www.cursor.com) is a great IDE with AI capabilities.  During installation, there is an option to use Emacs keybindings.  These keybindings are great and makes editing files a breeze.  Cursor is based on vscode.  They added many AI features that have keyboard bindings.  Unfortunately, Cursor has decided to override standard keybindings that Emacs uses.  For example, Emacs has always used `ctrl+k` to kill to end of the line.  Cursor has decided that `ctrl+k` keystroke on linux must map to the AI feature they calling "Inline Edit" or  "Ctrl K" now.  Sometimes they refer to it as "Command K".  That is the keystroke used on MacOS for the same feature.  It really is a great feature.  I use it all the time.  However, assuming that all users now want to use the `ctrl+k` keystroke for this is just nonsense.  This is just the tip of the iceberg for Emacs users.  THere are many, many common keystrokes used by Emacs that the Cursor team has decided to override.  These keymaps presented here are an attempt to fix all these bugs that Cursor has introduced.  This was done by manually reviewing the conflicts and trying to find a workable solution.  We want to preserve the Emacs way of editing files.  It is not broken, there is no need to fix that.  We also want to have some usable keystroke to use to invoke all these great Cursor and/or vscode shortcuts.  What we needed was something that makes sense and plays nicely with others.

As a bonus, we also mapped several actions to more closely match how IntelliJ IDEA solves these issues.

## Goals

- Use Cursor with Emacs keybindings
- Maintain IntelliJ-like functionality (e.g., `ctrl+q` for quick documentation/hover)
- Fix problematic keymappings that Cursor introduces on top of VSCode and the Awesome Emacs keymap (e.g., `ctrl+k` is reserved for deleting text from the cursor to the end of the line (kill-line) )
- This is a living document.  The Cursor team has a history of overriding keystrokes with new versions coming out.

## Configuration Location

To use these keybindings, just copy the download this [keybindings](https://raw.githubusercontent.com/gclayburg/dotfiles/refs/heads/master/keybindings.json) file from github and copy it to the cursor location.  On linux, this is in `~/.config/Cursor/User/keybindings.json`


## Keybinding Categories

### Cursor-Specific Actions

All Cursor actions are mapped under the `alt+k` chord to avoid conflicts with emacs:

| Keybinding                  | Action                                                      | command                                    | when                                                                                                             |
|-----------------------------|-------------------------------------------------------------|--------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| `alt+k k`                   | Generate code (opens in-editor window) Cursor calls this Command K | cursorai.action.generateInTerminal         | terminalFocus && terminalHasBeenCreated \|\| terminalFocus && terminalProcessSupported                           |
|                             |                                                             | aipopup.action.modal.generate              | editorFocus && !composerBarIsVisible && !composerControlPanelIsVisible                                           |
| `alt+k c`                   | Open Chat in Agent Mode                                     | composer.startComposerPrompt               |                                                                                                                  |
|                             |                                                             | composerMode.agent                         |                                                                                                                  |
| `alt+k l`                   | Open Chat in Ask Mode                                       | workbench.action.chat.newChat              | chatIsEnabled && inChat                                                                                          |
|                             |                                                             | aichat.newchataction                       |                                                                                                                  |
|                             |                                                             | composerMode.chat                          |                                                                                                                  |
| `alt+k b`                   | Open Chat in Background Mode                                | composerMode.background                    |                                                                                                                  |
| `alt+k y`                   | Copy selection to 'Ask' chat side window                    | aichat.insertselectionintochat             |                                                                                                                  |
| `alt+k a`                   | Toggle between Agent and Editor windows (context-dependent) | cursor.composer.openAgentWindow            | cursor.appLayoutEnabled && cursor.appLayout != 'agent'                                                           |
|                             |                                                             | cursor.composer.openEditorWindow           | cursor.appLayoutEnabled && cursor.appLayout == 'agent'                                                           |

### Window Management

| Keybinding        | Action                                                      | command                                    | when                                                                                                             |
|-------------------|-------------------------------------------------------------|--------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| `ctrl+x 8`        | Split window horizontal (matches IntelliJ)                  | workbench.action.splitEditorDown           | !terminalFocus                                                                                                   |
| `ctrl+x 9`        | Split window vertical (matches IntelliJ)                    | workbench.action.splitEditorRight          | !terminalFocus                                                                                                   |
| `ctrl+x ctrl+o`   | Go to file (similar to IntelliJ view->recent files)         | workbench.action.quickOpen                 | !terminalFocus                                                                                                   |
| `alt+k o`         | View: Toggle Secondary Side Bar Visibility                  | workbench.action.toggleAuxiliaryBar        |                                                                                                                  |
| `alt+k i`         | View: Toggle Primary Side Bar Visibility                    | workbench.action.toggleSidebarVisibility   | config.emacs-mcx.useMetaPrefixAlt                                                                                |
| `alt+f11`         | View: Toggle Zen Mode                                       | workbench.action.toggleZenMode             | !isAuxiliaryWindowFocusedContext && !terminalFocus                                                               |
### Search/Find

| Keybinding           | Action                                                      | command                                    | when                                                                                                             |
|----------------------|-------------------------------------------------------------|--------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| `ctrl+shift+alt+n`   | Add selection to next find match (multi-cursor)             | emacs-mcx.addSelectionToNextFindMatch      | editorFocus && !config.emacs-mcx.useMetaPrefixMacCmd                                                             |
|                      |                                                             | emacs-mcx.addSelectionToNextFindMatch      | config.emacs-mcx.useMetaPrefixMacCmd && editorFocus                                                              |
| `ctrl+shift+alt+p`   | Add selection to previous find match (multi-cursor)         | emacs-mcx.addSelectionToPreviousFindMatch  | editorFocus && !config.emacs-mcx.useMetaPrefixMacCmd                                                             |
|                      |                                                             | emacs-mcx.addSelectionToPreviousFindMatch  | config.emacs-mcx.useMetaPrefixMacCmd && editorFocus                                                              |
| `ctrl+alt+/`         | Find references to symbol at cursor                         | references-view.findReferences             | editorHasReferenceProvider                                                                                       |
| `ctrl+alt+n`         | Go to next search result in editor                          | goToNextReference                          | inReferenceSearchEditor \|\| referenceSearchVisible                                                              |
|                      |                                                             | search.action.focusNextSearchResult        | hasSearchResult \|\| inSearchEditor                                                                              |
|                      |                                                             | list.focusAnyDown                          | listFocus && !inputFocus && !treestickyScrollFocused                                                             |
| `ctrl+alt+p`         | Go to previous search result in editor                      | search.action.focusPreviousSearchResult    | hasSearchResult \|\| inSearchEditor                                                                              |
|                      |                                                             | goToPreviousReference                      | inReferenceSearchEditor \|\| referenceSearchVisible                                                              |
|                      |                                                             | list.focusAnyUp                            | listFocus && !inputFocus && !treestickyScrollFocused                                                             |

### Selection

| Keybinding           | Action                                                                                                                      | command                                    | when                                                                                                             |
|----------------------|-----------------------------------------------------------------------------------------------------------------------------|--------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| `ctrl+alt+w`         | Expand selection                                                                                                            | editor.action.smartSelect.expand           | editorTextFocus                                                                                                  |
| `ctrl+alt+shift+w`   | Shrink selection                                                                                                            | editor.action.smartSelect.shrink           | editorTextFocus                                                                                                  |
| `ctrl+alt+e`         | Expand line selection. [^1]                                                                                                 | expandLineSelection                        | textInputFocus                                                                                                   |
| `shift+alt+n`        | Move line down [^2]                                                                                                         | editor.action.moveLinesDownAction          | editorTextFocus && !editorReadonly                                                                               |
| `shift+alt+p`        | Move line up                                                                                                                | editor.action.moveLinesUpAction            | editorTextFocus && !editorReadonly                                                                               |
| `alt+h`              | Select previous tab                                                                                                         | workbench.action.previousEditor            |                                                                                                                  |
| `alt+l`              | Select next tab                                                                                                             | workbench.action.nextEditor                |                                                                                                                  |

[^1]: Out of the box, VScode will map this to ctrl-p. It seems the Awesome Emacs Keymap hides this when it maps it to move cursor to previous line. This action is closer to what IntelliJ does with ctrl+alt+w in some cases. Apparently, there is no shrink line selection

[^2]: (vscode is very close to Intellij but Intellij is smarter about moving to code blocks that make sense) 

### Code/Refactoring

| Keybinding        | Action                                                      | command                                    | when                                                                                                             |
|-------------------|-------------------------------------------------------------|--------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| `ctrl+.`          | Navigate to definition                                      | editor.action.revealDefinition             | editorHasDefinitionProvider && editorTextFocus                                                                   |
| `ctrl+,`          | Navigate back                                               | workbench.action.navigateBack              | canNavigateBack                                                                                                  |
| `ctrl+/`          | Navigate forward                                            | workbench.action.navigateForward           | canNavigateForward                                                                                               |
| `ctrl+c ctrl+c`   | Comment line                                                | editor.action.commentLine                  | editorTextFocus && !editorReadonly                                                                               |
| `ctrl+q`          | Show hover (similar to IntelliJ quick documentation)        | editor.action.showHover                    | editorTextFocus                                                                                                  |
| `shift+F6`        | Rename symbol                                               | editor.action.rename                       | editorHasRenameProvider && editorTextFocus && !editorReadonly                                                    |
|                   |                                                             | debug.renameWatchExpression                | watchExpressionsFocused                                                                                          |
|                   |                                                             | renameFile                                 | filesExplorerFocus && foldersViewVisible && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus  |
| `ctrl+alt+l`      | Format document (matches IntelliJ reformat)                 | editor.action.formatDocument.none          | editorTextFocus && !editorHasDocumentFormattingProvider && !editorReadonly                                       |
|                   |                                                             | editor.action.formatDocument               | editorHasDocumentFormattingProvider && editorTextFocus && !editorReadonly && !inCompositeEditor                  |
| `ctrl+alt+i`      | Format selection                                            | editor.action.formatSelection              | editorHasDocumentSelectionFormattingProvider && editorTextFocus && !editorReadonly                               |
| `ctrl+alt+d`      | Copy line down                                              | editor.action.copyLinesDownAction          | editorTextFocus && !editorReadonly                                                                               |
| `ctrl+alt+v`      | Refactor menu                                               | editor.action.refactor                     | editorHasCodeActionsProvider && textInputFocus && !editorReadonly                                                |
| `alt+F12`         | Toggle terminal                                             | workbench.action.terminal.toggleTerminal   | terminal.active                                                                                                  |
| `alt+Home`        | Create new file in current directory as editor              | explorer.newFile                           |                                                                                                                  |

### Additional VSCode/IntelliJ Shortcuts

| Keybinding        | Action                      | command                                    | when                                                                                                             |
|-------------------|-----------------------------|--------------------------------------------|------------------------------------------------------------------------------------------------------------|
| `alt+enter`       | Quick Fix (show intentions/context actions, like IntelliJ) | editor.action.quickFix                     | editorHasCodeActionsProvider && textInputFocus && !editorReadonly                                                |
| `alt+g n`         | Go to next problem          | (default emacs-mcx binding)                |                                                                                                                  |
| `alt+g p`         | Go to previous problem      | (default emacs-mcx binding)                |                                                                                                                  |
| `ctrl+alt+\`      | Run test at cursor          | testing.runAtCursor                        | editorTextFocus                                                                                                  |

### Other keymaps modified

| Keybinding        | Action                                                      | command                                    | when                                                                                                             |
|-------------------|-------------------------------------------------------------|--------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| `ctrl+shift+alt+s` | Open Settings                                              | workbench.action.openSettings              |                                                                                                                  |
| `ctrl+s`          | Disable save (removed from default)                        | -workbench.action.files.save               |                                                                                                                  |
| `ctrl+alt+y`      | Format selection                                            | editor.action.formatSelection              | editorHasDocumentSelectionFormattingProvider && editorTextFocus && !editorReadonly                               |
| `ctrl+u`          | Navigate to super implementation (Java)                    | java.action.navigateToSuperImplementation  |                                                                                                                  |
| `ctrl+p`          | View previous commit (SCM) / Disable quick open            | scm.viewPreviousCommit                     | scmInputIsInFirstPosition && scmRepository && !suggestWidgetVisible                                              |
| `ctrl+a`          | Disable select all                                          | -editor.action.selectAll                   |                                                                                                                  |
| `ctrl+alt+m`      | Clear references / Refactor menu                           | references-view.clear                      |                                                                                                                  |
|                   |                                                             | editor.action.refactor                     | editorHasCodeActionsProvider && textInputFocus && !editorReadonly                                                |
| `ctrl+alt+h`      | Focus next search result                                    | search.action.focusNextSearchResult        | hasSearchResult \|\| inSearchEditor                                                                              |
| `ctrl+;`          | Disable comment line                                        | -editor.action.commentLine                 | editorTextFocus && !editorReadonly                                                                               |
| `tab`             | Disable emacs tab behavior                                  | -emacs-mcx.tabToTabStop                    | config.emacs-mcx.emacsLikeTab && editorTextFocus && !editorHoverFocused && !editorParameterHintsVisible && !editorReadonly && !editorTabCompletion && !editorTabMovesFocus && !inSnippetMode && !inlineSuggestionVisible && !suggestWidgetVisible |
| `ctrl+i`          | Disable emacs tab behavior / Disable tab                   | -emacs-mcx.tabToTabStop                    | config.emacs-mcx.emacsLikeTab && editorTextFocus && !editorHoverFocused && !editorParameterHintsVisible && !editorReadonly && !editorTabCompletion && !editorTabMovesFocus && !inSnippetMode && !inlineSuggestionVisible && !suggestWidgetVisible |
|                   |                                                             | -tab                                       | editorTextFocus && !editorReadonly && !editorTabMovesFocus                                                       |
| `ctrl+m ctrl+f`   | Disable format selection                                    | -editor.action.formatSelection             | editorHasDocumentSelectionFormattingProvider && editorTextFocus && !editorReadonly                               |
| `ctrl+shift+r`    | Disable refactor                                            | -editor.action.refactor                    | editorHasCodeActionsProvider && textInputFocus && !editorReadonly                                                |
| `ctrl+pageup`     | Disable previous editor                                     | -workbench.action.previousEditor           |                                                                                                                  |
| `ctrl+pagedown`   | Disable next editor                                         | -workbench.action.nextEditor               |                                                                                                                  |
| `f12`             | Disable reveal definition                                   | -editor.action.revealDefinition            | editorHasDefinitionProvider && editorTextFocus                                                                   |
| `f2`              | Disable rename file / Disable rename                       | -renameFile                                | filesExplorerFocus && foldersViewVisible && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus  |
|                   |                                                             | -editor.action.rename                      | editorHasRenameProvider && editorTextFocus && !editorReadonly                                                    |
| `ctrl+n`          | Disable new untitled file                                  | -workbench.action.files.newUntitledFile    |                                                                                                                  |
| `ctrl+alt+k`      | Cursor AI actions / Disable emacs kill                     | aipopup.action.modal.generate              | editorFocus && !composerBarIsVisible && !composerControlPanelIsVisible                                           |
|                   |                                                             | cursorai.action.generateInTerminal         | terminalFocus && terminalHasBeenCreated \|\| terminalFocus && terminalProcessSupported                           |
| `ctrl+k`          | Disable various Cursor actions                             | -aipopup.action.modal.generate             | editorFocus && !composerBarIsVisible && !composerControlPanelIsVisible                                           |
|                   |                                                             | -cursorai.action.generateInTerminal        | terminalFocus && terminalHasBeenCreated \|\| terminalFocus && terminalProcessSupported                           |
|                   |                                                             | -composer.startComposerPrompt              | composerIsEnabled                                                                                                |
|                   |                                                             | -aipopup.action.modal.generate             | editorFocus && !composerBarIsVisible                                                                             |
|                   |                                                             | -cursorai.action.generateInTerminal        | terminalFocus && terminalHasBeenCreated \|\| terminalFocus && terminalProcessSupported \|\| terminalHasBeenCreated && terminalPromptBarVisible \|\| terminalProcessSupported && terminalPromptBarVisible |
| `ctrl+l`          | Disable chat actions                                        | -workbench.action.chat.newChat             | chatIsEnabled && inChat                                                                                          |
|                   |                                                             | -aichat.newchataction                      |                                                                                                                  |
| `ctrl+e`          | Disable Cursor composer actions                            | -cursor.composer.openAgentWindow           | cursor.appLayoutEnabled && cursor.appLayout != 'agent'                                                           |
|                   |                                                             | -cursor.composer.openEditorWindow          | cursor.appLayoutEnabled && cursor.appLayout == 'agent'                                                           |


## Ubuntu Notes

To disable Ubuntu's emoji picker on `ctrl+.`, run:
```bash
gsettings set org.freedesktop.ibus.panel.emoji hotkey "[]"
```

## Todo

- open chat window 
--  cursor hover says ctrl-alt-b, but this action does something else with selecting.  we need an alt+k thingy for this
- ctrl+alt+shift+w maps 2 2 things. it should be just one.
- need keystroke for keyboard settings
- add 4 more keys

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

Removed old keybindings that no longer work in cursor:

| Keybinding                  | Action                                                      | Status                    |
|-----------------------------|-------------------------------------------------------------|---------------------------|
| `alt+k g`                   | Open chat window                                            | does not work, removed    |
| `alt+k m`                   | Switch to edit mode in composer                             | does not work, removed    |
| `alt+k n`                   | Open specific AI chat panel                                 | does not work, removed    |
