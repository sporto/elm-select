'use strict';

require('ace-css/css/ace.css');
require('index.html');
var Elm = require('./Main.elm');

Elm.Elm.Main.init({node: document.getElementById('main')})
