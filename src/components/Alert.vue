<template>
  <PureAlert v-if="alert" :alert="alert" />
</template>

<script>
import { mapGetters } from 'vuex'
import PureAlert from '@/components/PureAlert'
export default {
  name: 'Alert',
  components: { PureAlert },
  computed: mapGetters([ 'alert' ])
}
</script>
