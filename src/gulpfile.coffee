{ watch, src, dest, series } = require "gulp"
sass = require "gulp-sass"
sass.compiler = require "sass"
cssmin = require "gulp-cssmin"
coffeescript = require "gulp-coffeescript"
minify = require "gulp-minify"
pug = require "gulp-pug"


pug_pug_build = ->
	src ['pug/*.pug']
	.pipe pug { prettiy: false }
	.pipe dest '../app/tpl'


pug_sass_build = ->
	src ['pug/inc/sass/*.sass']
	.pipe do sass
	.pipe do cssmin
	.pipe dest 'pug/inc/css/'


pug_coffee_build = (path) ->
	src path
	.pipe do coffeescript
	.pipe minify { ext: { min: '.js' }, noSource: true }
	.pipe dest 'pug/inc/js'


sass_build = ->
	src ['sass/*.sass']
	.pipe do sass
	.pipe do cssmin
	.pipe dest '../public/css/'


coffee_build = (path) ->
	src path
	.pipe do coffeescript
	.pipe minify { ext: { min: '.js' }, noSource: true }
	.pipe dest '../public/js'


exports.default = ->

	watch 'coffee/*.coffee'
	.on 'all', (type_event, path) ->
		coffee_build path
		console.log type_event, path
		return

	watch 'pug/inc/coffee/*.coffee'
	.on 'all', (type_event, path) ->
		pug_coffee_build path
		do pug_pug_build
		console.log type_event, path
		return

	watch 'pug/inc/sass/*.sass'
	.on 'all', (type_event, path) ->
		do pug_sass_build
		do pug_pug_build
		console.log type_event, path
		return

	watch 'pug/**/*.pug', pug_pug_build

	watch 'sass/**/*.*', sass_build

	return
