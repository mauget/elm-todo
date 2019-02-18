var gulp = require('gulp');
var elm = require('gulp-elm');


function bundle() {
    return gulp.src('src/*.elm')
        .pipe(elm.bundle("elm.js"))
        .pipe(gulp.dest('.'));
}


exports.bundle = bundle;
exports.default = bundle;
