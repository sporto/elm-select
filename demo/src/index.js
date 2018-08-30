'use strict';

require('ace-css/css/ace.css');
require('index.html');

require('./Main.elm').Elm.Main.init({node: document.getElementById('main')});
