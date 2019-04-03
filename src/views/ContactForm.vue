<template>
  <div class="onb-body">
    <div class="body">
      <div class="content-wrapper">
        <Nav
          button="next"
          @next="send"
          @prev="back"
        />
        <StyleWrapper styleIs="onboarding">
          <Question
            :title="'Contact ' + hostFirstName"
            subtitle="Put your question or comments to ari here.">
            <FormWithTextArea
              v-model="questionText"
              :placeholder="placeholderText" />
          </Question>
        </StyleWrapper>
      </div>
    </div>
  </div>
</template>

<script>
import StyleWrapper from '@/components/FTE/StyleWrapper.vue'
import Question from '@/components/base/Question.vue'
import FormWithTextArea from '@/components/base/FormWithTextArea.vue'
import Nav from '@/components/FTE/Nav.vue'

import { mapGetters } from 'vuex'
import * as api from '@/utils/api'
import moment from 'moment'
import _ from 'lodash'

export default {
  name: 'ContactForm',
  components: { Question, FormWithTextArea, StyleWrapper, Nav },
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
    placeholderText () {
      return `Enter your question here .....`
    },
    hostFirstName: function () {
      if (!this.event) {
        return null
      }
      return this.event.hostFirstName
    },
    hostId: function () {
      if (!this.event) {
        return null
      }
      return this.event.hostId
    },
    fullMessageText () {
      const senderFirstName = this.currentUser.firstName
      const childrenAges = this.currentUser.childAges
      let childrenCountAndAges
      if (childrenAges && childrenAges.length === 1) {
        childrenCountAndAges = `1 child age ${childrenAges[0]}`
      } else if (childrenAges && childrenAges.length > 1) {
        const ages = _.join(_.slice(childrenAges, 0, childrenAges.length - 1), ', ') + ' and ' + _.last(childrenAges)
        childrenCountAndAges = `${childrenAges.length} children ages ${ages}`
      }
      const dateString = moment(this.event.startsAt).format('L')
      const timeString = moment(this.event.startsAt).format('LT')

      const result = '(' + [senderFirstName, 'has', childrenCountAndAges, 'and has a question about your KidsClub playdate on', dateString, 'at', timeString].join(' ') + '.)\n'
      return result + this.questionText
    },
    ...mapGetters([ 'currentUser' ])
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
