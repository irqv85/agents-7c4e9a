# Claude Code para proyectos de GB Advisors

Guarda tus archivos en **Documentos\CliGB** y pídele a Claude lo que necesitas en español. Opus coordina el trabajo, Haiku ayuda a localizar información y Sonnet se encarga de tareas como calcular métricas. Opus revisa el resultado.

**[Descargar el kit para Windows (.zip)](https://github.com/irqv85/gb-advisors-claude-windows/archive/refs/heads/main.zip)**

## Instalación en Windows

Necesitas Windows con PowerShell y una cuenta de Claude Code con acceso a los modelos que vas a usar. Si falta Claude Code, el instalador usa WinGet para instalar **Claude Code CLI**, la aplicación de terminal de Anthropic.

1. **Descarga y extrae el ZIP.** Tras verificar su origen, abre sus Propiedades. Si Windows muestra **Desbloquear** y tu organización autoriza el paquete, marca esa opción antes de elegir **Extraer todo**.
2. **Haz doble clic en Instalar.cmd.** El instalador crea **CliGB** dentro de la carpeta **Documentos** de tu usuario de Windows. Si ya existe, la reutiliza. El instalador detecta Claude Code, lo instala con WinGet si hace falta y configura los agentes del proyecto. Atiende cualquier aviso que muestre WinGet.
3. **Abre el acceso directo en el escritorio.** Se llama **Claude Code - CliGB** y abre la terminal en **Documentos\CliGB** con Opus. En el primer uso, sigue el inicio de sesión de Anthropic con tu propia cuenta.
4. **Agrega tus archivos.** Abre en el Explorador **Documentos → CliGB**. Puedes guardar documentos directamente allí o crear subcarpetas para distintos trabajos.

## Cómo asignar un trabajo

Por ejemplo, crea **Documentos\CliGB\Ventas de noviembre** y copia allí tus reportes. Tú decides el nombre, la organización y los archivos.

Abre el acceso directo del proyecto y escribe:

> Revisa los archivos de la carpeta «Ventas de noviembre». Resume cómo van las ventas, señala qué clientes requieren seguimiento y dime qué datos respaldan cada conclusión.

Si guardaste los archivos directamente en la carpeta del proyecto, puedes decir:

> Revisa la propuesta que acabo de agregar. Resume los compromisos con el cliente y dime qué puntos quedan por aclarar antes de enviarla.

Para empezar otro trabajo, crea otra subcarpeta dentro de **CliGB**. Usa el mismo acceso directo e indica el nombre de la subcarpeta en tu pedido.

## Instalación desde PowerShell (opcional)

También puedes ejecutar el instalador desde PowerShell:
```powershell
powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File .\Instalar.ps1
```
Ejecuta el comando desde la carpeta donde extrajiste el instalador.

## Qué instala

| Archivo del proyecto | Función |
| --- | --- |
| `.claude/agents/explore.md` | Define Explore con Haiku y herramientas de lectura. |
| `.claude/agents/implementer.md` | Define implementer con Sonnet para cálculos, cambios y pruebas. |
| `.claude/rules/gb-advisors.md` | Guarda las instrucciones de delegación junto a las demás reglas del proyecto. |
| `Abrir Claude.cmd` | Abre Claude en esta carpeta con `claude --model opus`. |

Puedes volver a ejecutar el instalador. Si detecta que uno de los cuatro destinos ya contiene otra versión, te indica la ruta antes de copiar archivos. Si ya configuraste Explore o implementer a mano, compara las definiciones antes de instalar. Tu CLAUDE.md conserva su contenido. Para retirar la configuración de un proyecto, elimina su acceso directo y los archivos de la lista que haya añadido el kit. Claude Code seguirá disponible para otros proyectos.

## Si la instalación se detiene

- **Falta WinGet:** instala o actualiza *Instalador de aplicaciones* de Microsoft, abre una ventana nueva y vuelve a ejecutar el instalador.
- **Windows bloquea el script:** sigue el procedimiento de tu equipo de TI para ejecutar scripts internos.
- **La terminal no encuentra Claude después de instalarlo:** abre una ventana nueva de PowerShell y comprueba `claude --version`. Si funciona, vuelve a abrir el acceso directo.
- **Opus no está disponible:** comprueba con tu administrador el acceso de tu cuenta. Puedes consultar el modelo activo con `/model`.

## Uso comercial y consumo

**ServiceNow:** «Revisa la exportación de casos abiertos. Prioriza los críticos y, a igual prioridad, los que llevan más días sin actualización. Dame las tres cuentas a contactar, con el número de caso y una pregunta para soporte».

**Ventas:** «Compara los dos últimos meses completos de facturación por cliente y moneda. Comprueba los totales y explica qué tres clientes contribuyeron más al cambio».

Opus decide qué delegar según el pedido. Cada agente también consume tokens. Para evaluar el beneficio, ejecuta el mismo encargo sobre la misma copia de los datos en dos sesiones nuevas, una con Opus trabajando directamente y otra con delegación. Anota los datos disponibles en `/usage` según el plan, el tiempo y cualquier error en el resultado.

### Documentación de Anthropic

[Instalación en Windows](https://code.claude.com/docs/en/setup) · [Subagentes](https://code.claude.com/docs/en/sub-agents) · [Reglas del proyecto](https://code.claude.com/docs/en/memory) · [Uso y costos](https://code.claude.com/docs/en/costs)
