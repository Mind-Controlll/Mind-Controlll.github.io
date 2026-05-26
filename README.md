# Mind-Controlll.github.io

这是 Mind-Controlll 的个人学习记录站，已经按 [Yousa-Mirage/Tufted-Blog-Template](https://github.com/Yousa-Mirage/Tufted-Blog-Template) 的结构重构。

## 项目结构

- `config.typ`：全局站点配置、导航、SEO 和 RSS 设置。
- `content/`：所有页面和文章内容。
- `assets/`：站点样式、脚本、图标和共享静态资源。
- `tufted-lib/`：Tufted 模板函数和 Typst 辅助组件。
- `build.py`：构建、清理、预览和 RSS/sitemap 生成脚本。
- `_site/`：本地构建产物，不提交到仓库。
- `.github/workflows/deploy.yml`：GitHub Pages 自动构建和部署工作流。

## 本地构建

```powershell
python build.py build -f
```

也可以使用模板推荐的 uv：

```powershell
uv run build.py build -f
```

## 本地预览

```powershell
python build.py preview -p 8000
```

## 发布

推送到 `main` 后，GitHub Actions 会运行 `Deploy` 工作流，并发布 `_site/`。
