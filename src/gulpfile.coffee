{ watch, src, dest, series, parallel } = require "gulp"
styl = require "gulp-stylus"
cssmin = require "gulp-cssmin"
coffeescript = require "gulp-coffeescript"
minify = require "gulp-minify"
pug = require "gulp-pug"
rollup = require "gulp-rollup"
through2 = require 'through2'
livereload = require 'gulp-livereload'

dev = true

touch = -> through2.obj (file, enc, cb) ->
  if file.stat
      file.stat.atime = file.stat.mtime = file.stat.ctime = new Date
  cb null, file

touchTpl = ->
	src '../app/tpl/*.html'
	.pipe do touch
	.pipe dest '../app/tpl'
	.pipe do livereload

touchTplNotReload = ->
	src '../app/tpl/*.html'
	.pipe do touch
	.pipe dest '../app/tpl'

publicJs = ->
	src 'coffee/**/*.coffee'
	.pipe coffeescript { bare: true }
	.pipe rollup { input: [
		'coffee/index.js'
		'coffee/ymap.js'
		'coffee/main.js'
		], output: { format: 'es', dir: '/js/'}}
	.pipe minify { ext: { min: '.js' }, noSource: true }
	.pipe dest '../public/js'
	.pipe do livereload

publicStyl = ->
	src 'styl/*.styl'
	.pipe do styl
	.pipe do cssmin
	.pipe dest '../public/css/'

tplPug = ->
	src 'pug/*.pug'
	.pipe pug { prettiy: false, data: { dev: dev } }
	.pipe dest '../app/tpl'

injectJs = (dir) ->
	->
		src "pug/#{dir}/coffee/**/*.coffee"
		.pipe coffeescript { bare: true }
		.pipe rollup { input: "pug/#{dir}/coffee/script.js", output: { format: 'es', dir: '/js/'}}
		.pipe minify { ext: { min: '.js' }, noSource: true }
		.pipe dest "pug/#{dir}/js"

injectStyl = (dir) ->
	->
		src "pug/#{dir}/styl/*.styl"
		.pipe do styl
		.pipe do cssmin
		.pipe dest "pug/#{dir}/css/"

exports.default = ->
	do livereload.listen

	do parallel(
		series(publicJs),
		series((injectJs 'inc'), series (injectJs 'index'), (injectStyl 'inc'), (injectStyl 'index'), publicJs, publicStyl, tplPug, touchTpl)
	)


	watch 'coffee/**/*.coffee', publicJs

	watch 'styl/**/*.*', publicStyl

	watch 'pug/**/*.pug', series tplPug, touchTpl

	watch 'pug/inc/coffee/*.coffee',  series (injectJs 'inc'), tplPug, touchTpl

	watch 'pug/index/coffee/*.coffee', series (injectJs 'index'), tplPug, touchTpl

	watch 'pug/inc/styl/**/*.styl', series (injectStyl 'inc'), tplPug, touchTplNotReload

	watch 'pug/index/styl/**/*.styl', series (injectStyl 'index'), tplPug, touchTplNotReload

	return
