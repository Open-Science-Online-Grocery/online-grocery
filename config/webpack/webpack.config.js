const mode = process.env.NODE_ENV === 'development' ? 'development' : 'production';

const path = require('path')
const webpack = require('webpack')

const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const RemoveEmptyScriptsPlugin = require('webpack-remove-empty-scripts');

module.exports = {
  mode,
  entry: {
    main: [
      path.resolve(__dirname, '..', '..', './app/client/packs/main.js'),
    ],
    style: path.resolve(__dirname, '..', '..', './app/client/packs/style.scss'),
    grocery_store: path.resolve(__dirname, '..', '..', './app/client/packs/grocery_store.js') 
  },
  context: path.resolve(__dirname, 'app/client/packs'),
  output: {
    filename: '[name].js',
    sourceMapFilename: '[file].map',
    path: path.resolve(__dirname, '..', '..', 'app/assets/builds')
  },
  optimization: {
    moduleIds: 'deterministic'
  },
  module: {
    rules: [
      {
        test: /\.s[ac]ss|css$/i,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: 'css-loader',
            // below adapted from https://stackoverflow.com/a/70713476
            // without it, the fomantic fonts cause an error that
            // "You may need an additional plugin to handle "data:" URIs."
            options: {
              url: {
                filter: (url, resourcePath) => {
                  return !url.startsWith('data:');
                }
              }
            }
          },
          { loader: 'sass-loader', options: { sourceMap: true } }
        ],
      },
      {
        test: /\.(js|jsx|)$/,
        resolve: { extensions: [".js", ".jsx"] },
        exclude: /node_modules/,
        use: ['babel-loader']
      },
      {
        test: /\.(png|jpe?g|gif|eot|woff2|woff|ttf|svg)$/i,
        type: 'asset/resource',
        generator: {
          // this prevents the rails asset pipeline (sprockets) from adding its
          // own digest hash to the filename so that JS files can refer to
          // these assets in a predictable fashion.
          filename: '[name]-[hash].digested[ext]'
        }
      }
    ]
  },
  resolve: {
    extensions: ['.js', '.jsx', '.scss', '.css']
  },
  plugins: [
    new RemoveEmptyScriptsPlugin(),
    new MiniCssExtractPlugin(),
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      jquery: 'jquery'
    }),
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    })
  ]
}
