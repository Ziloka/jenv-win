$config = ConvertFrom-Json -InputObject (Get-Content -Raw -Encoding "UTF8" -Path ([String]::Format("config.json")));
Write-Output $config.architectures.($env:PROCESSOR_ARCHITECTURE)
