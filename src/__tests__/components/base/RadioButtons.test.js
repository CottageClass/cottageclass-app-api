import { mount } from '@vue/test-utils'
import RadioButtons from '@/components/base/RadioButtons.vue'

const prefix = 'rb-1-'

describe('RadioButtons', () => {
  let wrapper
  let value = ''
  beforeAll(async () => {
    wrapper = mount(RadioButtons, {
      propsData: {
        choices: ['hey', 'whatsup', 'hello'],
        value
      }
    })
  })

  it('mounts with the correct state', () => {
    const states = wrapper.findAll('input').wrappers.map(isChecked)
    for (let s of states) {
      expect(s).toBeFalsy()
    }
    expect(wrapper.vm.state).toBe(prefix)
    expect(wrapper.emitted().input).toHaveLength(1)
    expect(wrapper.emitted().input[0][0]).toEqual('')
  })

  it('sets the state with a click', () => {
    const heyInput = wrapper.find('input[value="rb-1-hey"]')
    heyInput.trigger('click')

    expect(wrapper.vm.state).toBe('rb-1-hey')
    expect(wrapper.emitted().input).toHaveLength(2)
    expect(wrapper.emitted().input[1][0]).toEqual('hey')
  })

  it('sets the state with a click', () => {
    const helloInput = wrapper.find('input[value="rb-1-hello"]')
    helloInput.trigger('click')

    expect(wrapper.vm.state).toBe('rb-1-hello')
    expect(wrapper.emitted().input).toHaveLength(3)
    expect(wrapper.emitted().input[2][0]).toEqual('hello')
  })
})

const isChecked = function (i) {
  return i.classes('active-checkbox')
}
