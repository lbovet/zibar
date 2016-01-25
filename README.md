# Zibar
Pretty graphs for the terminal

![screenshot from 2016-01-12 21 48 11](https://cloud.githubusercontent.com/assets/692124/12276730/9e8ace9a-b977-11e5-8628-5b89d6486b00.png)

Inspired from [babar](https://www.npmjs.com/package/babar) and [sparkline](https://www.npmjs.com/package/sparkline). This actually mixes features of both.

# Installation
```
npm install zibar -g
```  
If you don't know what npm is, read [this](https://docs.npmjs.com/getting-started/installing-node).

# Usage
```
zibar [-c config-file] [ - ] [ value1 [value2..]]
```  
Data can be read from stdin

![screenshot from 2016-01-12 21 45 55](https://cloud.githubusercontent.com/assets/692124/12276739/ab60a37e-b977-11e5-94e8-0c370b3e6f8e.png)

Configuration allows fancy rendering

![screenshot from 2016-01-12 21 48 51](https://cloud.githubusercontent.com/assets/692124/12276759/dc1741f8-b977-11e5-9dd2-e551d17eaaf6.png)

```javascript
{
  "height": 5,
  "min": 0,
  "high": 40,
  "marks": [ 0, "?", 0, 0, { "symbol": "▼", "color": "red,bold" } ],
  "color": "green",
  "colors": {
    "5": "magenta,bold"
  },
  "vlines": [null, null, "cyan"],
  "yAxis": {
    "decimals": 0
  },
  "xAxis": {
    "interval": 2,
    "color": "yellow,bold"
  }
}
```

Or minimal sparkline style

![screenshot from 2016-01-12 21 59 47](https://cloud.githubusercontent.com/assets/692124/12276751/d128c0d2-b977-11e5-9ff7-b2bbc95033cb.png)

```javascript
{
  "height": 1,
  "min": 0,
  "color": "yellow,bold",
  "yAxis": {
    "display": false
  },
  "xAxis": {
    "display": false
  }
}
```

# Configuration

```javascript
{
  "height": 5,                 // graph height
  "color": "green",            // bar color
  "background": "blue",        // graph background color
  "min": 0,                    // minimum value, clips values below
  "max": 10,                   // maximum value, clips values above
  "low": 3,                    // soft minimum, values below are also shown
  "high": 6.                   // soft maximum, values above are also shown
  "chars": " ⡀⡀⡄⡄⡆⡆⡇⡇⡇",     // characters used for the bars, defaults to unicode block elements
  "marks": [ 0,                // markers chars above the graph
            "?",               // can be an array or integer-indexed object
            null,
            0,
            { "symbol": "▼",   // use objects to add styling
              "color": "red" }
            ],
  "colors": {                  // custom colors for values
    "5": "magenta,bold"        // can be an array or integer-indexed object
  },
  "vlines":
    [null, null, "cyan"],      // vertical lines markers
  "yAxis": {
    "display": true,           // show/hide the axis labels
    "color": "yellow",         // axis label color
    "ticks": true,             // show/hide axis ticks
    "decimals": 0              // number of decimals in axis labels
  },
  "xAxis": {
    "display": true,           // show/hide the axis labels
    "color": "yellow",         // axis label color
    "interval": 2,             // distance between labels
    "origin": 10,              // axis scale starts with this value
    "factor": 2,               // axis scale multiplier
    "offset": 3                // relative position of the label to its default
  }
}
```

# Rendering glitches

The terminal and its font must support unicode. Ensure you have one, e.g. [Source Code Pro](https://github.com/adobe-fonts/source-code-pro).

If some blocks looks weird, try the following config options.
```javascript
"badBlock": true,
"fixFull": true
```

# Using as a library

```
npm install zibar --save
```

```javascript
var zibar = require('zibar');
var graph = zibar(data, config);  // returns the graph as a string
```
Example
```javascript
var graph = zibar([30, 12, 9.8, 31, 14, 31.5, 4, 6, 22, 33, 4, 22],
                  {
                    "height": 1,
                    "min": 0,
                    "color": "yellow,bold",
                    "yAxis": {
                      "display": false
                    },
                    "xAxis": {
                      "display": false
                    }
                  });
process.stdout.write(graph);
```

# Formatting

When using as a library, you can pass a function for formatting x and y axis labels.

```javascript
format: function(x) { return require('roman-numerals').toRoman(x); }
```

# Scale Transform

For non-linear y scale, you can pass a function and its inverse to transform the scale.

```javascript
tranform: function(x) { return Math.log(x)/Math.log(10); }
inverse: function(x) { return Math.pow(10,x); }
```
