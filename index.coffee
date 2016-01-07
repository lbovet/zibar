require 'colors'
human = require 'human-format'
fractions = ' ▁▂▃▄▅▅▆▇█'
scale = new human.Scale
  '': 1,
  k: 1000,
  M: 1000000,
  G: 1000000000,
  T: 1000000000000
zibar = (data, options) ->
  y =
    color: options?.yAxis?.color||'cyan'
    style: options?.yAxis?.style||'reset'
    ticks: options?.yAxis?.ticks?
    decimals: if options?.yAxis?.decimals? then options?.yAxis?.decimals else 1
    display: options?.yAxis?.display isnt false
  x =
    color: options?.xAxis?.color||'cyan'
    style: options?.xAxis?.style||'reset'
    decimals: if options?.xAxis?.decimals? then options?.xAxis?.decimals else 0
    ticks: false
    trim: true
    display: options?.xAxis?.display isnt false
  label = (axis, val, length=9, right=false) ->
    val = human(val, { decimals: axis.decimals, scale: scale}) + " "
    if axis.decimals and val.indexOf(".") == -1
      val = val.replace /([0-9]) /, '$1.0 '
    if axis.ticks
      val = val.replace ' ', '_'
    if axis.trim
      val = val.trim()
    numPads = length - val.length
    pad = new Array(numPads + 1).join(' ')
    val = if right then val+pad else pad+val
    val = val[axis.color][axis.style]
  result = []
  height = options?.height || 10
  color = options?.color || 'yellow'
  min = Math.min.apply null, data
  max = Math.max.apply null, data
  low = if options?.low? then options.low else min
  high = if options?.high? then options.high else max
  min = if options?.min? then options.min else Math.min low, min
  max = if options?.max? then options.max else Math.max high, max
  span = max-min
  step = span/height
  for r in [height..1]
    floor = min + step*(r-1)
    ceil = floor + step
    row = []
    for value in data
      char = ' '
      if value >= floor
        fraction = 9*(value-floor)/step
        fraction = if r is 1 and value != 0 and fraction < 1 then 1 else fraction
        fraction = Math.floor(fraction)
        char = if value <= ceil then fractions[fraction] else '█'
      row.push char
      line = (row.join '')[color][options?.style||'reset']
      line = (if y.display then label(y, floor) else "") + line
    result.push line
  xlabels = []
  interval = options?.xAxis?.interval || 5
  factor = options?.xAxis?.factor || 1
  start = 0
  end = Math.floor(data.length/interval)
  shift = 0
  origin = options?.xAxis?.origin || 0
  offset = options?.xAxis?.offset || 0
  if offset
    offset = offset % interval
    offset = interval + offset if offset < 0
    if offset
      xlabels.push ' ' for i in [1..offset].join('')
      end = Math.max(end-1,0)
  for i in [start..end]
    xlabels.push label(x, factor*(i*interval+offset)+origin, interval, true)
  result = (if y.display then label(y, max) + '\n' else '') +
    result.join('\n') + '\n' +
    if x.display then "         " + xlabels.join('') + '\n' else ''

exports:
  zibar: zibar

if process.argv[1].indexOf('zibar')
  data = [2, 4, 6, 6, 7, 8, 3, 5, 3, 0, 1]
  process.stdout.write zibar data,
    xAxis:
      origin: 3
      offset: 2
