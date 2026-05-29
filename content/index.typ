#import "../config.typ": template, tufted
#import "_generated/recent-posts.typ": recent-posts

#let home-mark() = {
  html.elem(
    "svg",
    attrs: (
      class: "home-mark-svg",
      "viewBox": "0 0 240 240",
      role: "img",
      "aria-label": "Mind-Controlll",
    ),
    {
      html.elem("g", attrs: (class: "home-mark-grid"), {
        html.elem("line", attrs: (class: "home-mark-line home-mark-line-1", x1: "120", y1: "22", x2: "120", y2: "218"))
        html.elem("line", attrs: (class: "home-mark-line home-mark-line-2", x1: "36", y1: "70", x2: "204", y2: "170"))
        html.elem("line", attrs: (class: "home-mark-line home-mark-line-3", x1: "36", y1: "170", x2: "204", y2: "70"))
        html.elem("line", attrs: (class: "home-mark-line home-mark-line-4", x1: "68", y1: "38", x2: "172", y2: "202"))
        html.elem("line", attrs: (class: "home-mark-line home-mark-line-5", x1: "68", y1: "202", x2: "172", y2: "38"))
      })
      html.elem("g", attrs: (class: "home-mark-shapes"), {
        html.elem("polygon", attrs: (class: "home-mark-triangle home-mark-triangle-blue", points: "120,42 170,128 70,128"))
        html.elem("polygon", attrs: (class: "home-mark-triangle home-mark-triangle-cyan", points: "70,132 170,132 120,198"))
        html.elem("circle", attrs: (class: "home-mark-core", cx: "120", cy: "126", r: "18"))
      })
    },
  )
}

#let render-post-card(post) = {
  html.a(
    class: "post-card",
    href: post.at("url"),
    {
      html.div(class: "post-title", {
        html.span(class: "post-card-link", post.at("title"))
      })
      html.div(class: "post-description", {
        post.at("description")
      })
      if post.at("tags", default: ()).len() != 0 {
        html.div(class: "post-card-tags", {
          for tag in post.at("tags") {
            html.span(class: "post-tag", tag)
          }
        })
      }
      html.div(class: "post-date", {
        post.at("date_display")
      })
    },
  )
}

#show: template.with(
  title: "Home",
  description: "Mind-Controlll 的个人博客首页。",
)

#html.div(class: "homepage-header", {
  html.div(class: "header-container", {
    html.div(class: "header-svg", {
      home-mark()
    })
    html.div(class: "header-content", {
      html.div(class: "site-title", "Mind-Controlll 的学习记录")
    })
  })
})

#if recent-posts.len() == 0 {
  html.div(class: "home-empty-block", "暂无文章")
} else {
  html.div(class: "posts-grid", {
    let count = calc.min(10, recent-posts.len())

    for i in range(count) {
      render-post-card(recent-posts.at(i))
    }
  })
}
