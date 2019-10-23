<template>
  <div class="onb-body">
    <ProfileBlurb v-if="profileBlurb!==null" v-model="profileBlurb" />
  </div>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex'
import normalize from 'json-api-normalizer'

import ProfileBlurb from '@/components/FTE/userInformation/ProfileBlurb.vue'

import { submitUserInfo } from '@/utils/api'
import { createUser } from '@/utils//createUser'

import { goHome, validationError } from '@/mixins'

export default {
  name: 'ProfileCollection',
  mixins: [ goHome, validationError ],
  components: { ProfileBlurb },
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
    validationError () {
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
  watch: {
    nextButtonState: {
      handler () {
        this.$emit('set-nav-props', {
          button: this.nextButtonState
        })
      },
      immediate: true
    }
  },
  created () {
    this.$emit('set-nav-props', {
      nextButtonHandler: this.nextStep,
      hidePrevious: true
    })
    if (!this.currentUser) {
      this.goHome()
    }
  }
}
</script>
