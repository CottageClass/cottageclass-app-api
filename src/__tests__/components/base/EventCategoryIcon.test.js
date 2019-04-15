import { mount } from '@vue/test-utils'
import EventCategoryIcon from '@/components/base/EventCategoryIcon.vue'

describe('EventCategoryIcon', () => {
  let wrapper
  beforeAll(async () => {
    try {
    } catch (e) {
      throw (e)
    }
  })

  it('shows the right icon for Arts & Crafts', async () => {
    const wrapper = await mount(EventCategoryIcon, {
      propsData: { category: 'Arts & Crafts', height: '100', width: '100' }
    })
    const img = wrapper.find('img')
    expect(img.attributes('height')).toEqual('100')
    expect(img.attributes('width')).toEqual('100')
    expect(wrapper.vm.iconImage).toEqual('artist-palette.svg')
  })

  it('shows the right icon for Baby playgroup', async () => {
    const wrapper = await mount(EventCategoryIcon, {
      propsData: { category: 'Baby playgroup', height: '100', width: '100' }
    })
    expect(wrapper.vm.iconImage).toEqual('hatching-chick.svg')
  })

  it('shows the right icon for Books & Storytime', async () => {
    const wrapper = await mount(EventCategoryIcon, {
      propsData: { category: 'Books & Storytime', height: '100', width: '100' }
    })
    expect(wrapper.vm.iconImage).toEqual('books.svg')
  })

  it('shows the right icon for Drawing & Coloring', async () => {
    const wrapper = await mount(EventCategoryIcon, {
      propsData: { category: 'Drawing & Coloring', height: '100', width: '100' }
    })
    expect(wrapper.vm.iconImage).toEqual('crayon.svg')
  })

  it('shows the right icon for Games & Puzzles', async () => {
    const wrapper = await mount(EventCategoryIcon, {
      propsData: { category: 'Games & Puzzles', height: '100', width: '100' }
    })
    expect(wrapper.vm.iconImage).toEqual('chess-pawn.svg')
  })

  it('shows the right icon for Kids\' Movie Night', async () => {
    const wrapper = await mount(EventCategoryIcon, {
      propsData: { category: 'Kids\' Movie Night', height: '100', width: '100' }
    })
    expect(wrapper.vm.iconImage).toEqual('movie-camera.svg')
  })

  it('shows the right icon for Playing outside (weather permitting)', async () => {
    const wrapper = await mount(EventCategoryIcon, {
      propsData: { category: 'Playing outside (weather permitting)', height: '100', width: '100' }
    })
    expect(wrapper.vm.iconImage).toEqual('sun-behind-small-cloud.svg')
  })

  it('shows the right icon for Playground Meetup', async () => {
    const wrapper = await mount(EventCategoryIcon, {
      propsData: { category: 'Playground Meetup', height: '100', width: '100' }
    })
    expect(wrapper.vm.iconImage).toEqual('monkey.svg')
  })

  it('shows the right icon for Waldorf Nature Walk', async () => {
    const wrapper = await mount(EventCategoryIcon, {
      propsData: { category: 'Waldorf Nature Walk', height: '100', width: '100' }
    })
    expect(wrapper.vm.iconImage).toEqual('seedling.svg')
  })
})
