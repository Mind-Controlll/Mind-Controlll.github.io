#import "../../index.typ": template, tufted
#show: template.with(
  title: "网站配置",
  description: "说明这个博客的目录结构、全局配置和页面生成规则。",
)

= 网站配置

参考 Tufted Blog Template 的组织方式，这个博客把配置、内容、资源和构建脚本分开管理。

== 项目结构

- `config.typ`：全局配置文件，管理网站标题、作者、导航、页脚和站点地址。
- `content/`：所有正文内容都放在这里。
- `assets/`：共享图片、样式、脚本和图标等静态资源。
- `tufted-lib/`：Tufted 模板函数和 Typst 辅助组件。
- `build.py`：构建脚本，把 `content/` 编译成 `_site/` 中的静态网页。
- `_site/`：构建产物，GitHub Pages 最终发布这里的内容。

== 路径规则

所有 `content/**/index.typ` 都会变成一个网页：

- `content/index.typ` → `/`
- `content/Docs/index.typ` → `/Docs/`
- `content/Docs/site-config/index.typ` → `/Docs/site-config/`
- `content/CV/index.typ` → `/CV/`
- `content/Blog/2026-05-16-building-this-blog/index.typ` → `/Blog/2026-05-16-building-this-blog/`

这条规则来自参考站文档中的层级结构思想：内容页面的位置决定它发布后的 URL。

== 元信息

每个页面开头通过模板参数写元信息：

```typst
#import "../../index.typ": template, tufted
#show: template.with(
  title: "页面标题",
  description: "页面摘要",
  date: datetime(year: 2026, month: 5, day: 16),
)
```

Blog 文章建议一定填写 `title`、`description`、`date`，因为 RSS 和搜索引擎信息都会用到它们。

== 新增一篇博客

新建一个文件夹，例如：

```text
content/Blog/2026-05-20-cs-learning-plan/index.typ
```

然后在里面写：

```typst
#import "../../index.typ": template, tufted
#show: template.with(
  title: "我的计算机学习计划",
  description: "记录第一阶段要补齐的基础知识。",
  date: datetime(year: 2026, month: 5, day: 20),
)

= 我的计算机学习计划

正文从这里开始。
```
