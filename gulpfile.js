var gulp = require('gulp');
var elm = require('gulp-elm');

function make() {
    return gulp.src('src/*.elm')
        .pipe(elm.make())
        .pipe(gulp.dest('.'));
}

function bundle() {
    return gulp.src('src/*.elm')
        .pipe(elm.bundle("elm.js"))
        .pipe(gulp.dest('.'));
}

exports.make = make;
exports.bundle = bundle;
exports.default = bundle;
