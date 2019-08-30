<template>
  <InterestedCard
    title="Can you attend?"
    :otherText="otherText"
    @primary-click="$emit('rsvp-yes')"
    @secondary-click="$emit('rsvp-no')"
    @other-click="$emit('wave')"
  />
</template>

<script>
import InterestedCard from '@/components/base/InterestedCard'
export default {
  name: 'RSVPCard',
  props: {
    otherText: {}
  },
  components: { InterestedCard }
}
</script>
