'use strict';

require('ace-css/css/ace.css');
require('./index.html');
var Elm = require('./Main');

Elm.Main.embed(document.getElementById('main'));