# Adoptopenjdk API v3 Endpoints Documentation 
# https://api.adoptopenjdk.net/swagger-ui/

$availableReleasesURL = "https://api.adoptopenjdk.net/v3/info/available_releases";
$ManagementFolder = [String]::Format("{0}\jenv", $env:APPDATA);

if((Test-Path -Path $ManagementFolder) -eq $false){
    # [String]::Format("Could not find management directory`nCreating management directory at {0}`n`n", $ManagementFolder);
    New-Item -Path $ManagementFolder -ItemType "Directory" | Out-Null;
};

if((Test-Path -Path ([String]::Format("{0}/installers", $ManagementFolder))) -eq $false){
    New-Item -Path ([String]::Format("{0}/installers", $ManagementFolder)) -ItemType "Directory" | Out-Null;
};

if((Test-Path -Path ([String]::Format("{0}/config.json", $ManagementFolder))) -eq $false){
    "{`"architectures`": {`"AMD64`": `"x64`"}}" | Out-File -Encoding "UTF8" -FilePath ([String]::Format("{0}/config.json", $ManagementFolder))
    # New-Item -Path ([String]::Format("{0}/config.json", $ManagementFolder)) -ItemType "File" | Out-Null;
}

$config = ConvertFrom-Json -InputObject (Get-Content -Raw -Encoding "UTF8" -Path ([String]::Format("{0}\config.json", $ManagementFolder)));
$arch = $config.architectures.($env:PROCESSOR_ARCHITECTURE);
switch ($args[0]) {
    "help" {
        # Hard Coded for now will be dynamic soon
        [String]::Format("Here are all the commands for jenv for windows`nhelp`non`noff`nlist`ninstall`nuse`nuninstall");
        break;
    };
    "list" {
        $ReleasesResponse = Invoke-RestMethod -Uri $availableReleasesURL;
        $releases = Sort-Object -InputObject ($ReleasesResponse.available_releases + $ReleasesResponse.available_lts_releases | Select-Object -Unique);
        if($args[1]){
            # Check if User Gave valid release version
            if($releases.Contains($args[1])){
                $versions = Invoke-RestMethod -Uri ([String]::Format("https://api.adoptopenjdk.net/v3/assets/feature_releases/{0}/ga", $args[1]));
                $featureReleases = $versions | Where-Object { $_.binaries.os -eq "windows"};
                # $featureReleases = $versions | Where-Object { ($_.binaries.os -eq "windows") -and ($_.binaries.architecture -eq $arch) };
                [String]::Format("Here are all available releases for {0}`n`n{1}`n`nTo Install this specific release run jenv install <release name>", $args[1], ($featureReleases | ForEach-Object { $_.release_name }) -join "`n");
            } else {
                [String]::Format("{0} is not a valid release name, run jenv list to view the available release names");
            };
        } else {
            [String]::Format("Here are all available releases:`n`n{0}`n`nTo get more information about a specific release run jenv list <release name>", $releases -join "`n");
        };
        break;
    };
    "install" {
        if($args[1]){
            $ReleasesResponse = Invoke-RestMethod -Uri $availableReleasesURL;
            $releases = Sort-Object -InputObject ($ReleasesResponse.available_releases + $ReleasesResponse.available_lts_releases | Select-Object -Unique);
            if($releases.Contains($args[1])){
                [String]::Format("Now Downloading java {0}", $args[1]);
                $ProgressPreference = 'SilentlyContinue';
                Invoke-WebRequest -Uri([String]::Format("http://api.adoptopenjdk.net/v3/installer/latest/{0}/ga/windows/x64/jdk/hotspot/normal/adoptopenjdk", $args[1])) -OutFile ([String]::Format("{0}/installers/java{1}.msi", $ManagementFolder, $args[1]));
                [String]::Format("Successfully downloaded the latest minor java version for java {0}", $args[1]);
            } else {
                [String]::Format("{0} is a invalid feature version`n`nRun jenv list to look at the responses", $args[1]);
            };
        } else {
            Write-Host "Please specify a release version, run jenv list to view the release versions";
        };
        break;
    };
    "use" {
        if($args[1]){
            $installers = Get-ChildItem -Filter "*.msi" -LiteralPath ([String]::Format("{0}/installers", $ManagementFolder));
            if($installers.PSChildName.Contains([String]::Format("java{0}.msi", $args[1]))){
                # Documentation on Adoptopenjdk MSI Installer Argument List
                # https://adoptopenjdk.net/installation.html#windows-msi
                # Properly install something using msi executable application
                # msiexec /i "<package>.msi" ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome
                # Start-Process msiexec.exe -ArgumentList '/i "<package.msi>" ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome' -Verb RunAs
                Start-Process msiexec.exe -Wait -ArgumentList ([String]::Format("/i `"{0}\installers\java{1}.msi`" ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome /qn", $ManagementFolder, $args[1])) -Verb RunAs;
                [String]::Format("Now using java {0}", $args[1]);
                # Refresh Current Terminal Session
                Write-Output "Refreshing terminal...";
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User");
                Write-Output "Finished refreshing terminal";
            } else {
                [String]::Format("{0} is not on the file system. Run jenv list local to see what release versions you have installed");
            };
        } else {
            Write-Output "Please specify a release version, run jenv list local to see what you installed onto your filesystem";
        }
        break;
    };
    "uninstall" {
        if($args[1]){
            $installers = Get-ChildItem -Filter "*.msi" -LiteralPath ([String]::Format("{0}/installers", $ManagementFolder));
            if($installers.PSChildName.Contains([String]::Format("java{0}.msi", $args[1]))){
                Start-Process msiexec.exe -Wait -ArgumentList ([String]::Format("/x `"{0}\installers\java{1}.msi`" \qn", $ManagementFolder, $args[1])) -Verb RunAs
                [String]::Format("Uninstalled java {0}",  $args[1]);
            } else {
                [String]::Format("{0} is not on the filesystem. Run jenv list local to see what release versions you have installed");
            }
        } else {
            Write-Output "Please specify a release version to uninstall, run jenv list local to see what you installed onto your filesystem";
        };
        break;
    };
    "refreshenv" {
        Write-Output "Refreshing terminal...";
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User");
        Write-Output "Finished refreshing terminal";
    };
    Default {
        "Invalid Command. Run jenv commands to see what commands there are";
    };
};