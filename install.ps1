param(
    [string]$SourceTheme = (Join-Path $env:USERPROFILE '.t3/userdata/themes/koi-pond.json'),
    [string]$ThemesDirectory = (Join-Path $env:USERPROFILE '.t3/userdata/themes')
)

$ErrorActionPreference = 'Stop'
$original = Get-Content -LiteralPath $SourceTheme -Raw | ConvertFrom-Json
$assets = [regex]::Matches($original.css, 'data:image/svg\+xml,[^"]+')
if ($original.id -ne 'koi-pond' -or $assets.Count -ne 2) {
    throw 'Provide the original Koi Pond theme JSON from T3 Themes.'
}

$pond = $assets[0].Value
$fishRule = '.f{font-size:var(--a);'
if (!$pond.Contains($fishRule)) { throw 'The Koi Pond artwork format has changed.' }
$culture = [Globalization.CultureInfo]::InvariantCulture
$quietPond = [regex]::Replace($pond.Replace($fishRule, '.f{display:none;font-size:var(--a);'),
    '(?<![\w.])(-?\d+(?:\.\d+)?)s\b', [System.Text.RegularExpressions.MatchEvaluator]{
        param($match)
        $seconds = [double]::Parse($match.Groups[1].Value, $culture)
        ($seconds * 1.25).ToString('0.########', $culture) + 's'
    })

New-Item -ItemType Directory -Path $ThemesDirectory -Force | Out-Null
foreach ($template in Get-ChildItem -LiteralPath $PSScriptRoot -Filter '*.template.json') {
    $theme = Get-Content -LiteralPath $template.FullName -Raw | ConvertFrom-Json -AsHashtable
    $art = $pond
    if ($theme.id -eq 'koi-pond-chat-background-no-fish') { $art = $quietPond }
    $theme.css = $theme.css.Replace('__POND_ART__', $art).Replace('__POND_FILTER__', $assets[1].Value)
    $destination = Join-Path $ThemesDirectory ($theme.id + '.json')
    $temporary = Join-Path $ThemesDirectory ([guid]::NewGuid().ToString() + '.tmp')
    $theme | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $temporary -Encoding utf8NoBOM
    [IO.File]::Move($temporary, $destination, $true)
}
