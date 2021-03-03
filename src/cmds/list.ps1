function list($ablrlse, $MngmtFol) {

    Write-Host $ablrlse

    $ReleasesResponse = Invoke-RestMethod -Uri $ablrlse;
    $releases = Sort-Object -InputObject ($ReleasesResponse.available_releases + $ReleasesResponse.available_lts_releases | Select-Object -Unique);
    if($args[1]){
        # Check if User Gave valid release version
        if($releases.Contains($args[1])){
            $versions = Invoke-RestMethod -Uri "https://api.adoptopenjdk.net/v3/assets/feature_releases/$(args[1])/ga";
            $featureReleases = $versions | Where-Object { $_.binaries.os -eq "windows"};
            Write-Host "Here are all available releases for $(args[1])


$($featureReleases | ForEach-Object { $_.release_name } -join "`n")


To Install this specific release run jenv install <release name>"
        } elseif ($args[1] -eq "local"){
            $locrlses = (Get-ChildItem -Path $MngmtFol -File -Include java*.msi) -join ", ";
            if($locrlses.length -eq 0){
                $locrlses = "None"
            }
            Write-Host "Locally installed versions:
            
$locrlses
"
        } else {
            Write-Host "$(args[1]) is not a valid release name, run jenv list to view the available release names";
        }
    } else {
        Write-Host "Here are all available releases:
        
$($releases -join ", ")

To get more information about a specific release run jenv list <release name>";
    };

}