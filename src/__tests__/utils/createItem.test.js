import { createItems } from '@/utils/createItem'

import normalize from 'json-api-normalizer'

const itemData = require('@/__mocks__/__mockData__/items.json')

describe('createItems', () => {
  it('returns the correct basic information', async () => {
    const items = createItems(normalize(itemData.data, { endpoint: 'item' }))
    expect(items[0].user.id).toBe('529')
    expect(items[0].childcareRequest.content).toBe('this guy')

    expect(items[1].user.id).toBe('50')
    expect(items[1].event.name).toBe('Aequitas quae celo. Alius adfero volaticus.')
  })
})
