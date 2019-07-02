<template>
  <div class="onb-body">
    <div class="body">
      <div class="content-wrapper">
        <StyleWrapper styleIs="onboarding">
          <CreateEvent v-if="section==='event'"
                       :stepName="stepName"
                       @finished="completeEventCreation"
                       @skip="skipEvent"
                       context="request-childcare"
                       />
          <CreateChildcareRequest v-if="section==='request'"
                                  :stepName="stepName"
                                  />
        </StyleWrapper>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import StyleWrapper from '@/components/FTE/StyleWrapper'
import CreateEvent from '@/components/CreateEvent'
import CreateChildcareRequest from '@/components/CreateChildcareRequest'

export default {
  name: 'RequestChildcare',
  components: { StyleWrapper, CreateEvent, CreateChildcareRequest },
  mixins: [],
  props: ['stepName', 'section'],
  data () {
    return {
    }
  },
  computed: {
    stepSequence () {
      return [
        ''
      ]
    },
    ...mapGetters([])
  },
  methods: {
    skipEvent () {
      this.$router.push({ params: { section: 'request', stepName: null } })
    },
    completeEventCreation () {
      this.$router.push({ params: { section: 'request', stepName: null } })
    }
  },
  created () {
    if (!this.section) {
      this.$router.push({ params: { section: 'event' } })
    }
  }
}
</script>

<style scoped>

</style>
