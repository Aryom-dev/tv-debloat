# TV Debloat Log - TCL Smart TV (Android 11)

## Información del Dispositivo
- **Fabricante:** TCL
- **Modelo:** Smart TV (Build AR2101)
- **Versión de Android:** 11
- **IP:** 192.168.1.37:5555
- **Launcher Configurado:** AT4K Launcher (com.overdevs.at4k)

## Comparativa de Memoria (Before vs After)

| Métrica | Antes del Debloat | Después del Debloat | Diferencia / Impacto |
| :--- | :--- | :--- | :--- |
| **ZRAM (Swap en compresión)** | 374,424 KB (~374 MB) | 233,728 KB (~234 MB) | **-140.7 MB (-38%)** *(Liberación masiva de CPU en descompresión continua)* |
| **Launcher Stock de Google** | 160,196 KB (~160 MB) | **0 KB (Deshabilitado)** | **-160.2 MB liberados** *(AT4K activo como Home)* |
| **Recomendaciones y Ads Google** | 77,904 KB (~78 MB) | **0 KB (Deshabilitado)** | **-77.9 MB liberados** |
| **Asistente residual de setup Google** | 40,512 KB (~41 MB) | **0 KB (Deshabilitado)** | **-40.5 MB liberados** |
| **UI de Guardia / Antivirus TCL** | 69,168 KB (~69 MB) | **0 KB (Deshabilitado)** | **-69.2 MB liberados** |
| **Demos y banners comerciales TCL** | Activos | **0 KB (Deshabilitado)** | **Eliminados** |

---

## Registro de Paquetes Deshabilitados

| Lote | Paquete | Descripción | Motivo |
| :--- | :--- | :--- | :--- |
| 1 | com.tcl.esticker | E-sticker comercial | Modo demostración de tienda de fábrica |
| 1 | com.tcl.factory.view | Vista de pruebas de fábrica | Innecesario para el usuario final |
| 1 | com.tcl.useragreement | Acuerdos legales TCL | Telemetría y avisos residuales |
| 1 | com.tcl.keyhelp | Superposición de ayuda de teclas | Innecesario |
| 1 | com.android.printspooler | Servicio de impresión Android | Innecesario en TV |
| 1 | com.tcl.copydatatotv | Asistente de copia de datos | Proceso residual de setup |
| 1 | com.tcl.waterfall.overseas | TCL Waterfall Overseas | Canal publicitario / streaming de promociones |
| 1 | com.tcl.t_solo | Contenido comercial TCL | Innecesario |
| 1 | com.tcl.usercenter | Centro de cuenta de usuario TCL | Bloatware comercial |
| 1 | com.tcl.dashboard | Panel publicitario flotante TCL | Innecesario |
| 1 | com.tcl.messagebox | Bandeja de avisos publicitarios | Innecesario |
| 2 | com.tcl.audioplayer | Reproductor de audio TCL | Redundante |
| 2 | com.tcl.videoplayer | Reproductor de vídeo TCL | Redundante |
| 2 | com.tcl.imageplayer | Visor de fotos TCL | Redundante |
| 2 | com.tcl.ui_mediaCenter | Centro de medios TCL | Redundante |
| 2 | com.google.android.marvin.talkback | Lector de pantalla TalkBack | Accesibilidad visual no requerida |
| 2 | com.google.android.tvrecommendations | Filas de recomendaciones Google | Anuncios/sugerencias de Google (~78 MB RAM) |
| 2 | com.google.android.tungsten.setupwraith | Asistente de configuración Google | Proceso residual de setup (~41 MB RAM) |
| 2 | com.google.android.partnersetup | Setup de socios Google | Proceso residual de setup |
| 2 | com.tcl.initsetup | Setup inicial de fábrica TCL | Proceso residual |
| 2 | com.android.dreams.basic | Salvapantallas básico Android | Redundante |
| 2 | com.tcl.guard | TCL Safety Guard | Optimizador / telemetría intrusiva (~69 MB RAM UI) |
| 3 | com.google.android.feedback | Enviador de fallos Google | Telemetría / informes de error |
| 3 | com.google.android.syncadapters.calendar | Sincronización de calendario | Innecesario en TV |
| 4 | com.google.android.tvlauncher | Android TV Home Launcher de Google | Sustituido por AT4K Launcher (~160 MB RAM liberados) |

> **OPTIMIZACIONES DE INTERFAZ:**
> - window_animation_scale: 0.5x
> - 	ransition_animation_scale: 0.5x
> - nimator_duration_scale: 0.5x
> - pm trim-caches ejecutado

> **PAQUETES CRÍTICOS PROTEGIDOS (INTOCABLES):**
> - com.tcl.suspension: Receptor y controlador de la tecla de Entradas (Input / Source HDMI). **INTOCABLE**.
> - com.tcl.partnercustomizer: Mapeador de la tecla especial T-Key del mando físico. **INTOCABLE**.
> - com.tcl.tcl_bt_rcu_service & com.tcl.autopair: Mando Bluetooth TCL. **INTOCABLE**.
> - com.tcl.tvinput & com.tcl.tv: Sintonizador y entradas HDMI. **INTOCABLE**.
> - com.tcl.settings: Ajustes avanzados de hardware de panel e imagen. **INTOCABLE**.
> - com.dolby.android.audio.service: Procesamiento Dolby. **INTOCABLE**.

---

## Cómo revertir cambios (Rollback)
Para reactivar cualquier paquete individualmente:
`ash
adb shell pm enable <nombre_del_paquete>
`
O ejecutar el script ollback.bat o ollback.ps1 ubicado en esta misma carpeta.
