# Claude Code para proyectos de GB Advisors

Kit para configurar Claude Code en una carpeta de Windows. Puedes pedir en español «¿Qué clientes tienen casos críticos abiertos?» y dejar que Opus coordine el análisis. Haiku localiza los archivos y Sonnet calcula las métricas. Opus revisa las cifras antes de recomendar a quién llamar.

**[Descargar el kit para Windows (.zip)](https://github.com/irqv85/gb-advisors-claude-windows/archive/refs/heads/main.zip)**

Necesitas Windows, PowerShell y una cuenta de Claude Code con acceso a Opus, Haiku y Sonnet. Si todavía no tienes la aplicación de terminal, el paso 3 explica cómo instalarla.

## Instalar en un proyecto

1. Descarga el ZIP con el enlace anterior. Tras verificar su origen, abre sus **Propiedades**. Si Windows muestra **Desbloquear** y tu organización autoriza el paquete, marca esa opción antes de **Extraer todo**.
2. Abre **Instalar.cmd** en la carpeta extraída. Selecciona o crea la carpeta donde trabajarás con tus documentos, por ejemplo **Documentos / Revisión comercial**. Si Windows aplica una política corporativa de ejecución, usa el procedimiento de TI para scripts internos.
3. Si aún necesitas instalar Claude Code, abre PowerShell, ejecuta `winget install Anthropic.ClaudeCode` y espera a que termine. Abre una nueva terminal y comprueba `claude --version`.
4. En **la carpeta del proyecto**, abre **Abrir Claude.cmd**. Inicia sesión con tu cuenta de trabajo y comprueba que el modelo de la sesión es Opus con `/model`. Cada persona necesita acceso a Claude Code y a los modelos utilizados. El instalador funciona sin credenciales y el inicio de sesión lo gestiona Claude Code.
5. Copia allí tus archivos de trabajo. En nuevos proyectos, repite el paso 2. Para crear un acceso directo en el escritorio, usa **Enviar a → Escritorio (crear acceso directo)** sobre el lanzador del proyecto.

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

Puedes volver a ejecutar el instalador. Si detecta que uno de los cuatro destinos ya contiene otra versión, te indica la ruta antes de copiar archivos. Si ya configuraste Explore o implementer a mano, compara las definiciones o prueba el kit en otra carpeta. Tu CLAUDE.md conserva su contenido. Para retirar el kit, elimina solo los archivos de esta lista que el kit haya añadido.

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
