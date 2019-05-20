import { storiesOf } from '@storybook/vue'
import MultipleTimeSelector from '@/components/base/eventSpecification/MultipleTimeSelector'
import { withKnobs, number } from '@storybook/addon-knobs'
import Vue from 'vue'

Vue.component('MultipleTimeSelector', MultipleTimeSelector)

storiesOf('MultipleTimeSelector', module)
  .addDecorator(withKnobs)
  .add('as a component', () => ({
    components: { MultipleTimeSelector },
    props: {
      firstDisplay: {
        default: number('first weekHour', 60)
      }
    },
    template: '<MultipleTimeSelector :firstDisplay="firstDisplay" :selectedItems="Array(24 * 7).fill(false)"/>'
  }))
