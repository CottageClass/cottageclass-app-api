<template>
  <div class="onb-body">
    <StyleWrapper styleIs="onboarding">
      <div class="body">
        <div class="content-wrapper">
          <Nav
            :button="nextButtonState"
            @next="send"
            @prev="back"
          />
          <LoadingSpinner v-if="!event"/>
          <Question v-else
            :title="'Contact ' + hostFirstName"
            :subtitle="`Enter your question to ${hostFirstName} below. They’ll reply by text message as soon as they can!`">
            <FormWithTextArea
              v-model="questionText"
              :placeholder="placeholderText" />
          </Question>
        </div>
      </div>
    </StyleWrapper>
  </div>
</template>

<script>
import StyleWrapper from '@/components/FTE/StyleWrapper.vue'
import Question from '@/components/base/Question.vue'
import FormWithTextArea from '@/components/base/FormWithTextArea.vue'
import Nav from '@/components/FTE/Nav.vue'

import LoadingSpinner from '@/components/LoadingSpinner.vue'
import { redirect } from '@/mixins'
import { mapGetters } from 'vuex'
import * as api from '@/utils/api'
import { childAgeText, capitalize } from '@/utils/utils'
import moment from 'moment'

export default {
  name: 'ContactForm',
  mixins: [redirect],
  components: { Question, FormWithTextArea, StyleWrapper, Nav, LoadingSpinner },
  props: ['eventId'],
  data () {
    return {
      event: null,
      questionText: ''
    }
  },
  mounted: function () {
    api.fetchEvents(this.eventId).then(res => {
      this.event = res[0]
    })
  },
  methods: {
    send () {
      api.initProxySession(
        this.currentUser.id,
        parseInt(this.event.hostId),
        this.fullMessageText,
        this.acknowledgmentMessage()
      ).then(res => {
        this.$store.commit('showAlertOnNextRoute', {
          alert: {
            message: 'Your message has been sent',
            status: 'success'
          }
        })
        this.$router.push({
          name: 'EventPage',
          params: { id: this.event.id }
        })
      })
    },
    back () {
      this.$router.go(-1)
    },
    acknowledgmentMessage: function () {
      let msg = `We've just sent your question to ${this.event.hostFirstName} and they'll respond soon! You can follow up by texting this number.`
      return msg
    }
  },
  computed: {
    nextButtonState () {
      return (this.questionText === '') ? 'inactive' : 'next'
    },
    placeholderText () {
      return `Enter your question here ...`
    },
    hostFirstName: function () {
      if (!this.event || !this.event.hostFirstName) {
        return ''
      }
      return capitalize(this.event.hostFirstName)
    },
    hostId: function () {
      if (!this.event) {
        return null
      }
      return this.event.hostId
    },
    fullMessageText () {
      const childText = childAgeText({
        childAges: this.currentUser.childAges,
        singular: 'child',
        plural: 'children',
        prefix: 'has ',
        verbose: true,
        expectingPrefix: 'is '
      })

      const senderFirstName = this.currentUser.firstName
      const dateString = moment(this.event.startsAt).format('L')
      const timeString = moment(this.event.startsAt).format('LT')

      const result = '(' + [senderFirstName, childText, 'and has a question about your KidsClub playdate on', dateString, 'at', timeString].join(' ') + '.)\n'
      return result + this.questionText
    },
    ...mapGetters([ 'currentUser' ])
  },
  created () {
    this.redirectToSignupIfNotAuthenticated()
  }
}
</script>

<style>

.content-wrapper {
  width: 720px;
  min-height: 100vh;
  margin-right: auto;
  margin-left: auto;
  padding-top: 50px;
  padding-bottom: 50px;
  background-color: #1c8be7;
}

.body {
  background-color: #0d73c7;
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
