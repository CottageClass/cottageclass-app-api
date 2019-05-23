<template>
  <div class="onb-body">
    <div class="content-wrapper">
      <StyleWrapper styleIs="onboarding">
      <CreateEvent :stepName="stepName"
                    @finished="completeCreation" />
      </StyleWrapper>
    </div>
  </div>
</template>

<script>
import StyleWrapper from '@/components/FTE/StyleWrapper'
import CreateEvent from '@/components/CreateEvent'

import { mapGetters } from 'vuex'
import { redirect } from '@/mixins'

export default {
  name: 'NewEvent',
  components: { StyleWrapper, CreateEvent },
  mixins: [redirect],
  props: ['stepName'],
  data () {
    return {
      showError: false,
      stepIndex: 0,
      event: null
    }
  },
  computed: mapGetters(['firstCreatedEvent']),
  methods: {
    completeCreation () {
      if (this.firstCreatedEvent) {
        this.$router.push({ name: 'SocialInvite', params: { id: this.firstCreatedEvent.id, context: 'newEvent' } })
      } else {
        this.$router.push({ name: 'Events' })
      }
    }
  },
  created () {
    this.redirectToSignupIfNotAuthenticated()
  }
}
</script>

<style scoped>

.onb-body {
  background-color: #0d73c7;
}

.content-wrapper {
  width: 720px;
  min-height: 100vh;
  margin-right: auto;
  margin-left: auto;
  padding-bottom: 50px;
  background-color: #1c8be7;
}
@media (max-width: 991px) {
  .content-wrapper {
    width: 670px;
  }
}

@media (max-width: 767px) {
  .content-wrapper {
    width: 100%;
    margin-top: 0px;
    margin-bottom: 0px;
  }
}
</style>
