#!/bin/bash
##### BEFORE HOLIDAY - Testing pinning apps to taskbar, mainly windows terminal issue, check the if statements, check if can fix the version



##############
### COLORS ###
##############
### Only use colors if connected to a terminal
    if [ -t 1 ]; then
        RED=$(printf '\u001b[31m')
        GREEN=$(printf '\u001b[32m')
        YELLOW=$(printf '\u001b[33m')
        BLUE=$(printf '\u001b[34m')
        MAGENTA=$(printf '\u001b[35m')
        CYAN=$(printf '\u001b[36m')
        WHITE=$(printf '\u001b[37m')
        BOLD=$(printf '\033[1m')
        RESET=$(printf '\033[m')
    else
        RED=""
        GREEN=""
        YELLOW=""
        BLUE=""
        MAGENTA=""
        CYAN=""
        WHITE=""
        BOLD=""
        RESET=""
    fi

command_exists() {
    command -v "$@" >/dev/null 2>&1
}

error() {
    printf -- "%sError: $*%s\n" >&2 "$RED" "$RESET"
}

### Center print text, "text" "text color" "line color"
center() {
  termwidth="$(tput cols)"
  padding="$(printf '%0.1s' ={1..500})"

  textColor="${2:-$WHITE}"
  lineColor="${3:-$textColor}"
  printf '\n%s%*.*s %s%s%s %*.*s\n' "$lineColor" 0 "$(((termwidth-2-${#1})/2))" "$padding" "$textColor" "$1" "$lineColor" 0 "$(((termwidth-1-${#1})/2))" "$padding" "$2"
}

check_directory() {
center "User: $(whoami)  |  Directory: $(pwd)" "$YELLOW" "$RED"

### Move directory to home directory if current directory doesn't end with username.
if [[ "$(pwd)" != "$HOME" ]]
then
    cd ~;
    center "Moved to $(pwd)" "$RED" "$RED"
fi
}

check_running_admin() {
        powershell.exe -noprofile -executionpolicy bypass -file ~/.dotfiles/admincheck.ps1
}

default_windows_settings() {
    center "Editing windows settings" "$YELLOW"
        powershell.exe -noprofile -executionpolicy bypass -file ~/.dotfiles/windows.ps1
}

download_chocolatey() {
center "Running Chocolatey Install" "$BLUE" "$BLUE"
# ### Chocolatey install
 powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%/chocolatey/bin
 powershell -noprofile -executionpolicy bypass -file ~/.dotfiles/restart.ps1
}

download_fonts() {
center "Downloading fonts" "$WHITE" "$YELLOW"

center "Installing Fira-Code font" "$GREEN" "$GREEN"
    choco install firacode -fy

center "Installing Cascadia-Code font" "$GREEN" "$GREEN"
# ## Add cascadiacode font for windows terminal
    choco install cascadiacode -fy
}

setup_terminal() {
center "Setting up windows terminal" "$MAGENTA" "$MAGENTA"

center "Terminal: Installing Windows Terminal" "$MAGENTA" "$MAGENTA"
# ## Install Windows Terminal
 choco install microsoft-windows-terminal -fy

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

download_packages() {
center "Downloading Applications" "$CYAN"
### Install all the packages
if [ ! -f "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" ]; then
 center "App: Installing Chrome" "$CYAN"
 choco install googlechrome -fy
fi
if [ ! -f "C:\Program Files\Mozilla Firefox\firefox.exe" ]; then
 center "App: Installing Firefox" "$CYAN"
 choco install firefox -fy
fi
if [ ! -f "$LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe" ]; then
 center "App: Installing VSCode" "$CYAN"
 choco install vscode -fy
fi
if [ ! -f "$LOCALAPPDATA\Postman\Postman.exe" ]; then
 center "App: Installing Postman" "$CYAN"
 choco install postman -fy
fi
if [ ! -f "$APPDATA\Spotify\Spotify.exe" ]; then
 center "App: Installing Spotify" "$CYAN"
 choco install spotify -fy
fi
### choco install <package_name> repeats for all the packages you want to install
}

### shellcheck source=/dev/null
setup_devtools() {
    center "Setting up development tools" "$YELLOW"

    command_exists git || {
        error "git is not installed"
        exit 1
    }
    command_exists nvm || {
     center "Dev Tool: Installing Node Version Manager" "$YELLOW"
     choco install nvm -fy
    }
    command_exists node || {
    center "Dev Tool: Installing Node.js" "$YELLOW"
     choco install nodejs-lts -fy
    }
    command_exists py || {
    center "Dev Tool: Installing Python" "$YELLOW"
     choco install python -fy
    }
    command_exists yarn || {
    center "Dev Tool: Installing Yarn" "$YELLOW"
     choco install yarn -fy
    }
    command_exists gh || {
    center "Dev Tool: Installing Github CLI" "$YELLOW"
     choco install gh -fy
    }
    center "Dev Tool: Installing Java JDK 11" "$YELLOW"
     choco install corretto11jdk -fy
    center "Dev Tool: Installing VMWare" "$YELLOW"
     choco install vmwareworkstation -fy
}

setup_dotfiles(){
center "Dotfile: Symlinking settings" "$GREEN"
# ## Symlink dot files.

FILES=$(ls -A ~/.dotfiles | grep "^\.")
for f in $FILES
do
  echo "Processing $f file..."
  center "Linking $f" "$GREEN"
  ln -sf ~/.dotfiles/$f "$HOME" 
  # take action on each file. $f store current file name
#   cat "$f"
done
# center "Linking .bash_aliases" "$GREEN"
# ln -sf ~/.dotfiles/.bash_aliases ~/.bash_aliases 
# center "Linking .bashrc" "$GREEN"
# ln -sf ~/.dotfiles/.bashrc ~/.bashrc 
# center "Linking .bash_profile" "$GREEN"
#  ln -sf ~/.dotfiles/.bash_profile ~/.bash_profile
# center "Linking .inputrc" "$GREEN"
#  ln -sf ~/.dotfiles/.inputrc ~/.inputrc
# center "Linking .gitconfig" "$GREEN"
#  ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig
center "Linking VSCode settings.json" "$GREEN"
mkdir -p $APPDATA/Code
ln -sf ~/.dotfiles/.vscode/settings.json $APPDATA/Code/User

center "Terminal: Symlinking Windows Terminal Settings" "$MAGENTA" "$MAGENTA"
# ## Add a symlink for Windows Terminal settings.
    TermianlFiles=$(ls "$LOCALAPPDATA/Packages" | grep "^Microsoft\.WindowsTerminal")
 if [ -d "$LOCALAPPDATA/Packages" ]; then
for f in $TermianlFiles
do
    if [ -d "$LOCALAPPDATA/Packages/$f/LocalState"]
        ln -sf ~/.dotfiles/windows-terminal-settings.jsonc $LOCALAPPDATA/Packages/$f/LocalState/settings.json
    fi
done
}

### Pin apps to taskbar and unpin edge. (Not sure how to unpin Windows Apps Store)
pin_to_taskbar(){
    center "Pinning Applications to taskbar" "$MAGENTA"
    center "Pinning Spotify" "$MAGENTA"
    powershell -noprofile -ExecutionPolicy Bypass -file ~/.dotfiles/PinToTaskBar.ps1 "$APPDATA\Spotify\Spotify.exe" PIN
    center "Pinning Chrome" "$MAGENTA"
    powershell -noprofile -ExecutionPolicy Bypass -file ~/.dotfiles/PinToTaskBar.ps1 "C:\Program Files\Google\Chrome\Application\chrome.exe" PIN
    center "Pinning VSCode" "$MAGENTA"
    if [ -f "$LOCALAPPDATA/Programs/Microsoft VS Code/Code.exe" ]; then
    powershell -noprofile -ExecutionPolicy Bypass -file ~/.dotfiles/PinToTaskBar.ps1 "$LOCALAPPDATA/Programs/Microsoft VS Code/Code.exe" PIN
    else
    powershell -noprofile -ExecutionPolicy Bypass -file ~/.dotfiles/PinToTaskBar.ps1 "C:\Program Files\Microsoft VS Code\Code.exe" PIN
    fi
    if [ -d "C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_8wekyb3d8bbwe" ]; then
     center "Pinning Windows Terminal" "$MAGENTA"
     powershell -noprofile -ExecutionPolicy Bypass -file ~/.dotfiles/PinToTaskBar.ps1 "C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_8wekyb3d8bbwe\wt.exe" PIN
    elif [ -d "C:\Program Files\WindowsApps\Microsoft.WindowsTerminalPreview_1.9.1445.0_x64__8wekyb3d8bbwe" ]; then
     center "Pinning Windows Terminal Preview" "$MAGENTA"
     powershell -noprofile -ExecutionPolicy Bypass -file ~/.dotfiles/PinToTaskBar.ps1 "C:\Program Files\WindowsApps\Microsoft.WindowsTerminalPreview_1.9.1445.0_x64__8wekyb3d8bbwe\wt.exe" PIN
    else
     center "Pinning Windows Terminal" "$MAGENTA"
     powershell -noprofile -ExecutionPolicy Bypass -file ~/.dotfiles/PinToTaskBar.ps1 "%LOCALAPPDATA%\Microsoft\WindowsApps\wt.exe" PIN
    fi

    center "Un-Pinning MS Edge" "$MAGENTA"
    powershell -noprofile -ExecutionPolicy Bypass -file ~/.dotfiles/PinToTaskBar.ps1 "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" UNPIN
}

main() {
   check_running_admin
   check_directory
   default_windows_settings
   #Choco needs terminal restart, if installed assume done first steps
   command_exists choco || download_chocolatey

   command_exists choco || {
        error "Choco command not available, restart terminal and run setup again."
        exit 1
    }
   download_fonts   
   setup_terminal
   download_packages
   setup_devtools
   setup_dotfiles
   pin_to_taskbar
   source ~/.dotfiles/gitUserFunctions
   init_git_users
}

main