const { environment } = require('@rails/webpacker');
const webpack = require('webpack');
const customConfig = require('./custom');

// resolve-url-loader must be used before sass-loader
environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader',
  options: {
    attempts: 1
  }
});

// Add an ProvidePlugin
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery'
  })
);

environment.config.merge(customConfig);

const config = environment.toWebpackConfig();

module.exports = environment;
