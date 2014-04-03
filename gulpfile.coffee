gulp = require('gulp')
coffee = require('gulp-coffee')
stylus = require('gulp-stylus')
imagemin = require('gulp-imagemin')
clean = require('gulp-clean')
nodemon = require('gulp-nodemon')
src =
  app: './src/app.coffee'
  lib: './src/lib/*.coffee'
  routes: './src/routes/*.coffee'
  coffee: './src/coffee/*.coffee'
  stylus: './src/stylus/*.styl'
  images: './src/images/*'
build =
  app: './build/'
  lib: './build/lib/'
  routes: './build/routes/'
  js: './build/public/js/'
  css: './build/public/css/'
  images: './build/public/images/'
  fonts: './build/public/fonts/'
vendor =
  js: './vendor/js/*'
  css: './vendor/css/*'
  fonts: './vendor/fonts/*'

# CoffeScriptのコンパイルを行う。
gulp.task 'coffee', ->
  gulp.src src.app
    .pipe coffee()
    .pipe gulp.dest build.app
  gulp.src src.lib
    .pipe coffee()
    .pipe gulp.dest build.lib
  gulp.src src.routes
    .pipe coffee()
    .pipe gulp.dest build.routes
  gulp.src src.coffee
    .pipe coffee()
    .pipe gulp.dest build.js
  return

# Stylusのコンパイルを行う。
gulp.task 'stylus', ->
  gulp.src src.stylus
    .pipe stylus()
    .pipe gulp.dest build.css
  return

# imageの圧縮を行う。
gulp.task 'image', ->
  gulp.src src.images
    .pipe imagemin()
    .pipe gulp.dest build.images
  return

# vendorファイルのコピーを行う。
gulp.task 'vendor', ->
  gulp.src vendor.js
    .pipe gulp.dest build.js
  gulp.src vendor.css
    .pipe gulp.dest build.css
  gulp.src vendor.fonts
    .pipe gulp.dest build.fonts
  return

# ファイルを監視して、変更が合った場合はコンパイルし直す。
gulp.task 'watch', ->
  gulp.watch [src.app, src.lib, src.routes, src.coffee], (event) ->
    gulp.run 'coffee'
  gulp.watch src.stylus, (event) ->
    gulp.run 'stylus'
  gulp.watch src.images, (event) ->
    gulp.run 'image'
  return

# ディレクトリを空にする。
gulp.task 'clean', ->
  gulp.src ['app.js', './lib/*', './routes/*', './build/*/*']
    .pipe clean()
  return

# node を実行する。
gulp.task 'nodemon', ->
  nodemon
    script: 'app.js'
    env:
      TZ: 'UTC'
      NODE_ENV: 'development'
    execMap:
      # js: 'node --harmony --debug'
      js: 'node --debug'
  .on 'restart'
  return

# gulp 実行時のデフォルトタスク
gulp.task 'default', ->
  gulp.run 'watch', 'nodemon'
  return

# build だけ実行するタスク
gulp.task 'build', ->
  gulp.run 'clean', 'coffee', 'stylus', 'image', 'vendor'
  return
