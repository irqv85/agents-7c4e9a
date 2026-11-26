@echo off
setlocal
pushd "%~dp0" || exit /b 1
where claude >nul 2>nul
if errorlevel 1 (
    echo Instala Claude Code en PowerShell con:
    echo winget install Anthropic.ClaudeCode
    echo Luego cierra esta ventana y vuelve a abrir este archivo.
    pause
    exit /b 1
)
call claude --model opus
set "claudeResult=%errorlevel%"
popd
if not "%claudeResult%"=="0" pause
exit /b %claudeResult%
