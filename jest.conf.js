const path = require('path')

require('dotenv').config({ path: './.env.test' })

module.exports = {
  rootDir: path.resolve(__dirname, '.'),
  moduleFileExtensions: [
    'js',
    'json',
    'vue'
  ],
  moduleNameMapper: {
    '\\.(jpg|jpeg|png|gif|eot|otf|webp|svg|ttf|woff|woff2|mp4|webm|wav|mp3|m4a|aac|oga)$': '<rootDir>/src/__mocks__/fileMock.js',
    '^@/(.*)$': '<rootDir>/src/$1'
  },
  transform: {
    '^.+\\.js?$': '<rootDir>/node_modules/babel-jest',
    '.*\\.(vue)$': '<rootDir>/node_modules/vue-jest'
  },
  transformIgnorePatterns: [
    'node_modules/(?!(vue-google-autocomplete)/)' // whitelist VGA for transform
  ],
  snapshotSerializers: ['<rootDir>/node_modules/jest-serializer-vue'],
  testURL: 'http://localhost/',
  testMatch: ['<rootDir>/src/__tests__/**/*.test.js'],
  setupFiles: ['<rootDir>/src/__tests__/setup.js']
}
