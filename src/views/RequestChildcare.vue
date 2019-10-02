<template>
  <div class="onb-body">
    <div class="body">
      <div class="content-wrapper">
        <StyleWrapper styleIs="onboarding">
          <CreateChildcareRequest v-if="section==='request'"
                                  :stepName="stepName"
          />
        </StyleWrapper>
      </div>
    </div>
  </div>
</template>

<script>
import StyleWrapper from '@/components/FTE/StyleWrapper'
import CreateChildcareRequest from '@/components/CreateChildcareRequest'

export default {
  name: 'RequestChildcare',
  components: { StyleWrapper, CreateChildcareRequest },
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
