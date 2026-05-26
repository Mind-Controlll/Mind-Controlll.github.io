#import "../../index.typ": template, tufted
#show: template.with(
  title: "Typst 写作速览",
  description: "说明当前博客支持的基础 Typst 写法。",
)

= Typst 写作速览

参考站用 Typst 编写内容。现在这个博客也直接用 Typst 编译，页面元信息、脚注、边栏注释、图片、数学公式和参考文献都可以逐步接入。

== 标题

```typst
= 一级标题
== 二级标题
=== 三级标题
```

== 段落

空行会分隔段落。每一段尽量只表达一个意思，这样以后改文章会更轻松。

== 列表

```typst
- 第一项
- 第二项
- 第三项
```

== 链接

```typst
#link("/Blog/")[查看博客]
#link("https://github.com/")[GitHub]
```

== 图片

页面专用图片建议放在当前文章目录中：

```typst
#image("johnny.PNG", width: 90%)
```

== 代码块

写代码块时，第一行写三个反引号加语言名，中间写代码，最后一行再写三个反引号。

例如 PowerShell 代码块：

- 第一行写三个反引号，然后紧跟 `powershell`
- 中间：`git status`
- 最后一行只写三个反引号

== 可以继续使用的模板能力

- 脚注和边栏注释
- 表格
- 数学公式
- 参考文献
- 图片标题
- 代码复制按钮
