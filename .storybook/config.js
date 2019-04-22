import { configure } from '@storybook/vue';
import '../src/assets/css/webflow.css'
import '../src/assets/css/normalize.css'

const req = require.context('../src/stories', true, /\.stories\.js$/);
function loadStories() {
  req.keys().forEach(filename => req(filename));
}

configure(loadStories, module);
