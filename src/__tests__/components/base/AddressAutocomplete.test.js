import { mount } from '@vue/test-utils'
import AddressAutocomplete from '@/components/base/AddressAutocomplete.vue'

describe('EventCategoryIcon', () => {
  let wrapper
  beforeAll(async () => {
    try {
      wrapper = await mount(AddressAutocomplete)
    } catch (e) {
      throw (e)
    }
  })

  it('has an input field', () => {
    const input = wrapper.find('input')
    expect(input).not.toBeNull()
  })

  it('has a button to sumbit which is inactive at first', () => {
    const button = wrapper.find('div.w-button')
    button.trigger('click')

    expect(button).not.toBeNull()
    expect(wrapper.emitted('addressSubmitted')).toBeFalsy()
  })
})
