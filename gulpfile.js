const gulp = require('gulp');
const spawn = require('child_process').spawn;
const exec = require('child_process').exec;
const elm = require('gulp-elm');


function bundle(cb) {
    return gulp.src('src/*.elm')
        .pipe(elm.bundle("elm.js"))
        .pipe(gulp.dest('.'));
}

// Pre-req:  'npm install -g http-server'
function serve(cb) {
    return exec('http-server', [], (err, stdout, stderr) => {
        console.log(stdout);
        console.log(stderr);
        cb(err);
    });
}

/*function serve(cb) {
    return spawn('http-server', [], { stdio: 'inherit' });
}*/

exports.bundle = bundle;
exports.serve = serve;
exports.default = bundle;
