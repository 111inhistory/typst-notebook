#import "utils.typ": merge_dict

// Not implemented yet
#let frame-boxy(
  main_color: none,
  bg_color: none,
  title-text-args: none,
  fig,
) = {
  let kind = fig.kind
  let body = fig.body
  let title_body = fig.caption.separator + fig.caption.body

  let title-text-default = (weight: "bold", fill: main_color.darken(50%))
  let title-text = merge_dict(
    title-text-default,
    title-text-args,
  )

  let title = [
    #set par(first-line-indent: 0em)
    #set text(..title-text)
    #kind
    #title_body
    #parbreak()
  ]

  block(
    width: 100%,
    inset: 1.2em,
    stroke: (all: (paint: main_color, thickness: 0.3em)),
    radius: 0.5em,
    fill: bg_color,
  )[
    #title
    #body
  ]
}

// Not implemented yet
#let caption-boxy(..args) = {
  let body = []
  for i in range(args.pos().len() - 1) {
    body += args.pos().at(i)
    body += h(0.5em)
    body += "|"
    body += h(0.5em)
  }
  body += args.pos().at(-1)
  figure.caption(body, pos: top, separator: ": ")
}

// Just manage how multi subtitle be composited, no text style here
#let caption-simple(..args) = {
  let body = []
  for i in range(args.pos().len() - 1) {
    body += args.pos().at(i)
    body += h(0.5em)
    body += "|"
    body += h(0.5em)
  }
  if args.pos().len() > 0 {
    body += args.pos().at(-1)
  }
  figure.caption(body, position: top, separator: "")
}

#let frame-simple(
  main_color: none,
  bg_color: none,
  title-text-args: none,
  show_counter: true,
  fig,
) = {
  let kind = fig.kind
  let body = fig.body
  let title_body = fig.caption.separator + fig.caption.body
  let title_prefix = if show_counter {
    [#kind #context numbering(fig.numbering, ..counter(figure.where(kind: kind)).get())]
  } else {
    [#kind]
  }

  let title-text-default = (weight: "bold", fill: main_color.darken(50%))
  let title-text = merge_dict(
    title-text-default,
    title-text-args,
  )

  let title = [
    #set par(first-line-indent: 0em)
    #set text(..title-text)
    #title_prefix
    #title_body
    #parbreak()
  ]

  block(
    width: 100%,
    inset: 1.2em,
    stroke: (left: (paint: main_color, thickness: 0.3em)),
    radius: 0.5em,
    fill: bg_color,
  align(left)[
    #title
    #body
  ])
}

#let frame-stylings = (
  simple: (frame: frame-simple, caption: caption-simple),
  boxy: (frame: frame-boxy, caption: caption-boxy),
)
