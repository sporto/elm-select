var path    = require('path');
var express = require('express');
var http    = require('http');
var webpack = require('webpack');
var webpackDevMiddleware = require('webpack-dev-middleware');
var webpackHotMiddleware = require('webpack-hot-middleware');
var config  = require('./webpack.config');

var app      = express();
var router   = express.Router()
var compiler = webpack(config);
var host     = 'localhost';
var port     = 4000;

app.use(webpackDevMiddleware(compiler, {
  inline: true,
  noInfo: true,
  publicPath: config.output.publicPath,
  stats: { colors: true },
}))

// HMR
app.use(webpackHotMiddleware(compiler, {
  log: console.log
}))

router.get('/', function(req, res) {
  res.sendFile(path.join(__dirname, 'public/index.html'));
});

app.use(router);

// Server images
// app.use(express.static('public'));

var server = http.createServer(app);

server.listen(port, function(err) {
  if (err) {
    console.log(err);
    return;
  }

  var addr = server.address();

  console.log('Listening at http://%s:%d', addr.address, addr.port);
})
