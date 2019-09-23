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
          <LoadingSpinner v-if="!event && !user"/>
          <Question v-else
                    :title="'Contact ' + recipientFirstName"
                    :subtitle="`Enter your message to ${recipientFirstName} below. They’ll reply by text message as soon as they can!`">
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
import { initProxySession, fetchEvent, fetchUser } from '@/utils/api'
import { childAgeText, capitalize } from '@/utils/utils'
import moment from 'moment'

export default {
  name: 'ContactForm',
  mixins: [redirect],
  components: { Question, FormWithTextArea, StyleWrapper, Nav, LoadingSpinner },
  props: ['eventId', 'userId'],
  data () {
    return {
      event: null,
      user: null,
      questionText: ''
    }
  },
  async mounted () {
    if (this.eventId) {
      const res = await fetchEvent(this.eventId)
      this.event = res
    } else if (this.userId) {
      const res = await fetchUser(this.userId)
      console.log(res)
      this.user = res
    } else {
      throw Error('no user or event provided')
    }
  },
  methods: {
    async send () {
      await initProxySession(
        this.currentUser.id,
        parseInt(this.hostId),
        this.fullMessageText,
        this.acknowledgmentMessage()
      )
      this.$store.commit('showAlertOnNextRoute', {
        alert: {
          message: 'Your message has been sent',
          status: 'success'
        }
      })
      if (this.event) {
        this.$router.push({
          name: 'EventPage',
          params: { id: this.event.id }
        })
      } else if (this.user) {
        this.$router.push({
          name: 'UserPage',
          params: { id: this.user.id }
        })
      }
    },
    back () {
      this.$router.go(-1)
    },
    acknowledgmentMessage: function () {
      let msg = `We've just sent your message to ${this.recipientFirstName} and they'll respond soon! You can follow up by texting this number.`
      return msg
    }
  },
  computed: {
    recipientFirstName () {
      return capitalize((this.event && this.event.hostFirstName) || (this.user && this.user.firstName))
    },
    nextButtonState () {
      return (this.questionText === '') ? 'inactive' : 'next'
    },
    placeholderText () {
      return `Enter your message here ...`
    },
    hostId: function () {
      return (this.event && this.event.hostId) || (this.user && this.user.id)
    },
    fullMessageText () {
      const childText = childAgeText({
        childAgesInMonths: this.currentUser.childAgesInMonths,
        singular: 'child',
        plural: 'children',
        prefix: 'has ',
        verbose: true,
        expectingPrefix: 'is '
      })

      const senderFirstName = this.currentUser.firstName

      if (this.event) {
        const dateString = moment(this.event.startsAt).format('L')
        const timeString = moment(this.event.startsAt).format('LT')
        const result = '(' + [senderFirstName, childText, 'and has a message about your Lilypad playdate on', dateString, 'at', timeString].join(' ') + '.)\n'
        return result + this.questionText
      } else {
        const result = '(' + [senderFirstName, childText, 'and has a message'].join(' ') + '.)\n'
        return result + this.questionText
      }
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
  position: relative;
  left: 0%;
  top: 40px;
  right: 0%;
  bottom: auto;
  z-index: 1000;
  display: flex;
  width: 876px;
  min-height: 500px;
  margin: 0 auto 100px;
  flex-direction: column;
  border-radius: 4px;
  background-color: #fff;
  box-shadow: 1px 1px 35px 0 rgba(0, 0, 0, 0.2);
}

.body {
  background-color: #f6f6f6;
}

@media (max-width: 991px) {
  .content-wrapper {
    width: auto;
    margin-right: 32px;
    margin-left: 32px;
  }
}

@media (max-width: 479px) {
  .content-wrapper {
    margin-top: 28px;
  }
}

</style>
