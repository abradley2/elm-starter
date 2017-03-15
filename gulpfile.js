const log = require('pino')();
const gulp = require('gulp');
const nodemon = require('gulp-nodemon');
const browserSync = require('browser-sync').create();
const elm = require('gulp-elm');
const gulpif = require('gulp-if');
const uglify = require('gulp-uglify');
const del = require('del');

const paths = {
    dist: 'public',
    server: 'api',
    elm: 'client/**/*.elm',
    elmMain: 'client/Main.elm'
};

const production = process.env.NODE_ENV === 'production';

gulp.task('serve', function (cb) {
    var called = false;
    return nodemon({
        script: 'server.js',
        watch: paths.server,
        ext: 'js'
    })
    .on('start', function () {
        if (!called) {
            called = true;
            cb();
        }
    })
    .on('restart', function () {
        console.log('restarted!');
    });
});

gulp.task('elm-init', elm.init);

gulp.task('elm-compile', ['elm-init'], function () {
    function onErrorHandler(err) {
        log.error({name: 'gulp elm-compile'}, err.message);
    }
    return gulp.src(paths.elmMain)
        .pipe(elm({debug: true}))
        .on('error', onErrorHandler)
        .pipe(gulpif(production, uglify()))
        .pipe(gulp.dest(paths.dist));
});

gulp.task('elm-compile-production', ['elm-init'], function () {
    function onErrorHandler(err) {
        log.error({name: 'gulp elm-compile-production'}, err.message);
    }
    return gulp.src(paths.elmMain)
        .pipe(elm())
        .on('error', onErrorHandler)
        .pipe(gulpif(production, uglify()))
        .pipe(gulp.dest(paths.dist));
});

gulp.task('watch-server', ['serve'], function () {
    browserSync.init({
        proxy: 'http://localhost:5000'
    });

    gulp.watch(paths.elm, ['elm-compile']);
    gulp.watch(paths.dist + '/*.{js,html}').on('change', browserSync.reload);
});

gulp.task('del', function (cb) {
    del(['./dist/*'])
        .then(() => cb());
});

gulp.task('build-dev', ['elm-compile', 'watch-server']);
gulp.task('build-prod', ['elm-compile-production']);
