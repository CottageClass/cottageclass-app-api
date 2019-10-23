<template>
  <div class="body">
    <div class="content-wrapper">
      <StyleWrapper styleIs="onboarding">
        <Question
          class='rsvp-cancel-reason'
          title="Delete your account"
          subtitle="We really appreciate your feedback! Why are you leaving?"
        >
          <div class="form-describe-need w-form">
            <form v-on:submit.prevent id="email-form-2">
              <p class="describe-label">{{ charsLeft }} characters left...</p>
              <textarea v-model="reason" id="field" name="field" placeholder="e.g. 'I am moving to an island with no internet.  Forever....'" class="text-area-decribe-need w-input"></textarea>
            </form>
            <div class="action-bar">
              <button class="button feedback-button" @click="feedback">Just send feedback</button>
              <button class="button delete-button" @click="confirm">Delete account</button>
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
import { deleteUserAccount } from '@/utils/api'
import { submitToSheetsu } from '@/utils/vendor'
import { mapGetters } from 'vuex'
import { goHome } from '@/mixins'

export default {
  name: 'DeleteAccountConfirmation',
  components: { Question, StyleWrapper },
  props: ['eventId'],
  mixins: [ goHome ],
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
    sheetsuData () {
      return {
        'User ID': this.currentUser.id,
        'Reason for deletion': this.reason,
        'First name': this.currentUser.firstName,
        'Last name': this.currentUser.lastName,
        'Parent phone': this.currentUser.phone,
        'Parent email': this.currentUser.email
      }
    },
    ...mapGetters([ 'currentUser' ])
  },
  methods: {
    feedback () {
      const data = { type: 'Feedback Only', ...this.sheetsuData }
      submitToSheetsu(data, 'AccountDeletion')
      this.$store.commit('showAlertOnNextRoute', {
        alert: {
          message: 'Your feedback has been submitted.  Thank you',
          status: 'success'
        }
      })
      this.goHome()
    },
    async confirm () {
      try {
        deleteUserAccount({ id: this.currentUser.id })
        submitToSheetsu({ type: 'Full Deletion', ...this.sheetsuData }, 'AccountDeletion')
        this.$store.commit('showAlertOnNextRoute', {
          alert: {
            message: 'Your account has been deleted.  Thanks for using Lilypad',
            status: 'success'
          }
        })
        await this.$store.dispatch('establishUser', { JWT: null })
        this.$router.push({ name: 'SplashPage' })
      } catch (err) {
        console.log(err)
        throw err
      }
    }
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
