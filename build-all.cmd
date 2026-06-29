cd "%~dp0"
if NOT EXIST .\covers mkdir .\convers
cd .\covers
call .\build-cover-all.cmd
cd ..
pwsh .\build.ps1 -Lang it
pwsh .\build.ps1 -Lang en
node convert-tex-to-md.js
pause