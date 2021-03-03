# Adoptopenjdk API v3 Endpoints Documentation 
# https://api.adoptopenjdk.net/swagger-ui/

#############################
#############################
#
#
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-7.1#script-scope-and-dot-sourcing
# Lets you run Script in current scope instead of the script scope
# Allowing you to write commands in the script to run as if you typed them in the command prompt 

. ..\cmds\info.ps1;
. ..\cmds\install.ps1;
. ..\cmds\list.ps1;
. ..\cmds\refreshenv.ps1;
. ..\cmds\uninstall.ps1;
. ..\cmds\use.ps1;

#
#
#############################
#############################

$ablrlse = "https://api.adoptopenjdk.net/v3/info/available_releases";
$MngmtFol = "$env:APPDATA\jenv";


if((Test-Path -Path $MngmtFol) -eq $false){
    New-Item -Path $MngmtFol -ItemType "Directory" | Out-Null;
};

if((Test-Path -Path "$MngmtFol\installers") -eq $false){
    New-Item -Path "$MngmtFol\installers" -ItemType "Directory" | Out-Null;
};

$arch = $env:PROCESSOR_ARCHITECTURE

switch ($args[0]) {
    "help" {
        # Hard Coded for now will be dynamic soon
        Write-Host "Here are all the commands for jenv for windows
help
on
off
list
install
use
uninstall
info
";
        break;
    };
    "list" {
        list $ablrlse $MngmtFol;
        break;
    };
    "install" {
        install $MngmtFol $ablrlse $arch;
        break;
    };
    "use" {
       use $MngmtFol;
        break;
    };
    "uninstall" {
        uninstall $MngmtFol;
        break;
    };
    "refreshenv" {
        refreshenv;
    };
    "info" {
        info $arch;
    }
    Default {
        "Invalid Command. Run jenv help to see what commands there are";
    };
};