#import "../config.typ": template, tufted
#import "_generated/recent-posts.typ": recent-posts

#let render-post-card(post) = {
  html.elem(
    "div",
    attrs: (
      class: "post-card",
      "data-post-url": post.at("url"),
    ),
    {
      html.div(class: "post-title", {
        html.a(class: "post-card-link", href: post.at("url"), post.at("title"))
      })

      html.div(class: "post-description", {
        post.at("description")
      })

      if post.at("tags", default: ()).len() != 0 {
        html.div(class: "post-card-tags", {
          for tag in post.at("tags") {
            html.span(class: "post-tag-item tag-item-with-icon", {
              html.span(class: "tag-icon", "")
              html.span(class: "tag-content", html.span(tag))
            })
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
  js-scripts: ("/assets/post-card-click.js",),
)

#if recent-posts.len() == 0 {
  html.div(class: "homepage-carbon", {
    html.div(class: "pages-container", {
      html.div(class: "pages-container-inner", {
        html.div(class: "post-card post-card-empty", "暂无文章")
      })
    })
  })
} else {
  html.div(class: "homepage-carbon", {
    html.div(class: "pages-container", {
      html.div(class: "pages-container-inner", {
        html.div(class: "posts-grid", {
          let count = calc.min(10, recent-posts.len())

          for i in range(count) {
            render-post-card(recent-posts.at(i))
          }
        })
      })
    })
  })
}
