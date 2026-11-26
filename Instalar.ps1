[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'

$documents = [Environment]::GetFolderPath('MyDocuments', 'Create')
if (-not $documents) { throw 'Windows no pudo localizar la carpeta Documentos de este usuario.' }
$root = Join-Path $documents 'CliGB'
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
        # El lanzador del primer kit tambien abre este proyecto con Opus.
        if ($item.Key -eq 'Abrir Claude.cmd' -and (Test-Path -LiteralPath $target -PathType Leaf) -and
            (Get-FileHash -LiteralPath $target).Hash -eq '36A68BBBFBB6CF7611921B37C78555241E7CFA63545023F4B5904D0DCFA2AE06') {
            continue
        }
        if (-not (Test-Path -LiteralPath $target -PathType Leaf) -or
            (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash -ne $expected) {
            throw "Ya existe una version diferente de $target. Compara ese archivo con la plantilla antes de instalar."
        }
    } else {
        $pending += [pscustomobject]@{ Source = $source; Target = $target }
    }
}
if (-not (Get-Command claude.exe -CommandType Application -ErrorAction SilentlyContinue)) {
    $winget = Get-Command winget.exe -CommandType Application -ErrorAction SilentlyContinue
    if (-not $winget) {
        throw 'Falta WinGet. Instala o actualiza Instalador de aplicaciones de Microsoft y vuelve a abrir Instalar.cmd.'
    }
    Write-Host 'Instalando Claude Code de terminal mediante WinGet...'
    & $winget.Source install --id Anthropic.ClaudeCode --exact --source winget
    if ($LASTEXITCODE -ne 0) {
        throw "WinGet devolvio el codigo $LASTEXITCODE. Revisa su mensaje y vuelve a ejecutar el instalador."
    }
}
foreach ($file in $pending) {
    $parent = [IO.Path]::GetDirectoryName($file.Target)
    [void][IO.Directory]::CreateDirectory($parent)
    [IO.File]::Copy($file.Source, $file.Target, $false)
}
$desktop = [Environment]::GetFolderPath('DesktopDirectory')
if (-not $desktop -or -not [IO.Directory]::Exists($desktop)) {
    throw "No se pudo localizar el Escritorio. Puedes usar Abrir Claude.cmd dentro de $root."
}
$launcher = Join-Path $root 'Abrir Claude.cmd'
$shell = New-Object -ComObject WScript.Shell
$baseName = 'Claude Code - CliGB'
$name = $baseName
$number = 1
do {
    $shortcutPath = Join-Path $desktop ($name + '.lnk')
    $shortcut = $shell.CreateShortcut($shortcutPath)
    if (-not [IO.File]::Exists($shortcutPath) -or $shortcut.TargetPath -eq $launcher) { break }
    $number++
    $name = "$baseName ($number)"
} while ($true)
$shortcut.TargetPath = $launcher
$shortcut.WorkingDirectory = $root
$shortcut.Description = 'Abrir Claude Code en la terminal de este proyecto con Opus'
$shortcut.Save()
Write-Host "Proyecto configurado: $root"
Write-Host "Acceso directo en el Escritorio: $shortcutPath"
