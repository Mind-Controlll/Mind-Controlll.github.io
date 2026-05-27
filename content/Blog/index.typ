#import "../index.typ": template, tufted
#show: template.with(
  title: "Blog",
  description: "Mind-Controlll 的博客文章列表。",
)

= 博客 / Blog

文章按年份归档，记录学习过程、阶段总结和项目复盘。

== 2026

#tufted.blog-entry(
  date: datetime(year: 2026, month: 5, day: 26),
  path: "2026-05-26-CPP-Basic/",
  title: "C++ 基础",
)

#tufted.blog-entry(
  date: datetime(year: 2026, month: 5, day: 18),
  path: "2026-05-18-tpyst-learning/",
  title: "Typst 基础语法学习",
)

#tufted.blog-entry(
  date: datetime(year: 2026, month: 5, day: 16),
  path: "2026-05-16-building-this-blog/",
  title: "从零开始搭建这个博客",
)
