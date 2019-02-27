const { environment } = require("@rails/webpacker");
const vue = require("./loaders/vue");
const custom = require("./custom");

environment.config.merge(custom);
environment.loaders.append("vue", vue);

module.exports = environment;
