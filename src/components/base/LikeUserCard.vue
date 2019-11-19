<template>
  <InterestedCard
    :title="`Are you interested in a playdate with ${userFirstName}?`"
    :showPrimaryStar="false"
    primaryMessage="Send a message!"
    secondaryMessage="Not right now"
    @primary-click="$emit('primary-button-click')"
    @secondary-click="$emit('secondary-button-click')"
  />
</template>

<script>
import InterestedCard from '@/components/base/InterestedCard'
export default {
  name: 'LikeUserCard',
  components: { InterestedCard },
  props: {
    userFirstName: {
      type: String,
      required: true
    }
  }
}
</script>
