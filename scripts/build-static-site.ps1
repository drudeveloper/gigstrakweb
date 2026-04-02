param(
    [string]$OutputDir = "build/static-site"
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$templatesDir = Join-Path $repoRoot "src/main/resources/templates"
$staticDir = Join-Path $repoRoot "src/main/resources/static"
$resolvedOutputDir = Join-Path $repoRoot $OutputDir

if (Test-Path $resolvedOutputDir) {
    Remove-Item $resolvedOutputDir -Recurse -Force
}

New-Item -ItemType Directory -Path $resolvedOutputDir | Out-Null
Copy-Item (Join-Path $staticDir "*") $resolvedOutputDir -Recurse -Force

$templateMappings = @(
    @{ Source = "index.html"; Target = "index.html" },
    @{ Source = "about.html"; Target = "about/index.html" },
    @{ Source = "contact.html"; Target = "contact/index.html" },
    @{ Source = "privacy.html"; Target = "privacy/index.html" },
    @{ Source = "terms.html"; Target = "terms/index.html" }
)

$linkReplacements = @{
    'th:href="@{/}"' = 'href="/"'
    'th:href="@{/about}"' = 'href="/about/"'
    'th:href="@{/contact}"' = 'href="/contact/"'
    'th:href="@{/privacy}"' = 'href="/privacy/"'
    'th:href="@{/terms}"' = 'href="/terms/"'
    'th:href="@{/css/site.css}"' = 'href="/css/site.css"'
    'th:href="@{/images/appicon.png}"' = 'href="/images/appicon.png"'
    'th:src="@{/images/appicon.png}"' = 'src="/images/appicon.png"'
    'th:src="@{/images/google-play-badge.svg}"' = 'src="/images/google-play-badge.svg"'
    'th:src="@{/images/apple-store-badge.svg}"' = 'src="/images/apple-store-badge.svg"'
}

foreach ($mapping in $templateMappings) {
    $sourcePath = Join-Path $templatesDir $mapping.Source
    $targetPath = Join-Path $resolvedOutputDir $mapping.Target
    $targetDir = Split-Path $targetPath -Parent

    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

    $content = Get-Content $sourcePath -Raw
    $content = $content -replace '\s+xmlns:th="http://www\.thymeleaf\.org"', ""

    foreach ($replacement in $linkReplacements.GetEnumerator()) {
        $content = $content.Replace($replacement.Key, $replacement.Value)
    }

    Set-Content -Path $targetPath -Value $content -Encoding UTF8
}

Write-Host "Static site generated at $resolvedOutputDir"
