
module.exports = async ({ config }) => {

  console.dir(config, { depth: 2 }) || config;
  console.log('-----')
  config.module.rules.push({
    test: /\.scss$/,
    use: [
      'vue-style-loader',
      'css-loader',
      'sass-loader'
    ],
  });

  return config;
};
