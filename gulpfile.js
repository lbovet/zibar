var gulp = require('gulp');
var coffee = require('gulp-coffee');
var n2a = require('gulp-native2ascii');
var gutil = require('gulp-util');

gulp.task('default', function() {
  gulp.src('*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(n2a({reverse: false}))
    .pipe(gulp.dest('.'))
});
