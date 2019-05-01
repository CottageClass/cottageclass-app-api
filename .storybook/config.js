import { configure } from '@storybook/vue';
import '../src/assets/css/webflow.css'
import '../src/assets/css/normalize.css'

// automatically import all files ending in *.stories.js
const req = require.context('../src/stories', true, /\.stories\.js$/);
function loadStories() {
  req.keys().forEach(filename => req(filename));
}

configure(loadStories, module);
