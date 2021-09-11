#!/bin/bash

source ~/.dotfiles/.exported


check_directory() {
center "User: $(whoami)  |  Directory: $(pwd)" "$YELLOW" "$RED"

### Move directory to home directory if current directory doesn't end with username.
if [[ "$(pwd)" != "$HOME" ]]
then
    cd ~;
    center "Moved to $(pwd)" "$RED" "$RED"
fi
}

setup_terminal() {
center "Setting up windows terminal" "$MAGENTA" "$MAGENTA"

center "Terminal: Installing Windows Terminal" "$MAGENTA" "$MAGENTA"
# ## Install Windows Terminal
 choco install microsoft-windows-terminal -y

# center "Terminal: Symlinking Windows Terminal Settings" "$MAGENTA" "$MAGENTA"
# # ## Add a symlink for Windows Terminal settings.
#     TermianlFiles=$(ls "$LOCALAPPDATA/Packages" | grep "^Microsoft\.WindowsTerminal")
#  if [ -d "$LOCALAPPDATA/Packages" ]; then
# for f in $TermianlFiles
# do
#     if [ -d "$LOCALAPPDATA/Packages/$f/LocalState"]
#         ln -sf ~/.dotfiles/windows-terminal-settings.jsonc $LOCALAPPDATA/Packages/$f/LocalState/settings.json
#     fi
# done
}


### Pin apps to taskbar and unpin edge. (Not sure how to unpin Windows Apps Store)
pin_to_taskbar(){
    center "Pinning Applications to taskbar" "$MAGENTA"
    center "Pinning Spotify" "$MAGENTA"
    powershell.exe -noprofile -executionpolicy bypass -file ~/.dotfiles/PinToTaskBar.ps1 "$APPDATA\Spotify\Spotify.exe" PIN
    center "Pinning Chrome" "$MAGENTA"
    powershell.exe -noprofile -executionpolicy bypass -file ~/.dotfiles/PinToTaskBar.ps1 "C:\Program Files\Google\Chrome\Application\chrome.exe" PIN
    center "Pinning VSCode" "$MAGENTA"
    if [ -f "$LOCALAPPDATA/Programs/Microsoft VS Code/Code.exe" ]; then
    powershell.exe -noprofile -executionpolicy bypass -file ~/.dotfiles/PinToTaskBar.ps1 "$LOCALAPPDATA/Programs/Microsoft VS Code/Code.exe" PIN
    else
    powershell.exe -noprofile -executionpolicy bypass -file ~/.dotfiles/PinToTaskBar.ps1 "C:\Program Files\Microsoft VS Code\Code.exe" PIN
    fi
    if [ -d "C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_8wekyb3d8bbwe" ]; then
     center "Pinning Windows Terminal" "$MAGENTA"
     powershell.exe -noprofile -executionpolicy bypass -file ~/.dotfiles/PinToTaskBar.ps1 "C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_8wekyb3d8bbwe\wt.exe" PIN
    elif [ -d "C:\Program Files\WindowsApps\Microsoft.WindowsTerminalPreview_1.9.1445.0_x64__8wekyb3d8bbwe" ]; then
     center "Pinning Windows Terminal Preview" "$MAGENTA"
     powershell.exe -noprofile -executionpolicy bypass -file ~/.dotfiles/PinToTaskBar.ps1 "C:\Program Files\WindowsApps\Microsoft.WindowsTerminalPreview_1.9.1445.0_x64__8wekyb3d8bbwe\wt.exe" PIN
    else
     center "Pinning Windows Terminal" "$MAGENTA"
     powershell.exe -noprofile -executionpolicy bypass -file ~/.dotfiles/PinToTaskBar.ps1 "%LOCALAPPDATA%\Microsoft\WindowsApps\wt.exe" PIN
    fi

    center "Un-Pinning MS Edge" "$MAGENTA"
    powershell.exe -noprofile -executionpolicy bypass -file ~/.dotfiles/PinToTaskBar.ps1 "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" UNPIN
}

main() {
   check_running_admin
   check_directory
   default_windows_settings
   #Choco needs terminal restart, if installed assume done first steps
   command_exists choco || download_chocolatey
   command_exists choco || {
        error "Choco command not available, restart terminal and run setup again. OR run runThis.bat inside Install-Choco directory for a local install."
        return 1
    }
   download_fonts   
   setup_terminal
   download_packages
   setup_devtools
   setup_dotfiles
   pin_to_taskbar
   init_git_users
}

main
