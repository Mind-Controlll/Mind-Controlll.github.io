// title: 自定义样式
// description: 说明如何管理 CSS、图片和其他静态资源。

= 自定义样式

参考站说明了一个核心原则：Typst 负责内容，CSS 负责网页视觉。这个博客也按这个思路管理。

== 样式文件

主要样式在：

```text
src/styles/carbon.css
```

构建时会复制到：

```text
dist/assets/carbon.css
```

所以你要改颜色、字体、间距、布局时，改 `src/styles/carbon.css`，不要直接改 `dist/` 里的文件。

== 图片资源

共享图片放在：

```text
assets/images/
```

文章里使用绝对路径引用：

```typst
#image("/assets/images/johnny.PNG", width: 90%)
```

== 维护原则

- 正文内容放 `content/`。
- 共享图片放 `assets/`。
- 样式只改 `src/styles/`。
- `dist/` 是构建产物，可以重新生成。
