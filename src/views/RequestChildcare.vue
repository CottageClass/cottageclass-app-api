<template>
  <StyleWrapper styleIs="onboarding modal" >
    <div class="onb-body">

      <div class="body__request">

        <div class="content-wrapper__request">

          <CreateChildcareRequest v-if="section==='request'"
                                  v-on-clickaway="clickedAway"
                                  :stepName="stepName"
          />
          <MainNav />

        </div>

      </div>

    </div>
  </StyleWrapper>
</template>

<script>
import StyleWrapper from '@/components/FTE/StyleWrapper'
import CreateChildcareRequest from '@/components/CreateChildcareRequest'
import { mixin as clickaway } from 'vue-clickaway'

export default {
  name: 'RequestChildcare',
  components: { StyleWrapper, CreateChildcareRequest },
  mixins: [ clickaway ],
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
    }
  },

  methods: {
    clickedAway () {
      this.$router.push({ name: 'Search' })
    }
  },

  async created () {
    if (!this.section) {
      this.$router.replace({ params: { section: 'request' } })
    }
  }
}
</script>

<style scoped>
</style>
