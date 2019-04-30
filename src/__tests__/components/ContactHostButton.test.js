import { mount } from '@vue/test-utils'
import ContactHostButton from '@/components/ContactHostButton'

describe('ContactHostButton', () => {
  it('mounts with button', () => {
    const wrapper = mount(ContactHostButton, {
      stubs: ['router-link']
    })
    const button = wrapper.find('router-link-stub')

    expect(button.exists()).toBeTruthy()
    expect(button.text()).toEqual('Contact Host')
  })
})
