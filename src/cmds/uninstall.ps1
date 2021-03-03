function uninstall ($MngmntFol) {
    
    if($args[1]){
        $installers = Get-ChildItem -Filter "*.msi" -LiteralPath "$MngmtFol\installers";
        if($installers.PSChildName.Contains("java$(args[1]).msi")){
            Start-Process msiexec.exe -Wait -ArgumentList "/x `"$MngmtFol\installers\java\$(args[1])`" \qn" -Verb RunAs;
            Write-Host "Uninstalled java $(args[1])";
        } else {
            Write-Host "$(args[1]) is not on the filesystem. Run jenv list local to see what release versions you have installed";
        }
    } else {
        Write-Output "Please specify a release version to uninstall, run jenv list local to see what you installed onto your filesystem";
    };

}