const { environment } = require('@rails/webpacker')
const vue = require('./loaders/vue')
const custom = require('./custom')
const webpack = require('webpack')
const dotenv = require('dotenv')

const VueLoaderPlugin = require('vue-loader/lib/plugin')

const dotenvFiles = [
  `.env.${process.env.NODE_ENV}.local`,
  '.env.local',
  `.env.${process.env.NODE_ENV}`,
  '.env'
]
dotenvFiles.forEach((dotenvFile) => {
  dotenv.config({ path: dotenvFile, silent: true })
})

environment.plugins.prepend('Environment', new webpack.EnvironmentPlugin(JSON.parse(JSON.stringify(process.env))))
environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())

environment.config.merge(custom)
environment.loaders.append('vue', vue)
environment.mode = process.env.NODE_ENV

module.exports = environment
