import ChildAges from '@/components/childAges'
import { mount } from '@vue/test-utils'

describe('ChildAges', () => {
  describe('verbose', () => {
    it('is correct for a single', () => {
      const wrapper = mount(ChildAges, {
        propsData: {
          singular: 'kid',
          plural: 'kids',
          childAges: [1],
          verbose: true
        }
      })
      const span = wrapper.find('span')
      expect(span.text()).toEqual('1 kid–age 1')
    })

    it('is correct for multiple', () => {
      const wrapper = mount(ChildAges, {
        propsData: {
          singular: 'kid',
          plural: 'kids',
          childAges: [2, 0, 4]
        }
      })
      const span = wrapper.find('span')
      expect(span.text()).toEqual('3 kids–ages 0, 2 and 4')
    })

    it('is correct for negative', () => {
      const wrapper = mount(ChildAges, {
        propsData: {
          singular: 'child',
          plural: 'children',
          childAges: [2, 0, -4, -1],
          verbose: true
        }
      })
      const span = wrapper.find('span')
      expect(span.text()).toEqual('2 children–ages 0 and 2')
    })

    it('is correct for no children', () => {
      const wrapper = mount(ChildAges, {
        propsData: {
          singular: 'child',
          plural: 'children',
          childAges: []
        }
      })
      const span = wrapper.find('span')
      expect(span.text()).toEqual('Expecting')
    })

    it('is correct for only negatives', () => {
      const wrapper = mount(ChildAges, {
        propsData: {
          singular: 'child',
          plural: 'children',
          childAges: [-3],
          verbose: true
        }
      })
      const span = wrapper.find('span')
      expect(span.text()).toEqual('Expecting')
    })

    it('takes a prefix', () => {
      const wrapper = mount(ChildAges, {
        propsData: {
          singular: 'child',
          plural: 'children',
          childAges: [-3],
          verbose: true,
          prefix: 'Parent to '
        }
      })
      const span = wrapper.find('span')
      expect(span.text()).toEqual('Expecting')
    })

    it('takes a prefix', () => {
      const wrapper = mount(ChildAges, {
        propsData: {
          singular: 'child',
          plural: 'children',
          childAges: [3, 2, 1, -9],
          verbose: true,
          prefix: 'Parent to '
        }
      })
      const span = wrapper.find('span')
      expect(span.text()).toEqual('Parent to 3 children–ages 1, 2 and 3')
    })
  })

  describe('not verbose', () => {
    it('is correct for only negatives', () => {
      const wrapper = mount(ChildAges, {
        propsData: {
          singular: 'kid',
          plural: 'kids',
          childAges: [-3],
          verbose: false
        }
      })
      const span = wrapper.find('span')
      expect(span.text()).toEqual('Expecting')
    })

    it('is correct for multiple', () => {
      const wrapper = mount(ChildAges, {
        propsData: {
          singular: 'child',
          plural: 'children',
          childAges: [3, 5, 1],
          verbose: false
        }
      })
      const span = wrapper.find('span')
      expect(span.text()).toEqual('3 children (1, 3, 5)')
    })

    it('is correct for negatives', () => {
      const wrapper = mount(ChildAges, {
        propsData: {
          singular: 'kid',
          plural: 'kids',
          childAges: [3, -5, 1],
          verbose: false
        }
      })
      const span = wrapper.find('span')
      expect(span.text()).toEqual('2 kids (1, 3)')
    })
  })
})
