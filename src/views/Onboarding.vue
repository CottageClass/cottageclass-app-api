<template>
  <div class="onb-body">
    <div class="body">
      <div class="content-wrapper">
        <StyleWrapper styleIs="onboarding">
          <UserInformation :stepName="stepName"/>
        </StyleWrapper>
      </div>
    </div>
  </div>
</template>

<script>
import StyleWrapper from '@/components/FTE/StyleWrapper'
import UserInformation from '@/components/FTE/userInformation/UserInformation'

import { mapGetters } from 'vuex'
import { } from '@/mixins'

export default {
  name: 'Onboarding',
  props: ['stepName'],
  components: { StyleWrapper, UserInformation },
  mixins: [],
  data () {
    return {
    }
  },
  computed: {
    ...mapGetters([])
  },
  methods: {
    nextStep () {
    },
    prevStep () {
    }
  },
  mounted () {
  }
}
</script>

<style scoped>

</style>
