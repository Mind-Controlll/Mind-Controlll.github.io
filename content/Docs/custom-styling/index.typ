#import "../../index.typ": template, tufted
#show: template.with(
  title: "自定义样式",
  description: "说明如何管理 CSS、图片和其他静态资源。",
)

= 自定义样式

参考站说明了一个核心原则：Typst 负责内容，CSS 负责网页视觉。这个博客也按这个思路管理。

== 样式文件

模板样式在：

```text
assets/tufted.css
assets/theme.css
assets/custom.css
```

构建时会复制到：

```text
_site/assets/
```

所以你要改颜色、字体、间距、布局时，优先改 `assets/custom.css`，不要直接改 `_site/` 里的文件。

== 图片资源

共享图片放在：

```text
assets/images/
```

文章里的页面专用图片建议放在文章目录中，像 `content/CV/johnny.PNG` 这样引用：

```typst
#image("johnny.PNG", width: 90%)
```

== 维护原则

- 正文内容放 `content/`。
- 共享图片放 `assets/`。
- 样式优先改 `assets/custom.css`。
- `_site/` 是构建产物，可以重新生成。
