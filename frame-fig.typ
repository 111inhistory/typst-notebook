#import "frame-styling.typ": frame-stylings

#let frame(kind: none, style: "simple", ..args) = {
  if kind == none {
    panic("Frame kind must be specified.")
  }

  let title = ()
  let body = []
  let con = args.pos()

  if con.len() == 0 {
    panic("Frame must have at least one content block.")
  } else if con.len() == 1 {
    body = con.at(0)
  } else if con.len() > 1 {
    for i in range(0, con.len() - 1) {
      title.push(con.at(i))
    }
    body = con.at(-1)
  }

  title = frame-stylings.at(style).at("caption")(..title)

  return figure(
    kind: kind,
    caption: title,
    supplement: kind,
    body,
  )
}

#let dig(it) = {
  it.fields()
}

#let frame-stylize(
  main_color: none,
  tag: none,
  show_counter: false,
  bg_color: none,
  transparency: 80%,
  title-text-args: none,
  style: "simple",
  doc,
) = {
  let c = main_color
  let bg = if bg_color == none {
    main_color.opacify(-transparency)
  } else {
    bg_color
  }
  show figure.where(kind: tag): set figure(supplement: tag)
  show figure.where(kind: tag): frame-stylings
    .at(style)
    .at("frame")
    .with(
      main_color: c,
      bg_color: bg,
      title-text-args: title-text-args,
      show_counter: show_counter,
    )
  doc
}



