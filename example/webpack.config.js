var merge = require( 'webpack-merge' );
var path = require("path");
var webpack = require("webpack");

var ExtractTextPlugin = require('extract-text-webpack-plugin');
var CopyWebpackPlugin = require('copy-webpack-plugin');
var HtmlWebpackPlugin = require('html-webpack-plugin');

var ENTRY_FILE = './src/index.js';

/*
Shared configuration for both dev and production
*/
var baseConfig = {
  output: {
    path: path.resolve(__dirname + '/dist'),
    filename: '[name].js',
    publicPath: '/', // This must be set for HMR to work
  },

  target: 'web',

  resolve: {
    modulesDirectories: ['node_modules'],
    extensions: ["", ".webpack.js", ".web.js", ".ts", ".js"]
  },

  module: {
    noParse: /\.elm$/,

    loaders: [
      {
        test: /\.tsx?$/,
        loader: "ts-loader"
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file-loader',
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&mimetype=application/font-woff',
      },
    ]
  },

  plugins: [
  ],

}

var devConfig = {
  entry: {
    index: [
      'webpack-hot-middleware/client',  // HMR
      ENTRY_FILE,
    ]
  },

  module: {
    loaders: [
      {
        test: /\.(css|scss)$/,
        loaders: [
          'style-loader',
          'css-loader',
        ]
      },
      {
        test: /\.html$/,
        exclude: /node_modules/,
        loader: 'file?name=[name].[ext]',
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-hot!elm-webpack?verbose=true&warn=true&debug=true',
      },
    ],

  },

  plugins: [
    new webpack.optimize.OccurenceOrderPlugin(), // HMR
    new webpack.HotModuleReplacementPlugin(), // HMR
    new webpack.NoErrorsPlugin(), // HMR
  ],
};

module.exports = merge(baseConfig, devConfig);

