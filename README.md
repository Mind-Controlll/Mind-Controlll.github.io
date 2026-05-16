# Mind-Controlll.github.io

这是 Mind-Controlll 的个人博客源码。

## 内容管理方式

- 全局配置：`site.config.json`
- 正文内容：`content/**/index.typ`
- 共享资源：`assets/`
- 模板：`src/templates/`
- 样式：`src/styles/`
- 构建脚本：`scripts/build.ps1`
- 构建产物：`dist/`

路径规则：

- `content/index.typ` -> `/`
- `content/Docs/index.typ` -> `/Docs/`
- `content/Docs/site-config/index.typ` -> `/Docs/site-config/`
- `content/Blog/2026-05-16-building-this-blog/index.typ` -> `/Blog/2026-05-16-building-this-blog/`
- `content/CV/index.typ` -> `/CV/`

## 本地构建

```powershell
powershell -ExecutionPolicy Bypass -File ".\scripts\build.ps1"
```

## 发布

```powershell
git add .
git commit -m "Update blog"
git push
```

GitHub Pages 使用 `.github/workflows/pages.yml` 自动构建并发布 `dist/`。
