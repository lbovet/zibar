# Zibar

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

# Using as a library

```
npm install zibar --save
```

```javascript
var zibar = require('zibar');
zibar(data, config);
```

```javascript
zibar([30, 12, 9.8, 31, 14, 31.5, 4, 6, 22, 33, 4, 22],
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
```
