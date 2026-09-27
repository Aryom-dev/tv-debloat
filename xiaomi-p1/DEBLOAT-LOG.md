# Auditoría y Registro de Debloat - Xiaomi Mi TV P1

- **Dispositivo:** Xiaomi MiTV-MOOQ0 (Xiaomi TV P1)
- **Sistema Operativo:** Android TV 10
- **IP de Conexión:** `192.168.1.43:5555` (anteriormente `192.168.1.33:5555`)
- **Launcher Seleccionado:** AT4K Launcher (`com.overdevs.at4k`)
- **Regla Fundamental:** Cero desinstalaciones destructivas (`pm disable-user --user 0` únicamente). Certificado Widevine L1 intacto, sin root.

---

## 1. Hallazgos Técnicos Críticos y Árbol de Dependencias

### A. La cadena de dependencia del Botón Físico "Input / Source"
Durante las pruebas de depuración y lectura del log del sistema (`logcat`), se descubrió la cadena exacta de eventos que dispara el botón de entradas del mando a distancia de Xiaomi:

```text
[Mando Bluetooth Xiaomi]
           │ (Pulsación física de tecla KEYCODE_TV_INPUT / 178)
           ▼
[com.xiaomi.android.tvsetup.partnercustomizer] (Componente: GlobalKeyReceiver)
           │
           │ Ejecuta: startActivity({act=com.android.tv.action.VIEW_INPUTS
           │                         cmp=com.google.android.tvlauncher/.inputs.InputsPanelActivity})
           ▼
[com.google.android.tvlauncher] (Componente: InputsPanelActivity - Panel lateral de fuentes)
```

* **Descubrimiento 1 (`partnercustomizer`):** Si se deshabilita `com.xiaomi.android.tvsetup.partnercustomizer`, el receptor `GlobalKeyReceiver` desaparece y la TV queda "sorda" a la señal del mando. **Clasificado como INTOCABLE.**
* **Descubrimiento 2 (`tvlauncher`):** Xiaomi programó en el código fuente de fábrica de su ROM (`/system/priv-app/MiTvSetupCustomizer/MiTvSetupCustomizer.apk`) una llamada directa y estricta a `com.google.android.tvlauncher.inputs.InputsPanelActivity`. Si `com.google.android.tvlauncher` está deshabilitado, Android arroja:
  ```text
  GlobalKey: receive KEYCODE_TV_INPUT start activity
  ActivityTaskManager: START u0 {act=com.android.tv.action.VIEW_INPUTS cmp=com.google.android.tvlauncher/.inputs.InputsPanelActivity}
  GlobalKey: ActivityNotFound
  ```
* **Decisión de Arquitectura (Opción A):** Para no tener dos launchers corriendo simultáneamente (ahorrando ~143 MB de RAM de Google TV Launcher) y no depender de servicios de accesibilidad de terceros en segundo plano:
  * Se mantiene `com.google.android.tvlauncher` **deshabilitado**.
  * La conmutación de entradas HDMI se realiza directamente a través de los accesos directos de **"Entradas / HDMI"** en la interfaz de AT4K Launcher.

### B. PatchWall (`com.mitv.tvhome.atv`)
* Contiene la interfaz de PatchWall y el diálogo nativo de fuentes `InputSourcePopupActivity`.
* Se mantiene **habilitado** en el sistema para permitir que los accesos directos de cambio de fuentes funcionen en AT4K Launcher.
* La publicidad y canales promocionales asociados (`com.mitv.tvhome.michannel`) están deshabilitados.
* El icono en la pantalla de inicio se oculta directamente desde los ajustes de cuadrícula de AT4K Launcher (*Ocultar app*).

### C. Limpieza de Actualizaciones en `/data` (YouTube Oficial)
* La app preinstalada de YouTube (`com.google.android.youtube.tv`) tenía una actualización residual de ~80 MB en `/data/app/`.
* Se desinstaló la actualización residual para liberar almacenamiento interno del usuario y se congeló el paquete de fábrica (`disabled-user`), dejando el cliente alternativo del usuario como único reproductor.

---

## 2. Comparativa de Rendimiento y Memoria (Before vs After)

| Métrica / Proceso | Antes del Debloat | Después del Debloat | Diferencia / Impacto Real |
| :--- | :--- | :--- | :--- |
| **ZRAM (Swap en compresión)** | **311,800 KB (~312 MB)** | **82,944 KB (~83 MB)** | **-228.8 MB (-73%)** *(Se eliminó la saturación de swap en CPU)* |
| **Google TV Launcher** | 142,779 KB (~143 MB) | **0 KB (Deshabilitado)** | **-142.8 MB liberados** |
| **FLauncher residual** | 117,201 KB (~117 MB) | **0 KB (Inactivo)** | **-117.2 MB liberados** |
| **Telemetría y Rastreo Xiaomi** | 14,292 KB | **0 KB (Deshabilitado)** | **Eliminado al 100%** |
| **Recomendaciones y Ads Google** | 14,716 KB | **0 KB (Deshabilitado)** | **Eliminado al 100%** |
| **Actualizador en segundo plano** | 39,613 KB | **0 KB (Deshabilitado)** | **-39.6 MB liberados** |
| **Asistentes residuales de boot** | 23,300 KB | **0 KB (Deshabilitado)** | **-23.3 MB liberados** |
| **Escalas de animación del sistema**| 1.0x (Estándar) | **0.5x (Aceleradas)** | **Transición de menús 2x más rápida** |

---

## 3. Inventario de Paquetes Deshabilitados

### A. Deshabilitados durante este proceso (27 paquetes):
| Lote | Nombre del Paquete | Descripción | Motivo |
| :--- | :--- | :--- | :--- |
| 1 | `com.miui.tv.analytics` | Telemetría / analíticas Xiaomi | Envío de telemetría en segundo plano |
| 1 | `com.xiaomi.statistic` | Estadísticas y rastreo Xiaomi | Recolección de datos de uso |
| 1 | `com.mitv.tvhome.michannel` | Mi Channel en PatchWall | Canales promocionales de Xiaomi |
| 1 | `fusion.android.tv.demo` | Retail Demo Mode | Modo demostración de tiendas |
| 1 | `com.duokan.factorytest` | Test de fábrica Xiaomi/Duokan | Herramienta residual de ensamblaje |
| 1 | `com.mstar.android.tv.disclaimercustomization` | Avisos legales de fábrica | Cuadros emergentes innecesarios |
| 1 | `com.android.printspooler` | Servicio de impresión Android | Innecesario en TV |
| 2 | `com.xiaomi.mitv.mediaexplorer` | Gestor de archivos Xiaomi | Reemplazado por explorador del usuario |
| 2 | `com.mitv.videoplayer` | Reproductor de vídeo Xiaomi | Redundante con reproductores del usuario |
| 2 | `com.mitv.gallery` | Galería multimedia Xiaomi | Redundante con apps del usuario |
| 2 | `com.xiaomi.mimusic2` | Xiaomi Music | Servicio redundante de música |
| 2 | `com.google.android.marvin.talkback` | Lector de pantalla TalkBack | Accesibilidad visual no solicitada |
| 2 | `com.google.android.videos` | Google Play Películas / Google TV | Tienda/reproductor no utilizado |
| 2 | `com.google.android.tvrecommendations` | Filas de recomendaciones Google | Filas de anuncios y sugerencias en Home |
| 2 | `com.google.android.leanbacklauncher.recommendations` | Recomendaciones Leanback | Canales patrocinados |
| 2 | `com.google.android.tungsten.setupwraith` | Setup Wizard de Google | Proceso de configuración post-inicio |
| 3 | `com.xiaomo.tv.milegal` | Avisos legales Xiaomi | Innecesario |
| 3 | `com.google.android.partnersetup` | Setup de socios Google | Proceso residual |
| 3 | `com.mediatek.wwtv.setupwizard` | Setup inicial MediaTek | Proceso residual del SoC |
| 3 | `com.google.android.feedback` | Enviador de fallos Google | Telemetría de reportes de error |
| 3 | `com.google.android.tv.bugreportsender` | Enviador de bugs de TV | Telemetría en segundo plano |
| 3 | `com.google.android.syncadapters.contacts` | Sincronización de contactos | Innecesario en TV |
| 3 | `com.google.android.syncadapters.calendar` | Sincronización de calendario | Innecesario en TV |
| 3 | `com.android.dreams.basic` | Salvapantallas básico Android | Redundante (usuario tiene Aerial Views) |
| 3 | `com.mitv.dream` | Salvapantallas Xiaomi | Redundante |
| 3 | `com.xiaomi.floatingframe` | Marco flotante fotos Xiaomi | Innecesario |
| 4 | `com.google.android.tvlauncher` | Google TV Home Launcher | Deshabilitado a favor de AT4K Launcher |

### B. Paquetes congelados previamente por el usuario o de fábrica (6 paquetes):
- `com.amazon.amazonvideo.livingroom` (Prime Video de fábrica)
- `com.google.android.play.games` (Google Play Juegos)
- `com.google.android.youtube.tvmusic` (YouTube Music)
- `com.google.android.youtube.tv` (YouTube TV oficial - actualización de 80 MB purgada)
- `com.mitv.tvlock` (Bloqueo infantil Xiaomi)
- `com.xiaomi.amazon.alexa` (Integración Alexa de Xiaomi)

---

## 4. Lista de Paquetes Protegidos (INTOCABLES)

Bajo ninguna circunstancia deben deshabilitarse los siguientes paquetes en este modelo:
1. **Control Remoto y Bluetooth:**
   - `com.xiaomi.android.tvsetup.partnercustomizer` (Captura global de teclas BLE y control remoto).
   - `com.google.android.tv.remote.service` (Mando a distancia desde móviles Android/iOS).
   - `com.android.bluetooth` y extensiones RRO de Bluetooth.
2. **Entradas HDMI y Sintonizador:**
   - `com.mediatek.tvinput`, `com.mediatek.tv.service`, `com.mediatek.wwtv.tvcenter`, `dtv_svc`.
3. **Servicios solicitados explícitamente por el usuario:**
   - `com.google.android.katniss` y `com.google.android.tv.assistant` (Búsqueda por voz para las sobrinas).
   - `com.xiaomi.mitv.smartshare` y `com.mitv.milinkservice` (Proyección de pantalla desde tablet/móvil Xiaomi).
4. **Núcleo del Sistema:**
   - `android`, `com.android.systemui`, `com.android.location.fused`, `com.google.android.gms`, `com.android.vending`, `com.google.android.inputmethod.latin` (Teclado Gboard).

---

## 5. Instrucciones de Restauración Total (Rollback)

Para reactivar todos los paquetes y restablecer las animaciones por defecto (1.0x):

### Opción 1: Ejecutar script por lotes (Doble clic)
Ejecutar el archivo [`rollback.bat`](file:///c:/Users/ginna/Desktop/biblioteca/tv-debloat/xiaomi-p1/rollback.bat).

### Opción 2: Comando directo en PowerShell
```powershell
$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
& $adb connect 192.168.1.43:5555
Get-Content -Path "c:\Users\ginna\Desktop\biblioteca\tv-debloat\xiaomi-p1\kapatilanlar.txt" | Where-Object { $_ -and -not $_.StartsWith("#") } | ForEach-Object { & $adb -s 192.168.1.43:5555 shell pm enable $_ }
& $adb -s 192.168.1.43:5555 shell settings put global window_animation_scale 1.0
& $adb -s 192.168.1.43:5555 shell settings put global transition_animation_scale 1.0
& $adb -s 192.168.1.43:5555 shell settings put global animator_duration_scale 1.0
& $adb -s 192.168.1.43:5555 shell reboot
```
