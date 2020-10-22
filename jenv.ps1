# Adoptopenjdk API v3 Endpoints Documentation 
# https://api.adoptopenjdk.net/swagger-ui/

$availableReleasesURL = "https://api.adoptopenjdk.net/v3/info/available_releases";

$arch = $env:PROCESSOR_ARCHITECTURE;
switch ($args[0]) {
    "help" {
        # Hard Coded for now will be dynamic soon
        [String]::Format("Here are all the commands for jenv for windows`nhelp`non`noff`nlist`ninstall`nuse`nuninstall");
        break;
    }
    "on" {

        break;
    }
    "off" {

        break;
    }
    "list" {
        $ReleasesResponse = Invoke-RestMethod -Uri $availableReleasesURL;
        $releases = Sort-Object -InputObject ($ReleasesResponse.available_releases + $ReleasesResponse.available_lts_releases | Select-Object -Unique);
        if($args[1]){
            # Check if User Gave valid release version
            if($releases.Contains($args[1])){
                $versions = Invoke-RestMethod -Uri ([String]::Format("https://api.adoptopenjdk.net/v3/assets/feature_releases/{0}/ga", $args[1]));
                $featureReleases = $versions | Where-Object { $_.binaries.os -eq "windows" };
                # $featureReleases = $versions | Where-Object -Property "binaries.os" -eq "windows";
                [String]::Format("Here are all available releases for {0}`n`n{1}`n`nTo Install this specific release run jenv install <release name>", $args[1], ($featureReleases | ForEach-Object { $_.release_name }) -join "`n");
            } else {
                [String]::Format("{0} is not a valid release name, run jenv list to view the available release names");
            };
        } else {
            [String]::Format("Here are all available releases:`n`n{0}`n`nTo get more information about a specific release run jenv list <release name>", $releases -join "`n");
            # "Here are all available releases:`n{0}" -f ($releases -join "`n")
        };
        break;
    }
    "install" {

        break;
    }
    "use" {

        break;
    }
    "uninstall" {

        break;
    }
    Default {
        "Invalid Command. Run jenv commands to see what commands there are"
    };
}