var gulp = require('gulp');
var gutil = require('gulp-util');
var concat = require('gulp-concat');
var sass = require('gulp-sass');
var coffee = require('gulp-coffee');
var ngAnnotate = require('gulp-ng-annotate');
var templateCache = require('gulp-angular-templatecache');
var less = require('gulp-less');
var runSequence = require('gulp-run-sequence');
var copy = require('gulp-copy');
var mainBowerFiles = require('main-bower-files');
var colors = require('colors');

colors.setTheme({
    success: 'green',
    warn: 'yellow',
    info: 'blue',
    error: 'red',
    customDebug: 'magenta'
});

// File paths required for all the following gulp tasks to work. - DO NOT change this unless necessary
var dests = {
    root: './www',
    css: './www/assets/styles',
    js: './www/assets/scripts',
    fonts: './www/assets/fonts'
};
var staticCopy = {
    rootContent: ['./src/index.html', './src/assets/images/**', './src/assets/fonts/*','./src/manifest.json'],
    ionicFonts: ['./bower_components/ionic/release/fonts/*'],
};
var paths = {
    ionic: ["./scss/ionic.app.scss"],
    coffee: ['./src/**/*.coffee', '!./src/**/*.e2e.coffee', '!./src/**/*.unit.coffee'],
    less: ['./src/assets/styles/fulltheme.style.less'],
    templates: ['./src/**/**/*.tpl.html'],
    vendor: ['./src/assets/scripts/vendor/*.js']
};


/************************************************
 * IONIC
 * - before serving, compile using build-develop
 * - after serving, start watching for changes
 ************************************************/
gulp.task('serve:before', ['build']);
gulp.task('serve:after', ['watch']);

/***********************************
 * VARIOUS TASKS
 ************************************/
gulp.task('watch', function () {
    gulp.watch(paths.templates, ['unify-templates']);
    gulp.watch(paths.coffee, ['compile-coffee']);
    gulp.watch(paths.ionic, ['compile-ionic-sass']);
    gulp.watch('./src/assets/styles/fulltheme.style.less', ['compile-less']);
});

/*************************************************************
 * Handle bower components and vendor files (js and css files
 *************************************************************/
gulp.task('extract-bower-files', function () {
    gulp.src(mainBowerFiles()).pipe(gulp.dest('./libs'))
});
gulp.task('concat-bower-js', function () {
    gulp.src(mainBowerFiles({filter: /.*\.js/}))
        .pipe(concat('bower.js'))
        .pipe(gulp.dest(dests.js))
});
gulp.task('handle-bower',[
    'extract-bower-files',
    'concat-bower-js'], function() {
    console.log(colors.success('Bower and vendor files successfully extracted and merged together!'));
});

/******************************************************************
 Compile all coffeescript, LESS, SASS and templates files together
 ******************************************************************/
gulp.task('compile-ionic-sass', function (done) {
    gulp.src(paths.ionic)
        .pipe(sass())
        .on('error', sass.logError)
        .pipe(concat('ionic.css'))
        .pipe(gulp.dest(dests.css))
        .on('end', done);
});

gulp.task('compile-coffee', function (done) {
    gulp.src(paths.coffee)
        .pipe(coffee({bare: true})
            .on('error', gutil.log.bind(gutil, 'Coffee Error')))
        .pipe(ngAnnotate())
        .pipe(concat('app.js'))
        .pipe(gulp.dest(dests.js))
        .on('end', done)
});

gulp.task('compile-less', function () {
    gulp.src(paths.less)
        .pipe(less())
        .pipe(concat('style.css'))
        .pipe(gulp.dest(dests.css));
});

gulp.task('unify-templates', function () {
    gulp.src(paths.templates)
        .pipe(templateCache('templates.js', {module: 'geniusChromeExtension', root: './'}))
        .pipe(ngAnnotate())
        .pipe(gulp.dest(dests.js));
});

gulp.task('concat-vendor', function () {
    gulp.src(paths.vendor)
    .pipe(concat('vendor.js'))
    .pipe(gulp.dest(dests.js));
});

gulp.task('compiling-files', [
    'compile-ionic-sass',
    'compile-coffee',
    'compile-less',
    'unify-templates',
    'concat-vendor'], function () {
    return console.log(colors.success("Files compiled successfully!"));
});



/**********************************
 Copy static elements to www folder
 ***********************************/
gulp.task('copy-static-elements-to-root', function () {
    return gulp.src(staticCopy.rootContent)
        .pipe(copy(dests.root, {prefix: 1}));
});
gulp.task('copy-ionic-fonts', function () {
    return gulp.src(staticCopy.ionicFonts)
        .pipe(copy(dests.fonts, {prefix: 4}));
});
gulp.task('copy-favicon', function () {
    return gulp.src('./src/favicon.ico')
        .pipe(copy(dests.root, {prefix: 1}));
});
gulp.task('copying-to-www', ['copy-static-elements-to-root', 'copy-ionic-fonts', 'copy-favicon'], function () {
    return console.log(colors.success("Files copied successfully!"));
});

gulp.task('build', ['handle-bower'], function () {
    runSequence('handle-bower','compiling-files', 'copying-to-www')
});