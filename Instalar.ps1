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
    'settings.json' = '.claude\settings.json'
}
# Versiones que instalaron kits anteriores (con LF del ZIP o CRLF de un clon).
# Si el destino coincide con una de ellas se actualiza; si no, es una edicion
# propia del usuario y no se toca.
$previous = @{
    'Explore.md' = @('1ABB646CDB1D9E809DAC7C51AF0E35EF4613BAECD7EF6ADF4355F27D6739A0AC',
                     'F997C57029E5D4825C90D92BB7B6EFA1129F77313A62477C1A6FA8E55B78DBCD')
    'implementer.md' = @('FFDED4E391914030F9A66D2C40E6D12A37BC20F2E9373A240976FC300EAD4710',
                         '17BDCE4272708F8077992DC9BC2FF51009E57A9906FED9E64F43DF6FE75C005E')
    'delegacion.md' = @('9306789795BD27A03CBCD97B7437A4E029C8C4E7D208CB80D158B02DEC8EC79C',
                        '72AD2A9DE9D6AC62D17C92E4B4F8B6D059186D32D3B147C6949591E9EA24860B')
    'Abrir Claude.cmd' = @('36A68BBBFBB6CF7611921B37C78555241E7CFA63545023F4B5904D0DCFA2AE06')
}
$pending = @()
foreach ($item in $files.GetEnumerator()) {
    $source = Join-Path (Join-Path $PSScriptRoot 'plantilla') $item.Key
    $target = Join-Path $root $item.Value
    $expected = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
    if (Test-Path -LiteralPath $target) {
        if (-not (Test-Path -LiteralPath $target -PathType Leaf)) {
            throw "$target es una carpeta. Revisala antes de instalar."
        }
        $current = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash
        if ($current -eq $expected) { continue }
        if ($previous.ContainsKey($item.Key) -and $current -in $previous[$item.Key]) {
            $pending += [pscustomobject]@{ Source = $source; Target = $target }
            continue
        }
        throw "Ya existe una version diferente de $target. Compara ese archivo con la plantilla antes de instalar."
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
    [IO.File]::Copy($file.Source, $file.Target, $true)
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
