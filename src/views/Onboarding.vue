<template>
  <div class="onb-body">
    <div class="body">
      <div class="content-wrapper">
        <StyleWrapper styleIs="onboarding">
          <UserInformation v-if="section==='user-info'"
                           :stepName="stepName"
                           @finished="finishUserInfo"/>
          <CreateEvent v-if="section==='offering'"
                       :stepName="stepName"/>
        </StyleWrapper>
      </div>
    </div>
  </div>
</template>

<script>
import StyleWrapper from '@/components/FTE/StyleWrapper'
import UserInformation from '@/components/FTE/userInformation/UserInformation'
import CreateEvent from '@/components/CreateEvent'

import { mapGetters } from 'vuex'
import { } from '@/mixins'

export default {
  name: 'Onboarding',
  props: ['stepName', 'section'],
  components: { StyleWrapper, UserInformation, CreateEvent },
  mixins: [],
  data () {
    return {
    }
  },
  computed: {
    ...mapGetters([])
  },
  methods: {
    finishUserInfo (e) {
      if (e.offerNow) {
        this.$router.push({
          name: this.$route.name,
          params: { section: 'offering', stepName: null }
        })
      } else {
        this.$router.push({
          name: this.$route.name,
          params: { section: 'user-details', stepName: null }
        })
      }
    }
  },
  mounted () {
  }
}
</script>

<style scoped>

</style>
