path = require 'path'

express = require 'express'
assets = require('connect-assets')
    
jadeAssets = require 'connect-assets-jade'

app = express()

app
    .set('port', process.env.PORT)
    .set('views', path.join __dirname, 'views')
    .set('view engine', 'jade')
    .set('view options', {layout: false})

app
    .use(express.bodyParser(
        uploadDir: path.join __dirname, 'uploads/tmp' 
    ))
    .use(express.methodOverride())
    .use(app.router)
    .use(assets
        helperContext: app.locals
        jsCompilers:
            jade: jadeAssets())
    .use(express.logger 'dev')

require('./routes')(app)
require('./models')(app)
    
app.locals.basedir = '/'
    
module.exports = app.listen process.env.PORT