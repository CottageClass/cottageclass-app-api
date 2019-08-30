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
import { fetchUpcomingEvents } from '@/utils/api'

export default {
  name: 'RequestChildcare',
  components: { StyleWrapper, CreateEvent, CreateChildcareRequest },
  mixins: [],
  props: ['stepName', 'section'],
  data () {
    return {
      myEvents: null
    }
  },
  computed: {
    stepSequence () {
      return [
        ''
      ]
    },
    ...mapGetters(['currentUser'])
  },
  methods: {
    async fetchMyUpcomingEvents () {
      this.myEvents = await fetchUpcomingEvents(this.currentUser.id)
    },
    skipEvent () {
      this.$router.push({ params: { section: 'request', stepName: null } })
    },
    completeEventCreation () {
      this.$router.push({ params: { section: 'request', stepName: null } })
    }
  },
  async created () {
    if (!this.section) {
      await this.fetchMyUpcomingEvents()
      if (this.myEvents && this.myEvents.length > 0) {
        this.$router.replace({ params: { section: 'request' } })
      } else {
        this.$router.replace({ params: { section: 'event' } })
      }
    }
  }
}
</script>

<style scoped>

</style>
