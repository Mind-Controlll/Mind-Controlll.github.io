#import "../../index.typ": template, tufted
#show: template.with(
  title: "GitHub Pages 部署",
  description: "说明这个博客如何通过 GitHub Actions 发布到 GitHub Pages。",
)

= GitHub Pages 部署

这个博客使用 GitHub Actions 部署。你只要把代码推送到 `main` 分支，GitHub 就会自动运行 `.github/workflows/deploy.yml`，构建并发布网站。

== 仓库设置

在 GitHub 仓库中进入：

```text
Settings → Pages → Build and deployment
```

Source 必须选择：

```text
GitHub Actions
```

不要选择 `Deploy from a branch`，否则 GitHub 可能会用默认 Jekyll 页面覆盖你的构建结果。

== 日常发布流程

```powershell
cd "G:\claude_code_demo\Mind_Controlll.github.io"
python build.py build -f
git add .
git commit -m "Update blog"
git push
```

推送完成后去 GitHub 的 Actions 页面，看到 `Deploy` 变成绿色对勾，就说明部署成功。

== 常见问题

- 如果网页还是旧内容，先按 `Ctrl + F5` 强制刷新。
- 如果 Actions 没有运行，检查工作流文件是否在 `.github/workflows/deploy.yml`。
- 如果 Pages 显示空白默认页，检查 Pages Source 是否还是 `GitHub Actions`。
