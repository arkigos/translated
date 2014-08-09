fs = require 'fs'
path = require 'path'
module.exports = (app) ->

    app   
        .get '/', (req, res) ->
            res.render 'index'
        .get '/test', (req, res) ->
            res.render 'test'
        .get '/translated', (req, res) ->
            res.render 'translated'
        .get '/uploads/:filename', (req, res) ->
            res.sendfile(path.resolve('./uploads/' + req.params.filename))
        .post '/post/upload', (req, res) ->
            file = req.files.file
            tmpPath = file.path
            targetPath = path.resolve('./uploads/' + file.name)
            fs.rename tmpPath, targetPath, (err) ->
                if (err) 
                    throw err
                fs.unlink tmpPath, () ->
                    if (err) 
                        throw err
                    res.send(file.name)
        .get '/post/:title_slug', (req, res) ->
            res.render 'post'
        .get '/post/edit/:title_slug', (req, res) ->
            res.render 'edit'
        .get '/partials/:page', (req, res) ->
            res.render 'partials/'+req.params.page
        .get '/favicon.ico', (req, res) ->
            res.status(404)
            res.send('No page here.')