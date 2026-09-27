# TV Debloat Log - Xiaomi Mi TV P1 (Android 10)

## Información del Dispositivo
- **Fabricante:** Xiaomi
- **Modelo:** MiTV-MOOQ0 (Xiaomi TV P1)
- **Versión de Android:** 10
- **IP:** 192.168.1.33:5555

## Comparativa de Memoria (Before vs After)

| Métrica | Antes del Debloat | Después del Debloat | Diferencia / Impacto |
| :--- | :--- | :--- | :--- |
| **ZRAM (Swap en compresión)** | 311,800 KB (~312 MB) | 82,944 KB (~83 MB) | **-228.8 MB (-73%)** *(La tele ya no ahoga la CPU paginando a swap)* |
| **Launcher Stock de Google** | 142,779 KB (~143 MB) | **0 KB (Deshabilitado)** | **-142.8 MB liberados** |
| **FLauncher en segundo plano** | 117,201 KB (~117 MB) | **0 KB (Inactivo)** | **-117.2 MB liberados** |
| **Telemetría y Analíticas Xiaomi** | 14,292 KB | **0 KB (Deshabilitado)** | **Eliminado por completo** |
| **Recomendaciones y Ads Google** | 14,716 KB | **0 KB (Deshabilitado)** | **Eliminado por completo** |
| **Actualizador en segundo plano Xiaomi**| 39,613 KB | **0 KB (Deshabilitado)** | **-39.6 MB liberados** |
| **Asistentes residuales de configuración**| 23,300 KB | **0 KB (Deshabilitado)** | **-23.3 MB liberados** |

---

## Registro de Paquetes Deshabilitados

| Lote | Paquete | Descripción | Motivo |
| :--- | :--- | :--- | :--- |
| 1 | `com.miui.tv.analytics` | Telemetría / analíticas Xiaomi | Telemetría en segundo plano (~14 MB RAM) |
| 1 | `com.xiaomi.statistic` | Estadísticas y rastreo Xiaomi | Recolección de telemetría |
| 1 | `com.mitv.tvhome.atv` | PatchWall ATV overlay / ads | Publicidad y recomendaciones PatchWall |
| 1 | `com.mitv.tvhome.michannel` | Mi Channel en PatchWall | Canales promocionales |
| 1 | `fusion.android.tv.demo` | Modo demostración de tienda | Basura de tienda de fábrica |
| 1 | `com.duokan.factorytest` | Test de fábrica Xiaomi/Duokan | Innecesario |
| 1 | `com.mstar.android.tv.disclaimercustomization` | Avisos legales de fábrica | Innecesario |
| 1 | `com.android.printspooler` | Servicio de impresión Android | Innecesario en TV |
| 2 | `com.xiaomi.mitv.mediaexplorer` | Gestor de archivos Xiaomi | Reemplazado por explorador de terceros |
| 2 | `com.mitv.videoplayer` | Reproductor de vídeo Xiaomi | Redundante |
| 2 | `com.mitv.gallery` | Galería multimedia Xiaomi | Redundante |
| 2 | `com.xiaomi.mimusic2` | Xiaomi Music | Redundante |
| 2 | `com.google.android.marvin.talkback` | Lector de pantalla TalkBack | Accesibilidad visual no requerida |
| 2 | `com.google.android.videos` | Google Play Películas / TV | No utilizado |
| 2 | `com.google.android.tvrecommendations` | Filas de recomendaciones Google | Anuncios/sugerencias de Google en home (~15 MB RAM) |
| 2 | `com.google.android.leanbacklauncher.recommendations` | Recomendaciones Leanback | Canales patrocinados |
| 2 | `com.google.android.tungsten.setupwraith` | Asistente de configuración Google | Proceso residual de setup (~11 MB RAM) |
| 3 | `com.xiaomo.tv.milegal` | Avisos legales Xiaomi | Innecesario |
| 3 | `com.google.android.partnersetup` | Setup de socios Google | Proceso residual de setup |
| 3 | `com.mediatek.wwtv.setupwizard` | Setup inicial MediaTek | Proceso residual |
| 3 | `com.google.android.feedback` | Enviador de fallos Google | Telemetría / informes de error |
| 3 | `com.google.android.tv.bugreportsender` | Enviador de bugs | Telemetría |
| 3 | `com.google.android.syncadapters.contacts` | Sincronización de contactos | Innecesario en TV |
| 3 | `com.google.android.syncadapters.calendar` | Sincronización de calendario | Innecesario en TV |
| 3 | `com.android.dreams.basic` | Salvapantallas básico Android | Redundante |
| 3 | `com.mitv.dream` | Salvapantallas Xiaomi | Redundante |
| 3 | `com.xiaomi.floatingframe` | Marco flotante fotos Xiaomi | Innecesario |
| 4 | `com.google.android.tvlauncher` | Android TV Home Launcher de Google | Sustituido por AT4K Launcher (`com.overdevs.at4k`) (~142 MB RAM liberados) |

> **OPTIMIZACIONES DE INTERFAZ:**
> - `window_animation_scale`: 0.5x
> - `transition_animation_scale`: 0.5x
> - `animator_duration_scale`: 0.5x
> - `pm trim-caches` ejecutado

> **NOTA CRÍTICA / DESCUBRIMIENTO:**
> El paquete `com.xiaomi.android.tvsetup.partnercustomizer` contiene los componentes `GlobalKeyReceiver` y `BleRcActivity`. Es el **equivalente exacto en Xiaomi al `com.tcl.suspension` de TCL**: su nombre parece basura, pero es el receptor que captura el botón de Entradas (Input / Source) del mando Bluetooth.
> **Pasa inmediatamente a la lista de INTOCABLES.**

> **COMPORTAMIENTO DEL BOTÓN FÍSICO "INPUT" (Opción A elegida):**
> En el firmware de Xiaomi TV P1, `GlobalKeyReceiver` intenta invocar obligatoriamente `com.google.android.tvlauncher/.inputs.InputsPanelActivity`.
> Al mantener deshabilitado `com.google.android.tvlauncher` para que la TV vuele con AT4K Launcher y ahorre ~143 MB de RAM, el botón físico arroja `ActivityNotFound`.
> Para conmutar a HDMI en la Opción A:
> 1. Usar el acceso directo / app de **"Entradas / TV"** (`com.mediatek.wwtv.tvcenter` o `InputSourcePopupActivity`) en AT4K Launcher.
> 2. O configurar en **Button Mapper** (`flar2.homebutton`) que el botón Input lance directamente `com.mitv.tvhome.atv/.app.tv.InputSourcePopupActivity`.

---

## Cómo revertir cambios (Rollback)
Para reactivar cualquier paquete individualmente:
```bash
adb shell pm enable <nombre_del_paquete>
```
O ejecutar el script `rollback.bat` / `rollback.ps1`.
