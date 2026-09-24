$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
& $adb connect 192.168.1.37:5555

$packages = Get-Content -Path "$PSScriptRoot\kapatilanlar.txt" | Where-Object { $_ -and -not $_.StartsWith("#") }

foreach ($pkg in $packages) {
    Write-Host "Reactivando $pkg..." -ForegroundColor Cyan
    & $adb -s 192.168.1.37:5555 shell pm enable $pkg
}

Write-Host "Restaurando animaciones..." -ForegroundColor Yellow
& $adb -s 192.168.1.37:5555 shell settings put global window_animation_scale 1.0
& $adb -s 192.168.1.37:5555 shell settings put global transition_animation_scale 1.0
& $adb -s 192.168.1.37:5555 shell settings put global animator_duration_scale 1.0

Write-Host "Reiniciando TV..." -ForegroundColor Green
& $adb -s 192.168.1.37:5555 shell reboot
