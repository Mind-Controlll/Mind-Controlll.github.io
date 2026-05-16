$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$ContentPath = Join-Path $Root "content"
$AssetsPath = Join-Path $Root "assets"
$TemplatePath = Join-Path $Root "src/templates/layout.html"
$StylePath = Join-Path $Root "src/styles/carbon.css"
$ConfigPath = Join-Path $Root "site.config.json"
$DistPath = Join-Path $Root "dist"
$AssetsOutPath = Join-Path $DistPath "assets"

function ConvertTo-HtmlText {
  param([AllowNull()][string]$Text)

  if ($null -eq $Text) {
    return ""
  }

  return [System.Net.WebUtility]::HtmlEncode($Text)
}

function ConvertTo-XmlText {
  param([AllowNull()][string]$Text)

  if ($null -eq $Text) {
    return ""
  }

  return [System.Security.SecurityElement]::Escape($Text)
}

function Convert-InlineMarkup {
  param([AllowNull()][string]$Text)

  if ($null -eq $Text) {
    return ""
  }

  $Placeholders = @{}
  $Prepared = $Text
  $Matches = [regex]::Matches($Text, '#link\("([^"]+)"\)\[([^\]]+)\]')
  $Index = 0

  foreach ($Match in $Matches) {
    $Token = "%%LINK_$Index%%"
    $Href = ConvertTo-HtmlText $Match.Groups[1].Value
    $Label = ConvertTo-HtmlText $Match.Groups[2].Value
    $Placeholders[$Token] = "<a href=`"$Href`">$Label</a>"
    $Prepared = $Prepared.Replace($Match.Value, $Token)
    $Index++
  }

  $Encoded = ConvertTo-HtmlText $Prepared
  $Encoded = [regex]::Replace($Encoded, '`([^`]+)`', '<code>$1</code>')

  foreach ($Token in $Placeholders.Keys) {
    $Encoded = $Encoded.Replace($Token, $Placeholders[$Token])
  }

  return $Encoded
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
  $InCode = $false

  foreach ($Line in $Lines) {
    $Trimmed = $Line.Trim()

    if ($InCode) {
      if ($Trimmed.StartsWith('```')) {
        $Html.Add("</code></pre>")
        $InCode = $false
      } else {
        $Html.Add((ConvertTo-HtmlText $Line))
      }
      continue
    }

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

    if ($Trimmed.StartsWith('```')) {
      if ($InList) {
        $Html.Add("</ul>")
        $InList = $false
      }

      $Language = ConvertTo-HtmlText ($Trimmed.Substring(3).Trim())
      $Class = if ($Language -ne "") { " class=`"language-$Language`"" } else { "" }
      $Html.Add("<pre><code$Class>")
      $InCode = $true
      continue
    }

    if ($Trimmed -match '^(=+)\s+(.+)$') {
      if ($InList) {
        $Html.Add("</ul>")
        $InList = $false
      }

      $Level = [Math]::Min($Matches[1].Length, 6)
      $Text = Convert-InlineMarkup $Matches[2].Trim()
      $Html.Add("<h$Level>$Text</h$Level>")
      continue
    }

    if ($Trimmed.StartsWith("- ")) {
      if (-not $InList) {
        $Html.Add("<ul>")
        $InList = $true
      }

      $Text = Convert-InlineMarkup $Trimmed.Substring(2).Trim()
      $Html.Add("<li>$Text</li>")
      continue
    }

    if ($InList) {
      $Html.Add("</ul>")
      $InList = $false
    }

    if ($Trimmed -eq "---") {
      $Html.Add("<hr>")
      continue
    }

    if ($Trimmed -match '^#image\("([^"]+)"') {
      $Src = ConvertTo-HtmlText $Matches[1]
      $Html.Add("<img src=`"$Src`" alt=`"`">")
      continue
    }

    $Paragraph = Convert-InlineMarkup $Trimmed
    $Html.Add("<p>$Paragraph</p>")
  }

  if ($InList) {
    $Html.Add("</ul>")
  }

  if ($InCode) {
    $Html.Add("</code></pre>")
  }

  return ($Html -join "`n")
}

function Get-RelativeContentDir {
  param([string]$Path)

  $FullContentPath = [System.IO.Path]::GetFullPath($ContentPath)
  $FullPath = [System.IO.Path]::GetFullPath($Path)
  $RelativeFile = $FullPath.Substring($FullContentPath.Length).TrimStart([char[]]@('\', '/'))
  $RelativeDir = Split-Path -Parent $RelativeFile

  if ($RelativeDir -eq "." -or $null -eq $RelativeDir) {
    return ""
  }

  return $RelativeDir.Replace('\', '/')
}

function Get-ContentPage {
  param([string]$Path)

  $Lines = Get-Content -Encoding utf8 -LiteralPath $Path
  $RelativeDir = Get-RelativeContentDir -Path $Path

  if ($RelativeDir -eq "") {
    $Url = "/"
    $Section = "Home"
  } else {
    $Url = "/$RelativeDir/"
    $Section = $RelativeDir.Split('/')[0]
  }

  $Title = Get-MetaValue -Lines $Lines -Key "title"
  $Description = Get-MetaValue -Lines $Lines -Key "description"
  $Date = Get-MetaValue -Lines $Lines -Key "date"
  $Tags = Get-MetaValue -Lines $Lines -Key "tags"

  if ($Title -eq "") { $Title = if ($RelativeDir -eq "") { "Home" } else { Split-Path -Leaf $RelativeDir } }
  if ($Description -eq "") { $Description = $Config.description }

  return [pscustomobject]@{
    Path = $Path
    RelativeDir = $RelativeDir
    Url = $Url
    Section = $Section
    Title = $Title
    Description = $Description
    Date = $Date
    Tags = $Tags
    ContentHtml = Convert-TypstBodyToHtml -Lines $Lines
  }
}

function Get-NavHtml {
  $Html = New-Object System.Collections.Generic.List[string]

  foreach ($Link in $Config.headerLinks.PSObject.Properties) {
    $Href = ConvertTo-HtmlText $Link.Name
    $Text = ConvertTo-HtmlText ([string]$Link.Value)
    $Html.Add("<a href=`"$Href`">$Text</a>")
  }

  return ($Html -join "`n        ")
}

function Get-HeaderHtml {
  $Html = New-Object System.Collections.Generic.List[string]
  $First = $true

  foreach ($Element in $Config.headerElements) {
    $Class = if ($First) { "site-greeting" } else { "site-description" }
    $Html.Add("<p class=`"$Class`">$((ConvertTo-HtmlText ([string]$Element)))</p>")
    $First = $false
  }

  return ($Html -join "`n      ")
}

function Get-FooterHtml {
  $Html = New-Object System.Collections.Generic.List[string]

  foreach ($Element in $Config.footerElements) {
    $Html.Add("<p>$((ConvertTo-HtmlText ([string]$Element)))</p>")
  }

  return ($Html -join "`n    ")
}

function Get-AbsoluteUrl {
  param([string]$Url)

  if ($Config.websiteUrl -eq "") {
    return $Url
  }

  return ($Config.websiteUrl.TrimEnd('/') + $Url)
}

function Get-AbsoluteImageUrl {
  param([string]$Url)

  if ($Url -match '^https?://') {
    return $Url
  }

  if ($Url.StartsWith('/')) {
    return (Get-AbsoluteUrl $Url)
  }

  return (Get-AbsoluteUrl "/$Url")
}

function New-SitePage {
  param(
    [string]$Title,
    [string]$Description,
    [string]$Url,
    [string]$Content
  )

  $Page = $Template
  $Page = $Page.Replace("{{lang}}", (ConvertTo-HtmlText $Config.lang))
  $Page = $Page.Replace("{{title}}", (ConvertTo-HtmlText $Title))
  $Page = $Page.Replace("{{site_title}}", (ConvertTo-HtmlText $Config.title))
  $Page = $Page.Replace("{{description}}", (ConvertTo-HtmlText $Description))
  $Page = $Page.Replace("{{canonical}}", (ConvertTo-HtmlText (Get-AbsoluteUrl $Url)))
  $Page = $Page.Replace("{{image}}", (ConvertTo-HtmlText (Get-AbsoluteImageUrl $Config.imagePath)))
  $Page = $Page.Replace("{{header_elements}}", (Get-HeaderHtml))
  $Page = $Page.Replace("{{nav_links}}", (Get-NavHtml))
  $Page = $Page.Replace("{{content}}", $Content)
  $Page = $Page.Replace("{{footer_elements}}", (Get-FooterHtml))

  return $Page
}

function Write-SitePage {
  param(
    [string]$OutputUrl,
    [string]$Title,
    [string]$Description,
    [string]$Content
  )

  $RelativePath = $OutputUrl.TrimStart('/').TrimEnd('/')
  if ($RelativePath -eq "") {
    $OutPath = Join-Path $DistPath "index.html"
  } else {
    $OutPath = Join-Path (Join-Path $DistPath $RelativePath) "index.html"
  }

  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutPath) | Out-Null
  Set-Content -Encoding utf8 -LiteralPath $OutPath -Value (New-SitePage -Title $Title -Description $Description -Url $OutputUrl -Content $Content)
}

function Write-RedirectPage {
  param(
    [string]$OutputUrl,
    [string]$Target,
    [string]$Title
  )

  $RelativePath = $OutputUrl.TrimStart('/').TrimEnd('/')
  $OutPath = Join-Path (Join-Path $DistPath $RelativePath) "index.html"
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutPath) | Out-Null

  $HtmlTitle = ConvertTo-HtmlText $Title
  $HtmlTarget = ConvertTo-HtmlText $Target

  $Html = @"
<!doctype html>
<html lang="$($Config.lang)">
<head>
  <meta charset="utf-8">
  <meta http-equiv="refresh" content="0; url=$HtmlTarget">
  <title>$HtmlTitle / $($Config.title)</title>
</head>
<body>
  <p><a href="$HtmlTarget">Continue</a></p>
</body>
</html>
"@

  Set-Content -Encoding utf8 -LiteralPath $OutPath -Value $Html
}

function New-PostListHtml {
  param([object[]]$Posts)

  if ($Posts.Count -eq 0) {
    return "<p>还没有文章。</p>"
  }

  $Html = New-Object System.Collections.Generic.List[string]
  $Years = $Posts | ForEach-Object {
    if ($_.Date.Length -ge 4) {
      $_.Date.Substring(0, 4)
    } else {
      "Unknown"
    }
  } | Select-Object -Unique

  foreach ($Year in $Years) {
    $Html.Add("<h2>$((ConvertTo-HtmlText $Year))</h2>")
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
      $Description = ConvertTo-HtmlText $Post.Description
      $Url = ConvertTo-HtmlText $Post.Url

      $Html.Add("<li>")
      if ($Date -ne "") {
        $Html.Add("  <time datetime=`"$Date`">$Date</time>")
      }
      $Html.Add("  <a href=`"$Url`">$Title</a>")
      if ($Description -ne "") {
        $Html.Add("  <p>$Description</p>")
      }
      $Html.Add("</li>")
    }

    $Html.Add("</ol>")
  }

  return ($Html -join "`n")
}

function Write-Sitemap {
  param([object[]]$Pages)

  $Items = New-Object System.Collections.Generic.List[string]
  $Items.Add('<?xml version="1.0" encoding="UTF-8"?>')
  $Items.Add('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')

  foreach ($Page in $Pages) {
    $Items.Add("  <url><loc>$((ConvertTo-XmlText (Get-AbsoluteUrl $Page.Url)))</loc></url>")
  }

  $Items.Add('</urlset>')
  Set-Content -Encoding utf8 -LiteralPath (Join-Path $DistPath "sitemap.xml") -Value ($Items -join "`n")
}

function Write-Feed {
  param([object[]]$Posts)

  $Items = New-Object System.Collections.Generic.List[string]
  $Items.Add('<?xml version="1.0" encoding="UTF-8"?>')
  $Items.Add('<rss version="2.0">')
  $Items.Add('  <channel>')
  $Items.Add("    <title>$((ConvertTo-XmlText $Config.websiteTitle))</title>")
  $Items.Add("    <link>$((ConvertTo-XmlText $Config.websiteUrl))</link>")
  $Items.Add("    <description>$((ConvertTo-XmlText $Config.description))</description>")

  foreach ($Post in $Posts) {
    $Url = Get-AbsoluteUrl $Post.Url
    $Items.Add('    <item>')
    $Items.Add("      <title>$((ConvertTo-XmlText $Post.Title))</title>")
    $Items.Add("      <link>$((ConvertTo-XmlText $Url))</link>")
    $Items.Add("      <guid>$((ConvertTo-XmlText $Url))</guid>")
    if ($Post.Description -ne "") {
      $Items.Add("      <description>$((ConvertTo-XmlText $Post.Description))</description>")
    }
    if ($Post.Date -ne "") {
      $Items.Add("      <pubDate>$((Get-Date $Post.Date -Format 'R'))</pubDate>")
    }
    $Items.Add('    </item>')
  }

  $Items.Add('  </channel>')
  $Items.Add('</rss>')
  Set-Content -Encoding utf8 -LiteralPath (Join-Path $DistPath "feed.xml") -Value ($Items -join "`n")
}

if (-not (Test-Path -LiteralPath $ConfigPath)) {
  throw "Config file not found: $ConfigPath"
}

if (-not (Test-Path -LiteralPath $ContentPath)) {
  throw "Content folder not found: $ContentPath"
}

if (-not (Test-Path -LiteralPath $TemplatePath)) {
  throw "Template file not found: $TemplatePath"
}

if (-not (Test-Path -LiteralPath $StylePath)) {
  throw "Style file not found: $StylePath"
}

$Config = Get-Content -Raw -Encoding utf8 -LiteralPath $ConfigPath | ConvertFrom-Json
$Template = Get-Content -Raw -Encoding utf8 -LiteralPath $TemplatePath

$ExpectedDist = [System.IO.Path]::GetFullPath((Join-Path $Root "dist"))
$ActualDist = [System.IO.Path]::GetFullPath($DistPath)
if ($ExpectedDist -ne $ActualDist) {
  throw "Refusing to clean unexpected dist path: $DistPath"
}

if (Test-Path -LiteralPath $DistPath) {
  Remove-Item -Recurse -Force -LiteralPath $DistPath
}

New-Item -ItemType Directory -Force -Path $AssetsOutPath | Out-Null
New-Item -ItemType File -Force -Path (Join-Path $DistPath ".nojekyll") | Out-Null

if (Test-Path -LiteralPath $AssetsPath) {
  Get-ChildItem -Force -LiteralPath $AssetsPath | Copy-Item -Recurse -Force -Destination $AssetsOutPath
}

Copy-Item -Force -LiteralPath $StylePath -Destination (Join-Path $AssetsOutPath "carbon.css")

$ContentFiles = @(Get-ChildItem -Recurse -File -LiteralPath $ContentPath -Filter "index.typ")
if ($ContentFiles.Count -eq 0) {
  throw "No content index files found in: $ContentPath"
}

$Pages = @($ContentFiles | ForEach-Object { Get-ContentPage -Path $_.FullName } | Sort-Object Url)
$BlogPosts = @($Pages | Where-Object { $_.Section -eq "Blog" -and $_.Url -ne "/Blog/" } | Sort-Object Date -Descending)
$WrittenPages = New-Object System.Collections.Generic.List[object]

foreach ($Page in $Pages) {
  if ($Page.Url -eq "/Blog/") {
    continue
  }

  $Content = "<article class=`"post-content`">`n$($Page.ContentHtml)`n</article>"

  if ($Page.Url -eq "/") {
    $Content = $Content + "`n<section class=`"post-content recent-posts`">`n<h2>最近更新</h2>`n$(New-PostListHtml -Posts $BlogPosts)`n</section>"
  }

  Write-SitePage -OutputUrl $Page.Url -Title $Page.Title -Description $Page.Description -Content $Content
  $WrittenPages.Add($Page)
}

$BlogIndexContent = @"
<article class="post-content">
<h1>博客 / Blog</h1>
<p>文章按年份归档，记录学习过程、阶段总结和项目复盘。</p>
$(New-PostListHtml -Posts $BlogPosts)
</article>
"@

Write-SitePage -OutputUrl "/Blog/" -Title "Blog" -Description "Mind-Controlll 的博客文章列表。" -Content $BlogIndexContent
$WrittenPages.Add([pscustomobject]@{ Url = "/Blog/" })

Write-RedirectPage -OutputUrl "/about/" -Target "/CV/" -Title "About"
Write-RedirectPage -OutputUrl "/posts/self-intro/" -Target "/CV/" -Title "About"

Write-Sitemap -Pages $WrittenPages
Write-Feed -Posts $BlogPosts

Write-Host "Build succeeded."
Write-Host "Generated: $DistPath"
Write-Host "Pages: $($WrittenPages.Count)"
Write-Host "Blog posts: $($BlogPosts.Count)"




