module.exports = (app) ->

    goose = require 'mongoose'
    restify = require 'express-restify-mongoose'
    uniqueValid = require 'mongoose-unique-validator'
    
    Schema = goose.Schema
    model = goose.model.bind goose
    ObjId = Schema.Types.ObjectId
    
    goose.connect('mongodb://apiuser:23wesdxccxdsew32@troup.mongohq.com:10059/translated')
    
    db = goose.connection
    
    db.on 'error', console.error.bind console, 'connection error:'
    db.once 'open', () ->
        
        postSchema = Schema
            title:
                type: String
                required: true
                unique: true
            posted:
                type: Date
            content:
                type: String
                required: true
            background: [],
        postSchema.plugin(uniqueValid)
        Post = model 'Post', postSchema
        restify.serve app, Post
