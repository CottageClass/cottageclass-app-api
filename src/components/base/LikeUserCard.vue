<template>
  <InterestedCard
    :title="`Are you interested in a playdate with ${userFirstName}?`"
    :showPrimaryStar="false"
    primaryMessage="Send a message!"
    secondaryMessage="Not right now"
    @primary-click="$emit('contact-user-click')"
    @secondary-click="$emit('dislike-user-click')"
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
