module.exports = {
  root: true,
  env: {
    node: true
  },
  'extends': [
    'plugin:vue/essential',
    '@vue/standard'
  ],
  rules: {
    'eqeqeq' : ['error', 'always'],
    'no-console': 'off',
    'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'off',
    'camelcase': 'off',
    'vue/require-v-for-key': 'off',
    'vue/html-indent': ['error'],
    'brace-style': ['error', '1tbs', {'allowSingleLine': true }]
  },
  parserOptions: {
    parser: 'babel-eslint'
  },
  plugins: ['eslint-plugin-html']
}
