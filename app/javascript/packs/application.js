/* eslint no-console: 0 */

import Vue from "vue";
import App from "../../../src/App.vue";

document.addEventListener("DOMContentLoaded", () => {
  const mountedElement = document.querySelector("#app");
  new Vue({
    el: "#app",
    render: h => h(App, { props: { ...mountedElement.dataset } })
  });
});
