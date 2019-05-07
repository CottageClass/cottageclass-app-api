<!-- This is a wrapper around PureModal.  It supplies vuex data to the props of PureModal-->
<template>
  <PureModal v-if="modal"
             :title="modal.title"
             :bodyText="modal.bodyText"
             :buttonNames=modal.buttonNames
             @primaryClick="primaryClickHandler"
             @secondaryClick="secondaryClickHandler"
             @closeButtonClick="hideModal"
             />
</template>

<script>
import { mapGetters } from 'vuex'
import PureModal from '@/components/base/PureModal'

export default {
  name: 'Modal',
  components: { PureModal },
  computed: mapGetters(['modal']),
  methods: {
    primaryClickHandler () {
      if (this.modal.primaryCallback) {
        this.modal.primaryCallback()
      } else {
        this.hideModal()
      }
    },
    secondaryClickHandler () {
      if (this.modal.secondaryCallback) {
        this.modal.secondaryCallback()
      } else {
        this.hideModal()
      }
    },
    hideModal () {
      this.modal.closeCallback && this.modal.closeCallback()
      this.$store.commit('hideModal')
    }
  }
}
</script>
