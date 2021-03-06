require 'colors'
strip = require 'strip-ansi'
human = require 'human-format'
scale = new human.Scale
  '': 1,
  k: 1000,
  M: 1000000,
  G: 1000000000,
  T: 1000000000000
zibar = (data, options) ->
  fractions = options.chars or ' ▁▂▃▄▅▅▆▇█'
  full = if options?.badBlock then fractions[8] else fractions[9]
  bg = null
  style = (s, c) ->
    if not s
      return ' '
    for i in c.split(",")
      s = s[i]
    return s
  if options?.background
    bgColor = options?.background.split ''
    bgColor = bgColor.splice(0, 1).join('').toUpperCase() + bgColor.join('')
    if options?.fixFull
      bg = style(fractions[8], options.background)
  y =
    color: options?.yAxis?.color||'cyan'
    ticks: options?.yAxis?.ticks?
    decimals: if options?.yAxis?.decimals? then options?.yAxis?.decimals else 1
    display: options?.yAxis?.display isnt false
    transform: options?.transform || (x) -> x
    inverse: options?.inverse || (x) -> x
  x =
    color: options?.xAxis?.color||'cyan'
    decimals: if options?.xAxis?.decimals? then options?.xAxis?.decimals else 0
    ticks: false
    trim: true
    display: options?.xAxis?.display isnt false
    transform: (x) -> x
    inverse: (x) -> x
    format: options?.xAxis?.format || (x) -> x
  label = (axis, val, length=9, right=false, format) ->
    length = Math.round length
    val = axis.inverse(val)
    if val is NaN
      val = ''
    else
      if format
        val = format(val)+" "
      else
        val = human(val, { decimals: axis.decimals, scale: scale})+" "
      if axis.decimals and val.indexOf(".") == -1
        val = val.replace /([0-9]) /, '$1.0 '
    if axis.ticks
      val = val.replace ' ', '_'
    if axis.trim
      val = val.trim()
    numPads = length - strip(val).length
    if numPads > 0
      pad = new Array(numPads + 1).join(' ')
      val = if right then val+pad else pad+val
    else
      val = val.substring 0, length
    val = style(val, axis.color)
  result = []
  height = options?.height || 10
  color = options?.color || 'yellow'
  min = Math.min.apply(null, data) || 0
  max = Math.max.apply(null, data) || 0
  low = if options?.low? then options.low else min
  high = if options?.high? then options.high else max
  min = y.transform(if options?.min? then options.min else Math.min low, min)
  max = y.transform(if options?.max? then options.max else Math.max high, max)
  span = max-min
  step = span/height
  for r in [height..1]
    floor = min + step*(r-1)
    ceil = floor + step
    row = []
    pos = 0
    for value in data
      value = value || 0
      char = if bg then bg else ' '
      char = style("|",options.vlines[pos]) if options?.vlines?[pos]
      value = y.transform(value)
      if value >= floor
        fraction = 9*(value-floor)/step
        fraction = if r is 1 and value != 0 and fraction < 1 then 1 else fraction
        fraction = if fraction >= 8 and options?.badBlock then 7 else fraction
        fraction = Math.floor(fraction)
        char = if value <= ceil then fractions[fraction] else full
      special = options?.colors?[pos++] || color
      char = style(char, color) if bg and not special
      char = style(char, special) if options?.colors
      row.push char
    row.push bg if bg
    row.push ' ' if bg
    line = (row.join '')
    line = style(line,color) if not bg
    line = line['bg'+bgColor] if bgColor
    line = (if y.display then label(y, floor || 0) else "") + line
    result.push line
  xlabels = []
  interval = options?.xAxis?.interval || 5
  factor = options?.xAxis?.factor || 1
  start = 0
  end = Math.floor(data.length/interval) || 0
  shift = 0
  origin = options?.xAxis?.origin || 0
  offset = options?.xAxis?.offset || 0
  if offset
    offset = offset % interval
    offset = interval + offset if offset < 0
    if offset
      n = offset
      xlabels.push (' ' for i in [1..n]).join('')
      end = Math.max(end-1,0)
  for i in [start..end]
    xlabels.push label(x, factor*(i*interval+offset)+origin, interval, true, x.format)
  pad = if y.display then "         " else ''
  marks = []
  if options?.marks
    for mark in options.marks
      symbol = ' '
      if mark
        symbol = if mark.symbol then mark.symbol else mark
        symbol = if mark.color then style(symbol, mark.color) else symbol
      marks.push symbol
  hasHead = y.display or options?.marks
  axisHead = if y.display then label(y, if max > -Infinity then max else 0) else ''
  markLine = if options?.marks then marks.join('') else ''
  result = (if hasHead then axisHead + markLine + '\n' else '') +
    result.join('\n') + '\n' +
    if x.display then pad + xlabels.join('') + '\n' else ''

module.exports = zibar
