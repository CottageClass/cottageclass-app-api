import { mount } from '@vue/test-utils'
import EventCategoryIcon from '@/components/base/EventCategoryIcon.vue'

describe('EventCategoryIcon', () => {
  let wrapper
  beforeAll(async () => {
    try {
      wrapper = await mount(EventCategoryIcon, {
        propsData: {
          category: 'baby playgroup', height: '100', width: '100'
        }
      })
    } catch (e) {
      throw (e)
    }
  })

  it('shows the right icon', () => {
    const img = wrapper.find('img')
    expect(img.attributes('height')).toEqual('100')
    expect(img.attributes('width')).toEqual('100')
    expect(wrapper.vm.iconImage).toEqual('hatching-chick.svg')
  })
})
