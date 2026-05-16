$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

$PostPath = Join-Path $Root "content/posts/Self_Intro.typ"
$TemplatePath = Join-Path $Root "src/templates/layout.html"
$StylePath = Join-Path $Root "src/styles/carbon.css"
$PostImagesPath = Join-Path $Root "content/posts/images"


$DistPath = Join-Path $Root "dist"
$AssetsOutPath = Join-Path $DistPath "assets"
$PostOutDir = Join-Path $DistPath "posts/self-intro"
$PostOutPath = Join-Path $PostOutDir "index.html"
$HomeOutPath = Join-Path $DistPath "index.html"

function ConvertTo-HtmlText {
  param([string]$Text)

  return [System.Net.WebUtility]::HtmlEncode($Text)
}

function Get-MetaValue {
  param(
    [string[]]$Lines,
    [string]$Key
  )

  $Pattern = "^//\s*$([regex]::Escape($Key)):\s*(.+)$"

  foreach ($Line in $Lines) {
    if ($Line -match $Pattern) {
      return $Matches[1].Trim()
    }
  }

  return ""
}

function Convert-TypstBodyToHtml {
  param([string[]]$Lines)

  $Html = New-Object System.Collections.Generic.List[string]
  $InList = $false

  foreach ($Line in $Lines) {
    $Trimmed = $Line.Trim()

    if ($Trimmed -eq "") {
      if ($InList) {
        $Html.Add("</ul>")
        $InList = $false
      }
      continue
    }

    if ($Trimmed.StartsWith("//")) {
      continue
    }

    if ($Trimmed.StartsWith("= ")) {
      if ($InList) {
        $Html.Add("</ul>")
        $InList = $false
      }

      $Text = ConvertTo-HtmlText $Trimmed.Substring(2).Trim()
      $Html.Add("<h2>$Text</h2>")
      continue
    }

    if ($Trimmed.StartsWith("- ")) {
      if (-not $InList) {
        $Html.Add("<ul>")
        $InList = $true
      }

      $Text = ConvertTo-HtmlText $Trimmed.Substring(2).Trim()
      $Html.Add("<li>$Text</li>")
      continue
    }

    if ($InList) {
      $Html.Add("</ul>")
      $InList = $false
    }

    if ($Trimmed -match '^#image\("([^"]+)"') {
      $Src = ConvertTo-HtmlText $Matches[1]
      $Html.Add("<img src=`"$Src`" alt=`"`">")
      continue
    }

    $Paragraph = ConvertTo-HtmlText $Trimmed
    $Html.Add("<p>$Paragraph</p>")
  }

  if ($InList) {
    $Html.Add("</ul>")
  }

  return ($Html -join "`n")
}


if (-not (Test-Path $PostPath)) {
  throw "Post file not found: $PostPath"
}

if (-not (Test-Path $TemplatePath)) {
  throw "Template file not found: $TemplatePath"
}

if (-not (Test-Path $StylePath)) {
  throw "Style file not found: $StylePath"
}

$Lines = Get-Content -Encoding utf8 -LiteralPath $PostPath

$Title = Get-MetaValue -Lines $Lines -Key "title"
$Date = Get-MetaValue -Lines $Lines -Key "date"
$Slug = Get-MetaValue -Lines $Lines -Key "slug"
$Summary = Get-MetaValue -Lines $Lines -Key "summary"
$Tags = Get-MetaValue -Lines $Lines -Key "tags"

if ($Title -eq "") { $Title = "Untitled" }
if ($Date -eq "") { $Date = "Unknown date" }
if ($Slug -eq "") { $Slug = "self-intro" }
if ($Summary -eq "") { $Summary = "" }
if ($Tags -eq "") { $Tags = "" }

$PostOutDir = Join-Path $DistPath "posts/$Slug"
$PostOutPath = Join-Path $PostOutDir "index.html"

$BodyHtml = Convert-TypstBodyToHtml -Lines $Lines
$Template = Get-Content -Raw -Encoding utf8 -LiteralPath $TemplatePath

$PageHtml = $Template
$PageHtml = $PageHtml.Replace("{{title}}", (ConvertTo-HtmlText $Title))
$PageHtml = $PageHtml.Replace("{{date}}", (ConvertTo-HtmlText $Date))
$PageHtml = $PageHtml.Replace("{{summary}}", (ConvertTo-HtmlText $Summary))
$PageHtml = $PageHtml.Replace("{{tags}}", (ConvertTo-HtmlText $Tags))
$PageHtml = $PageHtml.Replace("{{content}}", $BodyHtml)

New-Item -ItemType Directory -Force -Path $AssetsOutPath | Out-Null
New-Item -ItemType Directory -Force -Path $PostOutDir | Out-Null

Copy-Item -Force -LiteralPath $StylePath -Destination (Join-Path $AssetsOutPath "carbon.css")
if (Test-Path -LiteralPath $PostImagesPath) {
  Copy-Item -Recurse -Force -LiteralPath $PostImagesPath -Destination (Join-Path $PostOutDir "images")
}


Set-Content -Encoding utf8 -LiteralPath $PostOutPath -Value $PageHtml

$HomeHtml = @"
<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta http-equiv="refresh" content="0; url=/posts/$Slug/">
  <title>Mind Controlll</title>
</head>
<body>
  <p><a href="/posts/$Slug/">Enter blog</a></p>
</body>
</html>
"@

Set-Content -Encoding utf8 -LiteralPath $HomeOutPath -Value $HomeHtml

Write-Host "Build succeeded."
Write-Host "Generated: $PostOutPath"
Write-Host "Generated: $HomeOutPath"
