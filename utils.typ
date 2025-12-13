#let level_to_size(level, max_size, min_size) = {
  let size_range = max_size - min_size
  let size_step = size_range / 5
  max_size - (level - 1) * size_step
}

// 可以用repeat()替代
#let fill_len(arr, spacing: " ", target_len: 4, ending: "") = {
  let length = str(arr).len()
  let res = str(arr) + spacing * (target_len - length) + ending
  return [#res]
}

#let merge_dict(raw, mod) = {
  if mod == none { return raw }
  let raw_keys = raw.keys()
  for key in mod.keys() {
    if raw_keys.contains(key) {
      raw.at(key) = mod.at(key)
    } else {
      raw.insert(key, mod.at(key))
    }
  }
  return raw
}

#let ratio_color(ratio) = {
  // 确保输入比例在 0.0 到 1.0 之间
  let r = calc.max(0.0, calc.min(1.0, float(ratio)))
  color.hsl(r * 360deg, 80%, 70%)
}

#let color_map = (
  rgb("#97dcff"),
  rgb("#ff9f5b"),
  rgb("#86dc89"),
  rgb("#b88cef"),
  rgb("#f791a9"),
)

#let color_counter = counter("_color_counter")

#let select_color() = {
  let a = context color_map.at(calc.rem-euclid(color_counter.get().at(0) - 1, color_map.len()))
  color_counter.step()
  a
}