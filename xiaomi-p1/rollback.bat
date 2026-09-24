@echo off
echo ====================================================
echo Revertir Todo el Debloat - Xiaomi TV P1
echo ====================================================
set ADB="%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe"
%ADB% connect 192.168.1.33:5555

echo Reactivando todos los paquetes deshabilitados...
%ADB% shell pm enable com.miui.tv.analytics
%ADB% shell pm enable com.xiaomi.statistic
%ADB% shell pm enable com.mitv.tvhome.atv
%ADB% shell pm enable com.mitv.tvhome.michannel
%ADB% shell pm enable fusion.android.tv.demo
%ADB% shell pm enable com.duokan.factorytest
%ADB% shell pm enable com.mstar.android.tv.disclaimercustomization
%ADB% shell pm enable com.android.printspooler
%ADB% shell pm enable com.xiaomi.mitv.mediaexplorer
%ADB% shell pm enable com.mitv.videoplayer
%ADB% shell pm enable com.mitv.gallery
%ADB% shell pm enable com.xiaomi.mimusic2
%ADB% shell pm enable com.google.android.marvin.talkback
%ADB% shell pm enable com.google.android.videos
%ADB% shell pm enable com.google.android.tvrecommendations
%ADB% shell pm enable com.google.android.leanbacklauncher.recommendations
%ADB% shell pm enable com.google.android.tungsten.setupwraith
%ADB% shell pm enable com.xiaomo.tv.milegal
%ADB% shell pm enable com.google.android.partnersetup
%ADB% shell pm enable com.mediatek.wwtv.setupwizard
%ADB% shell pm enable com.google.android.feedback
%ADB% shell pm enable com.google.android.tv.bugreportsender
%ADB% shell pm enable com.google.android.syncadapters.contacts
%ADB% shell pm enable com.google.android.syncadapters.calendar
%ADB% shell pm enable com.android.dreams.basic
%ADB% shell pm enable com.mitv.dream
%ADB% shell pm enable com.xiaomi.floatingframe
%ADB% shell pm enable com.google.android.tvlauncher

echo Restaurando escalas de animacion por defecto...
%ADB% shell settings put global window_animation_scale 1.0
%ADB% shell settings put global transition_animation_scale 1.0
%ADB% shell settings put global animator_duration_scale 1.0

echo Reversion completada. Reiniciando la TV...
%ADB% shell reboot
pause
