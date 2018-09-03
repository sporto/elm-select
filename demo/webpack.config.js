var merge = require( "webpack-merge" );
var path = require("path");
var webpack = require("webpack");
var HtmlWebpackPlugin = require("html-webpack-plugin");

var DEVELOPMENT = "DEVELOPMENT";
var PRODUCTION = "PRODUCTION";
var ENTRY_FILE = "./src/index.js";

// Detemine build env
var target = process.env.npm_lifecycle_event;
var targetEnv = target === "build" ? PRODUCTION : DEVELOPMENT;

/*
Shared configuration for both dev and production
*/
var baseConfig = {
  output: {
    path: path.resolve(__dirname + "/dist"),
    filename: "index.js"
  },

  resolve: {
    modules: [path.join(__dirname, "src"), "node_modules"],
    extensions: [".js", ".elm"]
  },

  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: "elm-webpack-loader",
        options: {
          cwd:  path.resolve(__dirname, "src"),
        }
      },
    ]
  },

  plugins: [
    // Generate index.html with links to webpack bundles
    new HtmlWebpackPlugin({
      title: "Example",
      xhtml: true,
      template: "src/index.html",
    }),
  ],

}

var devConfig = {};

// Additional webpack settings for prod env (when invoked via "npm run build")
var prodConfig = {
  output: {
    path: path.resolve(__dirname + "/../docs"),
    filename: "[name]-[hash].js",
    publicPath: "/elm-select/",
  },
}

if (targetEnv === DEVELOPMENT) {
  console.log("Serving locally...");
  module.exports = merge(baseConfig, devConfig);
} else {
  console.log("Building for production...");
  module.exports = merge(baseConfig, prodConfig);
}
