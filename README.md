# Claude Code para proyectos de GB Advisors

Kit para configurar Claude Code en una carpeta de Windows. Puedes pedir en español «¿Qué clientes tienen casos críticos abiertos?» y dejar que Opus coordine el análisis. Haiku localiza los archivos y Sonnet calcula las métricas. Opus revisa las cifras antes de recomendar a quién llamar.

**[Descargar el kit para Windows (.zip)](https://github.com/irqv85/gb-advisors-claude-windows/archive/refs/heads/main.zip)**

## Instalación en Windows

Necesitas Windows con PowerShell y una cuenta de Claude Code con acceso a los modelos que vas a usar. Si falta Claude Code, el instalador usa WinGet para instalar **Claude Code CLI**, la aplicación de terminal de Anthropic.

1. **Descarga y extrae el ZIP.** Tras verificar su origen, abre sus Propiedades. Si Windows muestra **Desbloquear** y tu organización autoriza el paquete, marca esa opción antes de elegir **Extraer todo**.
2. **Haz doble clic en Instalar.cmd.** Elige o crea tu carpeta de trabajo, por ejemplo **Documentos / Revisión comercial**. El instalador detecta Claude Code, lo instala con WinGet si hace falta y configura los agentes del proyecto. Atiende cualquier aviso que muestre WinGet.
3. **Abre el acceso directo en el escritorio.** Se llama **Claude Code - Revisión comercial** si usaste ese nombre de carpeta. Abre la terminal dentro del proyecto con Opus. En el primer uso, sigue el inicio de sesión de Anthropic con tu propia cuenta.
4. **Pide tu primer análisis.** Copia una exportación en la carpeta del proyecto y escribe tu pedido en la terminal. Más abajo encontrarás un ejemplo con datos ficticios.

Para añadir otro proyecto, repite el paso 2 y elige otra carpeta. Tendrás un acceso directo para cada proyecto. Si el equipo ya tiene la CLI, el instalador reutiliza esa instalación.

También puedes ejecutar el instalador desde PowerShell:
```powershell
powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File .\Instalar.ps1 -Proyecto "C:\ruta a tu proyecto"
```
La ruta debe corresponder a una carpeta existente.

## Qué instala

| Archivo del proyecto | Función |
| --- | --- |
| `.claude/agents/explore.md` | Define Explore con Haiku y herramientas de lectura. |
| `.claude/agents/implementer.md` | Define implementer con Sonnet para cálculos, cambios y pruebas. |
| `.claude/rules/gb-advisors.md` | Guarda las instrucciones de delegación junto a las demás reglas del proyecto. |
| `Abrir Claude.cmd` | Abre Claude en esta carpeta con `claude --model opus`. |

Puedes volver a ejecutar el instalador. Si detecta que uno de los cuatro destinos ya contiene otra versión, te indica la ruta antes de copiar archivos. Si ya configuraste Explore o implementer a mano, compara las definiciones o prueba el kit en otra carpeta. Tu CLAUDE.md conserva su contenido. Para retirar la configuración de un proyecto, elimina su acceso directo y los archivos de la lista que haya añadido el kit. Claude Code seguirá disponible para otros proyectos.

## Si la instalación se detiene

- **Falta WinGet:** instala o actualiza *Instalador de aplicaciones* de Microsoft, abre una ventana nueva y vuelve a ejecutar el instalador.
- **Windows bloquea el script:** sigue el procedimiento de tu equipo de TI para ejecutar scripts internos.
- **La terminal no encuentra Claude después de instalarlo:** abre una ventana nueva de PowerShell y comprueba `claude --version`. Si funciona, vuelve a abrir el acceso directo.
- **Opus no está disponible:** comprueba con tu administrador el acceso de tu cuenta. Puedes consultar el modelo activo con `/model`.

## Primera prueba en cinco minutos

Guarda las líneas siguientes como `casos.csv` en la carpeta de un proyecto de prueba.

```csv
caso,cliente,prioridad,estado
GB-101,Norte,Alta,Abierto
GB-102,Norte,Critica,Abierto
GB-103,Sur,Alta,Cerrado
```

Pide en Claude: **«Busca el CSV de casos y dime a qué cliente conviene llamar primero. Cuenta los casos abiertos por cliente, indica su prioridad y cita sus identificadores».**

Con estos datos ficticios, el resultado esperado es Norte con dos casos abiertos, uno crítico y otro de prioridad alta. Para probar expresamente los dos agentes, añade: **«Usa Explore para localizar el CSV e implementer para calcular y comprobar el resultado»**. Durante la ejecución, `/tasks` permite inspeccionar los agentes en versiones compatibles.

## Uso comercial y consumo

**ServiceNow:** «Revisa la exportación de casos abiertos. Prioriza los críticos y, a igual prioridad, los que llevan más días sin actualización. Dame las tres cuentas a contactar, con el número de caso y una pregunta para soporte».

**Ventas:** «Compara los dos últimos meses completos de facturación por cliente y moneda. Comprueba los totales y explica qué tres clientes contribuyeron más al cambio».

Opus decide qué delegar según el pedido. Cada agente también consume tokens. Para evaluar el beneficio, ejecuta el mismo encargo sobre la misma copia de los datos en dos sesiones nuevas, una con Opus trabajando directamente y otra con delegación. Anota los datos disponibles en `/usage` según el plan, el tiempo y cualquier error en el resultado.

## Dónde guardar los reportes

Guarda tus Excel y exportaciones de ServiceNow en la carpeta de trabajo que elegiste al instalar. El ejemplo anterior usa datos ficticios para que puedas probar el flujo antes de trabajar con tus propios reportes.

### Documentación de Anthropic

[Instalación en Windows](https://code.claude.com/docs/en/setup) · [Subagentes](https://code.claude.com/docs/en/sub-agents) · [Reglas del proyecto](https://code.claude.com/docs/en/memory) · [Uso y costos](https://code.claude.com/docs/en/costs)
