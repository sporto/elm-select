var merge = require( 'webpack-merge' );
var path = require("path");
var webpack = require("webpack");

var ExtractTextPlugin = require('extract-text-webpack-plugin');
var CopyWebpackPlugin = require('copy-webpack-plugin');
var HtmlWebpackPlugin = require('html-webpack-plugin');

var DEVELOPMENT = 'development';
var PRODUCTION = 'production';
var ENTRY_FILE = './src/index.js';

// Detemine build env
var target = process.env.npm_lifecycle_event;
var targetEnv = target === 'build' ? PRODUCTION : DEVELOPMENT;

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

// Additional webpack settings for prod env (when invoked via 'npm run build')
var prodConfig = {
  entry: {
    app: path.join(__dirname, ENTRY_FILE),
  },

  output: {
    path: path.resolve(__dirname + '/../docs'),
    filename: '[name]-[hash].js',
    publicPath: '/elm-select/',
  },

  module: {
    loaders: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-webpack'
      },
      {
        test: /\.(css|scss)$/,
        loader: ExtractTextPlugin.extract( 'style-loader', [
          'css-loader',
        ])
      }
    ]
  },

  plugins: [
    // Generate index.html with links to webpack bundles
    new HtmlWebpackPlugin({
      title: 'Example',
      xhtml: true,
    }),

    new webpack.optimize.OccurenceOrderPlugin(),

    // extract CSS into a separate file
    new ExtractTextPlugin( './[hash].css', { allChunks: true } ),

    // minify & mangle JS/CSS
    new webpack.optimize.UglifyJsPlugin({
        minimize:   true,
        compressor: { warnings: false }
        // mangle:  true
    })
  ]
}

if (targetEnv === DEVELOPMENT) {
  console.log('Serving locally...');
  module.exports = merge(baseConfig, devConfig);
} else {
  console.log('Building for production...');
  module.exports = merge(baseConfig, prodConfig);
}


