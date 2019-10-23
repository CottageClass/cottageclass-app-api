<template>
  <div class="onb-body">
    <div class="body">
      <div class="content-wrapper">
        <StyleWrapper styleIs="onboarding">
          <Nav
            :button="nextButtonState"
            @next="nextStep"
            :hidePrevious="true"
          />
          <ErrorMessage v-if="errorMessage && showError" :text="errorMessage" />
          <ProfileBlurb v-if="profileBlurb!==null" v-model="profileBlurb" />
        </StyleWrapper>
      </div>
    </div>
  </div>
</template>

<script>
import StyleWrapper from '@/components/FTE/StyleWrapper'
import Nav from '@/components/FTE/Nav'
import ProfileBlurb from '@/components/FTE/userInformation/ProfileBlurb.vue'
import ErrorMessage from '@/components/base/ErrorMessage.vue'

import normalize from 'json-api-normalizer'
import { submitUserInfo } from '@/utils/api'
import { createUser } from '@/utils//createUser'
import { mapGetters, mapMutations } from 'vuex'
import { goHome } from '@/mixins'

export default {
  name: 'ProfileCollection',
  components: { StyleWrapper, Nav, ProfileBlurb, ErrorMessage },
  mixins: [ goHome ],
  data () {
    return {
      showError: false,
      profileBlurb: null
    }
  },
  computed: {
    nextButtonState () {
      if (!this.profileBlurb || this.profileBlurb.err) {
        return 'inactive'
      } else {
        return 'next'
      }
    },
    errorMessage () {
      return this.profileBlurb && this.profileBlurb.err
    },
    ...mapGetters(['currentUser'])
  },
  methods: {
    async nextStep () {
      if (this.profileBlurb.err) {
        this.showError = true
      } else {
        try {
          const params = { profileBlurb: this.profileBlurb.text }
          const res = await submitUserInfo(this.currentUser.id, params)
          this.setCurrentUser({ user: createUser(normalize(res.data)) })
        } catch (e) {
          this.logError(e)
        }
        this.goHome()
      }
    },
    ...mapMutations([ 'setCurrentUser' ])
  },
  mounted () {
    this.profileBlurb = { text: this.currentUser.profileBlurb || '' }
  },
  created () {
    if (!this.currentUser) {
      this.goHome()
    }
  }
}
</script>
