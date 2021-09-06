if exist "C:\ProgramData\chocolatey\" (
echo "Choco exists"
) else (
set "scriptpath=%~dp0"
set script=%scriptpath%ChocolateyInstall.ps1

powershell -ExecutionPolicy bypass -command "start-process powershell -argumentlist {-ExecutionPolicy bypass -file %script%} -verb runas"
)
if exist "C:\Program Files\Git\" (
echo "Git exists"
) else (
call "downloadGit.bat"
)
@echo off
setlocal
:PROMPT
SET /P AREYOUSURE=If you are trying to initialise windows setup (Programs, dotfiles etc), continue. Else, close this. (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

Powershell.exe -noprofile -executionpolicy bypass -file $HOME/.dotfiles/restart.ps1

:END
endlocal