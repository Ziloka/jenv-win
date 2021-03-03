# Compile ps1 files to exe

Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/MScholtes/TechNet-Gallery/master/PS2EXE-GUI/ps2exe.ps1" -OutFile "ps2exe.ps1";
.\ps2exe.ps1 -InputFile .\src\jenv.ps1 -OutputFile .\bin\jenv.exe