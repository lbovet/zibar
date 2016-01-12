#!/usr/bin/env node
argv = require('minimist')(process.argv.slice(2));
zibar = require('./index');
config = {}
if(argv.c) {
  config = JSON.parse(require('fs').readFileSync(argv.c, 'utf8'));
}
if(argv._[0] == '-') {
  data = []
  process.stdin.pipe(require('split')())
    .on('data', function(line) {
      data.push(line)
    })
    .on('end', function() {
      process.stdout.write(zibar(data, config));
    });
} else {
  data = argv._
  if(data.length > 0) {
    process.stdout.write(zibar(data, config));
  } else {
    process.stdout.write("Usage: zibar [-c config-file] [ - ] [ value1 [value2..]]\n");
    process.exit(1);
  }
}
