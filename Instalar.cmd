@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -STA -File "%~dp0Instalar.ps1"
if errorlevel 1 echo No se completo la instalacion. Revisa el mensaje anterior y el README.
pause
