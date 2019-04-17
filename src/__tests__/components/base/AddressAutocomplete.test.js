import { shallowMount } from '@vue/test-utils'
import AddressAutocomplete from '@/components/base/AddressAutocomplete.vue'

describe('EventCategoryIcon', () => {
  let wrapper
  beforeAll(async () => {
    try {
      wrapper = await shallowMount(AddressAutocomplete)
    } catch (e) {
      throw (e)
    }
  })

  it('has an input field', () => {
    const input = wrapper.find('input')
    expect(input).not.toBeNull()
  })

  it('has no button', () => {
    const button = wrapper.find('input.submitButton')
    expect(button.exists()).toBeFalsy()
  })
})
