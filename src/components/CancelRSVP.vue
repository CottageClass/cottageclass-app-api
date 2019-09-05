<template>

  <div class="body">
    <div class="content-wrapper">
      <StyleWrapper styleIs="onboarding">
        <Question
          class='rsvp-cancel-reason'
          title="Cancel your RSVP."
          subtitle="Please let us know in a few words why you won't be attending."
        >
          <div class="form-describe-need w-form">
            <form v-on:submit.prevent id="email-form-2">
              <p class="describe-label">{{ charsLeft }} characters left...</p>
              <textarea v-model="reason" id="field" name="field" placeholder="e.g. 'We had a change of plan and don't need care that afternoon.'" class="text-area-decribe-need w-input"></textarea>
            </form>
            <div class="action-bar">
              <button class="button nevermind-button" @click="nevermind">Nevermind</button>
              <button class="button cancel-button" @click="confirm">Cancel RSVP</button>
            </div>
          </div>
        </Question>
      </StyleWrapper>
    </div>
  </div>
</template>

<script>
import StyleWrapper from '@/components/FTE/StyleWrapper.vue'
import Question from '@/components/base/Question.vue'
import { fetchEvent } from '@/utils/api'
import { rsvp } from '@/mixins'
import { mapGetters } from 'vuex'

export default {
  name: 'CancelRSVP',
  components: { Question, StyleWrapper },
  props: ['eventId'],
  mixins: [rsvp],
  data: () => {
    return {
      reason: '',
      charLimit: 288,
      event: null
    }
  },
  watch: {
    reason: function () {
      if (this.reason && this.reason.length >= this.charLimit) {
        this.reason = this.reason.slice(this.charLimit)
      }
    },
    deep: true
  },
  computed: {
    charsLeft: function () {
      if (this.reason) {
        return this.charLimit - this.reason.length
      } else {
        return this.charLimit
      }
    },
    ...mapGetters([ 'currentUser' ])
  },
  methods: {
    nevermind: function () {
      this.$router.go(-1) // go back by one record
    },
    fetchEventInformation: async function () {
      try {
        this.event = await fetchEvent(this.eventId)
      } catch (e) {
        console.error(e)
      }
    },
    async confirm  () {
      try {
        await this.cancelRsvp(this.eventID)
        this.$store.commit('showAlertOnNextRoute', {
          alert: {
            message: 'Your RSVP has been canceled.',
            status: 'success'
          }
        })
        this.$router.push({
          name: 'YourPlaydates'
        })
      } catch (err) {
        this.showAlert('There was a problem canceling your participaton, please try again or contact us at \'contact@joinlilypad.com\'', 'failure')
      }
    }
  },
  mounted: function () {
    this.fetchEventInformation()
  }
}

</script>

<style scoped>
.body {
  background-color: #0d73c7;
}

.action-bar {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  width: 100%;
  margin-top: 24px;
  -webkit-box-pack: justify;
  -webkit-justify-content: space-between;
  -ms-flex-pack: justify;
  justify-content: space-between;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
}

.button {
  width: 50%;
  padding: 12px 32px;
  margin: 10px;
  border-radius: 4px;
  background-color: #fff;
  color: #1f88e9;
  font-size: 13px;
  font-weight: 700;
  text-align: center;
  letter-spacing: 1.2px;
  text-decoration: none;
  text-transform: uppercase;
}

.nevermind-button {
  margin-left: 0px;
}

.cancel-button {
  margin-right: 0px;
}

.button:hover {
  background-image: -webkit-gradient(
    linear,
    left top,
    left bottom,
    from(rgba(0, 0, 0, 0.1)),
    to(rgba(0, 0, 0, 0.1))
  );
  background-image: linear-gradient(
    180deg,
    rgba(0, 0, 0, 0.1),
    rgba(0, 0, 0, 0.1)
  );
}

.button:active {
  background-image: -webkit-gradient(
    linear,
    left top,
    left bottom,
    from(rgba(0, 0, 0, 0.1)),
    to(rgba(0, 0, 0, 0.1))
  );
  background-image: linear-gradient(
    180deg,
    rgba(0, 0, 0, 0.1),
    rgba(0, 0, 0, 0.1)
  );
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
