@echo off
setlocal
pushd "%~dp0" || exit /b 1
powershell.exe -NoProfile -Command "$cli = Get-Command claude.exe -CommandType Application -ErrorAction SilentlyContinue; if (-not $cli) { Write-Host 'Windows aun no encuentra Claude Code. Abre una terminal nueva y comprueba claude --version.'; exit 1 }; & $cli.Source --model opus; exit $LASTEXITCODE"
set "claudeResult=%errorlevel%"
popd
if not "%claudeResult%"=="0" pause
exit /b %claudeResult%
