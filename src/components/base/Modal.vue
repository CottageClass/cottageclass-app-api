<!-- This is a wrapper around PureModal.  It supplies vuex data to the props of PureModal-->
<template>
  <PureModal v-if="modal" :title="modal.title" :bodyText="modal.bodyText" />
</template>

<script>
import { mapGetters } from 'vuex'
import PureModal from '@/components/base/PureModal'

export default {
  name: 'Modal',
  components: { PureModal },
  computed: mapGetters(['modal'])
}
</script>
