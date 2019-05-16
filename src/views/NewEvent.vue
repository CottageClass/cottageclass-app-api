<template>
  <div class="onb-body">
    <div class="content-wrapper">
      <Nav
        button="next"
        @next="nextStep"
        @prev="prevStep"
        :hidePrevious="false"
      />
      <StyleWrapper styleIs="onboarding">
        <EventDescription
          v-model="description" />

      </StyleWrapper>
    </div>
  </div>
</template>

<script>
import EventDescription from '@/components/base/eventSpecification/EventDescription'
import StyleWrapper from '@/components/FTE/StyleWrapper'
import Nav from '@/components/FTE/Nav'

import { mapGetters } from 'vuex'
export default {
  name: 'NewEvent',
  components: { EventDescription, StyleWrapper, Nav },
  data () {
    return {
      description: { err: null }
    }
  },
  conputed: {
    ...mapGetters([ 'currentUser', 'redirectRoute', 'firstCreatedEvent' ])
  },
  methods: {
    nextStep () {
    },
    prevStep () {
    }
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
  padding-top: 50px;
  padding-bottom: 50px;
  background-color: #1c8be7;
}
</style>
