Stop-Process -Name "bash","git-bash" -Force -ErrorAction SilentlyContinue
Start "C:\Program Files\Git\git-bash.exe" $HOME\.dotfiles\setup.sh -Verb RunAs