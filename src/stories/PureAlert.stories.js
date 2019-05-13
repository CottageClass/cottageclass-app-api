import { storiesOf } from '@storybook/vue'
import PureAlert from '../components/PureAlert.vue'
import Vue from 'vue'

import { withKnobs, text, boolean } from '@storybook/addon-knobs'

Vue.component('PureAlert', PureAlert)

storiesOf('PureAlert', module)
  .addDecorator(withKnobs)
  .add('as a component', () => ({
    components: { PureAlert },
    props: {
      show: {
        default: boolean('show?', true)
      },
      alert: {
        default: {
          message: text('Alert Body', 'Sample Title'),
          status: text('success or failure', 'success')
        }
      }
    },
    template: `<div style="height: 2000px;">
                 <div style="height: 200px;">
                   <PureAlert :alert="show && alert"/>
                   <p>some text to roll around</p>
                   <p>some text to roll around</p>
                   <p>some text to roll around</p>
                   <p>some text to roll around</p>
                   <p>some text to roll around</p>
                 </div>
               </div>`
  }))
