#import "tufted-lib/tufted.typ" as tufted

#let template = tufted.tufted-web.with(
  header-links: (
    "/": "Home",
    "/Docs/": "Docs",
    "/Blog/": "Blog",
    "/CV/": "CV",
  ),

  website-title: "Mind-Controlll 的学习记录",
  author: "Mind-Controlll",
  description: "一个从材料专业转向计算机学习的个人记录站。",
  website-url: "https://mind-controlll.github.io",
  lang: "zh",
  image-path: "/assets/images/johnny.PNG",
  feed-dir: ("/Blog/",),

  header-elements: (
    [你好 Ciallo～(∠・ω< )⌒☆],
    [欢迎来到 Mind-Controlll 的学习记录。],
  ),
  footer-elements: (
    "© 2026 Mind-Controlll.",
    [Powered by #link("https://github.com/Yousa-Mirage/Tufted-Blog-Template")[Tufted-Blog-Template]],
  ),
)
