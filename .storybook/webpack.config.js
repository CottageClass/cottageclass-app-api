module.exports = async ({ config }) => {
  config.resolve.alias.vue = 'vue/dist/vue.esm.js'
  return config
}
