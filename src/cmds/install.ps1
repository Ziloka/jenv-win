function install($MngmtFol, $ablrlse){
    $ReleasesResponse = Invoke-RestMethod -Uri $ablrlse;
    if($args[1]){
        $releases = Sort-Object -InputObject ($ReleasesResponse.available_releases + $ReleasesResponse.available_lts_releases | Select-Object -Unique);
        if($releases.Contains($args[1])){
            Write-Host "Now Downloading java $(args[1])";
            $ProgressPreference = 'SilentlyContinue';
            Invoke-WebRequest -Uri "http://api.adoptopenjdk.net/v3/installer/latest/$($args[1])/ga/windows/x64/jdk/hotspot/normal/adoptopenjdk" -OutFile "$MngmtFol/installers/java$(args[1]).msi"
            Write-Host "Successfully downloaded the latest minor java version for java $(args[1])";
        } else {
            Write-Host "$(args[1]) is a invalid feature version
            
Run jenv list to look at the responses";
        };
    } else {
        Write-Host "Please specify a release version, run jenv list to view the release versions";
    };
}