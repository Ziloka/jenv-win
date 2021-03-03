function refreshenv(){

    Write-Output "Refreshing terminal...";
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User");
    Write-Output "Finished refreshing terminal";
    
}