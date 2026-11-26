[CmdletBinding()]
param([string]$Proyecto)
$ErrorActionPreference = 'Stop'

if (-not $Proyecto) {
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = 'Elige o crea la carpeta del proyecto para Claude Code'
    try {
        if ($dialog.ShowDialog() -ne 'OK') { return }
        $Proyecto = $dialog.SelectedPath
    } finally { $dialog.Dispose() }
}
$folder = Get-Item -LiteralPath $Proyecto
if (-not $folder.PSIsContainer -or $folder.PSProvider.Name -ne 'FileSystem') {
    throw 'Selecciona una carpeta de Windows.'
}
$root = $folder.FullName
$files = [ordered]@{
    'Explore.md' = '.claude\agents\explore.md'
    'implementer.md' = '.claude\agents\implementer.md'
    'delegacion.md' = '.claude\rules\gb-advisors.md'
    'Abrir Claude.cmd' = 'Abrir Claude.cmd'
}
$pending = @()
foreach ($item in $files.GetEnumerator()) {
    $source = Join-Path (Join-Path $PSScriptRoot 'plantilla') $item.Key
    $target = Join-Path $root $item.Value
    $expected = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
    if (Test-Path -LiteralPath $target) {
        if (-not (Test-Path -LiteralPath $target -PathType Leaf) -or
            (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash -ne $expected) {
            throw "Ya existe una version diferente de $target. Elige otro proyecto o compara los archivos."
        }
    } else {
        $pending += [pscustomobject]@{ Source = $source; Target = $target }
    }
}
foreach ($file in $pending) {
    $parent = [IO.Path]::GetDirectoryName($file.Target)
    [void][IO.Directory]::CreateDirectory($parent)
    [IO.File]::Copy($file.Source, $file.Target, $false)
}
Write-Host "Proyecto configurado: $root"
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Host 'Claude Code requiere una instalacion por equipo. En PowerShell ejecuta:'
    Write-Host 'winget install Anthropic.ClaudeCode'
}
Write-Host 'Para empezar, abre Abrir Claude.cmd dentro de tu proyecto.'
