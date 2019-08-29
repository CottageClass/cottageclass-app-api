<template>
  <InterestedCard
    title="Can you attend?"
    otherText="Say hi and Suggest another time"
    @primary-click="$emit('rsvp-yes')"
    @secondary-click="$emit('rsvp-no')"
    @other-click="$emit('wave')"
  />
</template>

<script>
import InterestedCard from '@/components/base/InterestedCard'
export default {
  name: 'RSVPCard',
  components: { InterestedCard }
}
</script>
