function use ($MngmtFol) {
    
    if($args[1]){
        $installers = Get-ChildItem -Filter "*.msi" -LiteralPath "$MngmtFol\installers";
         if($installers.PSChildName.Contains("java$(args[1]).msi")){
            # Documentation on Adoptopenjdk MSI Installer Argument List
            # https://adoptopenjdk.net/installation.html#windows-msi
            # Properly install something using msi executable application
            # msiexec /i "<package>.msi" ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome
            # Start-Process msiexec.exe -ArgumentList '/i "<package.msi>" ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome' -Verb RunAs
            Start-Process msiexec.exe -Wait -ArugmentList "/i `"$MngmtFol\installers\java$(args[1])`"  ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome /qn" -Verb RunAs;
            Write-Host "Now using java $(args[1])";
            # Write-Host "Now using java $(args[1])";
            # Refresh Current Terminal Session
            Write-Output "Refreshing terminal...";
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User");
            Write-Output "Finished refreshing terminal";
        } else {
           Write-Host "$(args[1]) is not on the file system. Run jenv list local to see what release versions you have installed"
        };
    } else {
        Write-Output "Please specify a release version, run jenv list local to see what you installed onto your filesystem";
    }

}