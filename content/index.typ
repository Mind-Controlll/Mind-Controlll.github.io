#import "../config.typ": template, tufted
#import "_generated/recent-posts.typ": recent-posts

#let render-post-card(post) = {
  html.a(
    class: "post-card",
    href: post.at("url"),
    {
      html.div(class: "post-title", {
        html.span(class: "post-card-link", post.at("title"))
      })

      if post.at("description") != "" {
        html.div(class: "post-description", {
          post.at("description")
        })
      } else {
        html.div(class: "post-description", "")
      }

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

#if recent-posts.len() == 0 {
  html.div(class: "post-card post-card-empty", "暂无文章")
} else {
  html.div(class: "posts-grid", {
    let count = calc.min(10, recent-posts.len())

    for i in range(count) {
      render-post-card(recent-posts.at(i))
    }
  })
}
