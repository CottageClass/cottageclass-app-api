const path = require('path')

function resolve (dir) {
  return path.join(__dirname, '..', dir)
}

module.exports = async ({ config }) => {
  config.module.rules.push({
    test: /\.scss$/,
    use: [
      'vue-style-loader',
      'css-loader',
      'sass-loader'
    ],
  });

  config.resolve.alias = Object.assign(config.resolve.alias, {
      '@': resolve('src')
    })

  return config;
};
