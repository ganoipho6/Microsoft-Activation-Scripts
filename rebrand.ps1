$files = Get-ChildItem -Path "MAS" -Recurse -Include *.cmd, *.txt, *.md, *.html

$replacements = @(
    @{ Old = 'set "mas=ht%blank%tps%blank%://m%blank%ass%blank%grave.dev/"'; New = 'set "mas=about:blank"' },
    @{ Old = 'set "github=ht%blank%tps%blank%://github.com/m%blank%assgra%blank%vel/Micro%blank%soft-Acti%blank%vation-Scripts"'; New = 'set "github=about:blank"' },
    @{ Old = 'set "selfgit=ht%blank%tps%blank%://git.acti%blank%vated.win/Micr%blank%osoft-Act%blank%ivation-Scripts"'; New = 'set "selfgit=about:blank"' },
    @{ Old = '::   Homepage: m{}assgrave{dot}dev'; New = '::   Homepage: HLCOM - BY Ganoipho6' },
    @{ Old = 'mass%-%grave.dev'; New = 'localhost' },
    @{ Old = 'activ%-%ated.win'; New = 'localhost' },
    @{ Old = 'title  Microsoft_Activation_Scripts'; New = 'title  HLCOM - BY Ganoipho6' },
    @{ Old = 'title  TSforge Activation'; New = 'title  HLCOM - BY Ganoipho6' },
    @{ Old = 'title  HWID Activation'; New = 'title  HLCOM - BY Ganoipho6' },
    @{ Old = 'title  Ohook Activation'; New = 'title  HLCOM - BY Ganoipho6' },
    @{ Old = 'title  Online %KS% Activation'; New = 'title  HLCOM - BY Ganoipho6' },
    @{ Old = 'title  Microsoft %blank%Activation %blank%Scripts'; New = 'title  HLCOM - BY Ganoipho6' },
    @{ Old = 'Windows Addict'; New = 'Ganoipho6' },
    @{ Old = 'https://massgrave.dev'; New = '#' },
    @{ Old = 'https://discord.gg/j2yFsV5ZVC'; New = '#' },
    @{ Old = 'https://github.com/massgravel'; New = '#' },
    @{ Old = 'massgrave'; New = 'HLCOM' }
)

foreach ($file in $files) {
    Write-Host "Processing $($file.FullName)..."
    $content = [System.IO.File]::ReadAllText($file.FullName)
    $originalContent = $content
    
    foreach ($pair in $replacements) {
        $content = $content.Replace($pair.Old, $pair.New)
    }

    if ($content -ne $originalContent) {
        [System.IO.File]::WriteAllText($file.FullName, $content)
        Write-Host "Updated $($file.Name)" -ForegroundColor Green
    }
}
