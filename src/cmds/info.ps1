function info($arch) {

    Write-Output "
Arch: $arch
Powershell version: $($PSVersionTable.PSVersion.toString())
Powershell build: $($PSVersionTable.BuildVersion)
"
    
}