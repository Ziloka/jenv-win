function clean($MngmtFol) {

    Remove-Item -Path $MngmtFol
    Write-Host "Removed all data";

}