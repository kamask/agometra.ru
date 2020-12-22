{ watch, src, dest } = require "gulp"
sass = require "gulp-sass"
sass.compiler = require "sass"
cssmin = require "gulp-cssmin"
coffeescript = require "gulp-coffeescript"
minify = require "gulp-minify"
pug = require "gulp-pug"


lastChangeHaml = 0

exports.default = ->
    watch 'pug/**/*.pug', (cb) ->
        src ['pug/**/*.pug', '!pug/layouts/**/*.pug', '!pug/inc/**/*.pug']
        .pipe pug { prettiy: false }
        .pipe dest '../app/tpl'
        do cb
        return

    watch 'sass/**/*.sass', (cb) ->
        src ['sass/**/*.sass', '!sass/inc/**/*.sass']
        .pipe do sass
        .pipe do cssmin
        .pipe dest '../public/css/'
        .pipe dest 'css/'

        src ['pug/**/*.pug', '!pug/layouts/**/*.pug', '!pug/inc/**/*.pug']
        .pipe pug { prettiy: false }
        .pipe dest '../app/tpl'
        do cb
        return
    
    watch 'coffee/**/*.coffee', (cb) ->
        src 'coffee/**/*.coffee'
        .pipe do coffeescript
        .pipe minify { ext: { min: '.js' }, noSource: true }
        .pipe dest '../public/js'
        .pipe dest 'js/'
        
        src ['pug/**/*.pug', '!pug/layouts/**/*.pug', '!pug/inc/**/*.pug']
        .pipe pug { prettiy: false }
        .pipe dest '../app/tpl'
        do cb
        return
    return