$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"

# Intentar conexion con la IP actual
& $adb connect 192.168.1.43:5555
& $adb connect 192.168.1.33:5555

$packages = Get-Content -Path "$PSScriptRoot\kapatilanlar.txt" | Where-Object { $_ -and -not $_.StartsWith("#") }

foreach ($pkg in $packages) {
    Write-Host "Reactivando $pkg..." -ForegroundColor Cyan
    & $adb shell pm enable $pkg
}

Write-Host "Restaurando animaciones..." -ForegroundColor Yellow
& $adb shell settings put global window_animation_scale 1.0
& $adb shell settings put global transition_animation_scale 1.0
& $adb shell settings put global animator_duration_scale 1.0

Write-Host "Reiniciando TV..." -ForegroundColor Green
& $adb shell reboot
