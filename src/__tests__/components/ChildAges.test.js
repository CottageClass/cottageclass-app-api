import ChildAges from '@/components/ChildAges'
import { mount } from '@vue/test-utils'

describe('ChildAges', () => {
  describe('verbose', () => {
    it('is correct for a single', () => {
      const wrapper = mount(ChildAges, {
        propsData: {
          singular: 'kid',
          plural: 'kids',
          childAgesInMonths: [1],
          verbose: true
        }
      })
      const span = wrapper.find('span')
      expect(span.text()).toEqual('1 kid–age 1 mo')
    })

    it('is correct for multiple', () => {
      const wrapper = mount(ChildAges, {
        propsData: {
          singular: 'kid',
          plural: 'kids',
          childAgesInMonths: [2, 110, 48]
        }
      })
      const span = wrapper.find('span')
      expect(span.text()).toEqual('3 kids–ages 2 mos, 4 and 9')
    })

    it('is correct for negative', () => {
      const wrapper = mount(ChildAges, {
        propsData: {
          singular: 'child',
          plural: 'children',
          childAgesInMonths: [24, 0, -4, -1],
          verbose: true
        }
      })
      const span = wrapper.find('span')
      expect(span.text()).toEqual('2 children–ages 0 mos and 2')
    })

    it('is correct for no children', () => {
      const wrapper = mount(ChildAges, {
        propsData: {
          singular: 'child',
          plural: 'children',
          childAgesInMonths: []
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
          childAgesInMonths: [-3],
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
          childAgesInMonths: [-3],
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
          childAgesInMonths: [3, 2, 1, -9],
          verbose: true,
          prefix: 'Parent to '
        }
      })
      const span = wrapper.find('span')
      expect(span.text()).toEqual('Parent to 3 children–ages 1 mo, 2 mos and 3 mos')
    })
  })

  describe('not verbose', () => {
    it('is correct for only negatives', () => {
      const wrapper = mount(ChildAges, {
        propsData: {
          singular: 'kid',
          plural: 'kids',
          childAgesInMonths: [-3],
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
          childAgesInMonths: [39, 51, 1],
          verbose: false
        }
      })
      const span = wrapper.find('span')
      expect(span.text()).toEqual('3 children (1 mo, 3, 4)')
    })

    it('is correct for negatives', () => {
      const wrapper = mount(ChildAges, {
        propsData: {
          singular: 'kid',
          plural: 'kids',
          childAgesInMonths: [40, -5, 1],
          verbose: false
        }
      })
      const span = wrapper.find('span')
      expect(span.text()).toEqual('2 kids (1 mo, 3)')
    })
  })
})
