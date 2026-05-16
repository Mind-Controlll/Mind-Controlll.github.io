$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

$ContentPath = Join-Path $Root "content"
$PostsPath = Join-Path $ContentPath "posts"
$TemplatePath = Join-Path $Root "src/templates/layout.html"
$StylePath = Join-Path $Root "src/styles/carbon.css"
$PostImagesPath = Join-Path $PostsPath "images"

$DistPath = Join-Path $Root "dist"
$AssetsOutPath = Join-Path $DistPath "assets"

function ConvertTo-HtmlText {
  param([AllowNull()][string]$Text)

  if ($null -eq $Text) {
    return ""
  }

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

function Get-Post {
  param([string]$Path)

  $Lines = Get-Content -Encoding utf8 -LiteralPath $Path

  $Title = Get-MetaValue -Lines $Lines -Key "title"
  $Date = Get-MetaValue -Lines $Lines -Key "date"
  $Slug = Get-MetaValue -Lines $Lines -Key "slug"
  $Summary = Get-MetaValue -Lines $Lines -Key "summary"
  $Tags = Get-MetaValue -Lines $Lines -Key "tags"

  if ($Title -eq "") { $Title = [System.IO.Path]::GetFileNameWithoutExtension($Path) }
  if ($Date -eq "") { $Date = "Unknown date" }
  if ($Slug -eq "") { $Slug = [System.IO.Path]::GetFileNameWithoutExtension($Path).ToLowerInvariant() }
  if ($Summary -eq "") { $Summary = "" }
  if ($Tags -eq "") { $Tags = "" }

  return [pscustomobject]@{
    Path = $Path
    Title = $Title
    Date = $Date
    Slug = $Slug
    Summary = $Summary
    Tags = $Tags
    BodyHtml = Convert-TypstBodyToHtml -Lines $Lines
  }
}

function New-SitePage {
  param(
    [string]$Title,
    [string]$Summary,
    [string]$Content
  )

  $Page = $Template
  $Page = $Page.Replace("{{title}}", (ConvertTo-HtmlText $Title))
  $Page = $Page.Replace("{{summary}}", (ConvertTo-HtmlText $Summary))
  $Page = $Page.Replace("{{content}}", $Content)

  return $Page
}

function Write-SitePage {
  param(
    [string]$Path,
    [string]$Title,
    [string]$Summary,
    [string]$Content
  )

  $OutDir = Split-Path -Parent $Path
  New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
  Set-Content -Encoding utf8 -LiteralPath $Path -Value (New-SitePage -Title $Title -Summary $Summary -Content $Content)
}

function Write-RedirectPage {
  param(
    [string]$Path,
    [string]$Target,
    [string]$Title
  )

  $OutDir = Split-Path -Parent $Path
  New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

  $Html = @"
<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta http-equiv="refresh" content="0; url=$Target">
  <title>$Title / Mind Controlll</title>
</head>
<body>
  <p><a href="$Target">Continue</a></p>
</body>
</html>
"@

  Set-Content -Encoding utf8 -LiteralPath $Path -Value $Html
}

function Copy-PostImages {
  param([string]$TargetDir)

  if (-not (Test-Path -LiteralPath $PostImagesPath)) {
    return
  }

  $ImageOutDir = Join-Path $TargetDir "images"
  New-Item -ItemType Directory -Force -Path $ImageOutDir | Out-Null
  Get-ChildItem -Force -LiteralPath $PostImagesPath | Copy-Item -Recurse -Force -Destination $ImageOutDir
}

function New-PostListHtml {
  param([object[]]$Posts)

  $Html = New-Object System.Collections.Generic.List[string]
  $Years = $Posts | ForEach-Object {
    if ($_.Date.Length -ge 4) {
      $_.Date.Substring(0, 4)
    } else {
      "Unknown"
    }
  } | Select-Object -Unique

  foreach ($Year in $Years) {
    $Html.Add("<h2>$Year</h2>")
    $Html.Add("<ol class=`"post-list`">")

    foreach ($Post in ($Posts | Where-Object {
      if ($_.Date.Length -ge 4) {
        $_.Date.Substring(0, 4) -eq $Year
      } else {
        $Year -eq "Unknown"
      }
    })) {
      $Title = ConvertTo-HtmlText $Post.Title
      $Date = ConvertTo-HtmlText $Post.Date
      $Summary = ConvertTo-HtmlText $Post.Summary
      $Url = "/posts/$($Post.Slug)/"

      $Html.Add("<li>")
      $Html.Add("  <time datetime=`"$Date`">$Date</time>")
      $Html.Add("  <a href=`"$Url`">$Title</a>")
      if ($Summary -ne "") {
        $Html.Add("  <p>$Summary</p>")
      }
      $Html.Add("</li>")
    }

    $Html.Add("</ol>")
  }

  return ($Html -join "`n")
}

if (-not (Test-Path $PostsPath)) {
  throw "Posts folder not found: $PostsPath"
}

if (-not (Test-Path $TemplatePath)) {
  throw "Template file not found: $TemplatePath"
}

if (-not (Test-Path $StylePath)) {
  throw "Style file not found: $StylePath"
}

$Template = Get-Content -Raw -Encoding utf8 -LiteralPath $TemplatePath
$PostFiles = Get-ChildItem -File -LiteralPath $PostsPath -Filter "*.typ"

if ($PostFiles.Count -eq 0) {
  throw "No .typ posts found in: $PostsPath"
}

$Posts = @($PostFiles | ForEach-Object { Get-Post -Path $_.FullName } | Sort-Object Date -Descending)
$FirstPost = $Posts[0]
$PostListHtml = New-PostListHtml -Posts $Posts

if (Test-Path -LiteralPath $DistPath) {
  Remove-Item -Recurse -Force -LiteralPath $DistPath
}

New-Item -ItemType Directory -Force -Path $AssetsOutPath | Out-Null
Copy-Item -Force -LiteralPath $StylePath -Destination (Join-Path $AssetsOutPath "carbon.css")
New-Item -ItemType File -Force -Path (Join-Path $DistPath ".nojekyll") | Out-Null

foreach ($Post in $Posts) {
  $PostOutDir = Join-Path $DistPath "posts/$($Post.Slug)"
  $TagsText = if ($Post.Tags -ne "") { " · $($Post.Tags)" } else { "" }
  $PostContent = @"
<article class="post-content">
  <p class="page-label">Blog</p>
  <h1>$((ConvertTo-HtmlText $Post.Title))</h1>
  <p class="post-meta">$((ConvertTo-HtmlText $Post.Date))$((ConvertTo-HtmlText $TagsText))</p>
  $($Post.BodyHtml)
</article>
"@

  Write-SitePage `
    -Path (Join-Path $PostOutDir "index.html") `
    -Title $Post.Title `
    -Summary $Post.Summary `
    -Content $PostContent

  Copy-PostImages -TargetDir $PostOutDir
}

$HomeContent = @"
<section class="home-hero">
  <p class="page-label">Home</p>
  <h1>Mind-Controlll</h1>
  <p>你好，我会在这里记录从材料专业转向计算机学习的过程，包括课程、实验、项目和阶段性总结。</p>
</section>

<section class="home-grid" aria-label="站点入口">
  <a class="home-card" href="/Docs/">
    <span>Docs</span>
    <strong>学习笔记</strong>
    <small>课程笔记、实验记录和项目文档。</small>
  </a>
  <a class="home-card" href="/Blog/">
    <span>Blog</span>
    <strong>学习记录</strong>
    <small>按年份整理文章和项目复盘。</small>
  </a>
  <a class="home-card" href="/CV/">
    <span>CV</span>
    <strong>关于我</strong>
    <small>个人简介、背景和学习目标。</small>
  </a>
</section>

<section class="post-content">
  <h2>最近更新</h2>
  $PostListHtml
</section>
"@

Write-SitePage `
  -Path (Join-Path $DistPath "index.html") `
  -Title "Home" `
  -Summary "Mind-Controlll 的个人博客首页。" `
  -Content $HomeContent

$DocsContent = @"
<article class="post-content">
  <p class="page-label">Docs</p>
  <h1>文档 / Docs</h1>
  <p>这里会整理课程笔记、实验记录和项目文档。</p>
</article>
"@

Write-SitePage `
  -Path (Join-Path $DistPath "Docs/index.html") `
  -Title "Docs" `
  -Summary "Mind-Controlll 的学习文档。" `
  -Content $DocsContent

$BlogContent = @"
<article class="post-content">
  <p class="page-label">Blog</p>
  <h1>博客 / Blog</h1>
  <p>文章按年份归档，记录学习过程、阶段总结和项目复盘。</p>
  $PostListHtml
</article>
"@

Write-SitePage `
  -Path (Join-Path $DistPath "Blog/index.html") `
  -Title "Blog" `
  -Summary "Mind-Controlll 的文章列表。" `
  -Content $BlogContent

$CvOutDir = Join-Path $DistPath "CV"
$CvContent = @"
<article class="post-content">
  <p class="page-label">CV</p>
  <h1>关于我 / CV</h1>
  $($FirstPost.BodyHtml)
</article>
"@

Write-SitePage `
  -Path (Join-Path $CvOutDir "index.html") `
  -Title "CV" `
  -Summary $FirstPost.Summary `
  -Content $CvContent

Copy-PostImages -TargetDir $CvOutDir

Write-RedirectPage `
  -Path (Join-Path $DistPath "about/index.html") `
  -Target "/CV/" `
  -Title "About"

Write-Host "Build succeeded."
Write-Host "Generated: $DistPath"
Write-Host "Home: /"
Write-Host "Docs: /Docs/"
Write-Host "Blog: /Blog/"
Write-Host "CV: /CV/"




