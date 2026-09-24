@echo off
set ADB="%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe"
%ADB% connect 192.168.1.37:5555

echo Reactivando paquetes desactivados...
for /f "usebackq eol=# tokens=*" %%i in ("%~dp0kapatilanlar.txt") do (
    echo Reactivando: %%i
    %ADB% -s 192.168.1.37:5555 shell pm enable %%i
)

echo Restaurando escalas de animacion a 1.0x...
%ADB% -s 192.168.1.37:5555 shell settings put global window_animation_scale 1.0
%ADB% -s 192.168.1.37:5555 shell settings put global transition_animation_scale 1.0
%ADB% -s 192.168.1.37:5555 shell settings put global animator_duration_scale 1.0

echo Reiniciando TV TCL...
%ADB% -s 192.168.1.37:5555 shell reboot
pause
