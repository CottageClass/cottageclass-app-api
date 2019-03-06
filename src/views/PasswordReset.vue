<template>
<StyleWrapper styleIs="onboarding">
  <div class="onb-body">
    <div class="body">
      <div class="content-wrapper">
        <div class="title-bar">
          <a @click.prevent="$router.go(-1)" class="button-back w-inline-block"></a>
        </div>
        <div class="content-container">
          <ErrorMessage v-if="showError" text="Please enter a valid email or phone number" />

          <div class="onb-top-content-container">
            <h1 class="onb-heading-large">Reset Password</h1>
            <p>
              Please provide your kidsClub phone number or email and we will contact you to reset your password.
            </p>
          </div>

          <div class="onb-location-search-container">
            <div class="w-form">
              <form v-on:submit.prevent="submitRequest">
                <input
                  @keyup.enter="submitRequest"
                  v-validate="'email'"
                  name="email"
                  v-model="email"
                  placeholder="Email"
                  class="location-text-field w-input"
                >
                <p>or</p>
                <input
                  @keyup.enter="submitRequest"
                  v-model="phoneNumber"
                  type="tel"
                  placeholder="(555)-555-5555"
                  class="w-input location-text-field"
                  maxlength="30">
                <button type="submit" class="button-text splash-button w-inline-block">Reset Password</button>
              </form>
            </div>
          </div>

        </div>
      </div>
    </div>
  </div>
</StyleWrapper>
</template>

<script>
import ErrorMessage from '@/components/base/ErrorMessage.vue'
import StyleWrapper from '@/components/FTE/StyleWrapper.vue'
import {
  formatNumber,
  isValidNumber
} from 'libphonenumber-js'
import sheetsu from 'sheetsu-node'

// create a config file to identify which spreadsheet we push to.
var client = sheetsu({ address: 'https://sheetsu.com/apis/v1.0su/62cd725d6088' })

export default {
  name: 'ResetPassword',
  components: { ErrorMessage, StyleWrapper },
  data: function () {
    return {
      email: '',
      phoneNumber: '',
      showError: false,
      errorMessage: null
    }
  },
  methods: {
    submitRequest: function (event) {
      event.preventDefault()
      let component = this
      this.$validator.validate('email').then(res => {
        if (res && component.email) {
          const email = component.email && component.email.trim().toLowerCase()
          this.submitInfo({ email })
        } else if (component.isValidPhoneNumber) {
          const number = component.formattedNumberUsa
          this.submitInfo({ number })
        } else {
          component.showError = true
        }
      }).catch(function (error) {
        console.log(error)
        component.showError = true
      })
    },
    submitInfo: function (data) {
      client.create(data, 'passwordResetRequests').then((data) => {
        console.log(data)
        this.$router.push({ name: 'Home' })
      }, (err) => {
        console.log(err)
        this.$router.push({ name: 'Home' })
      })
    }
  },
  computed: {
    formattedNumberUsa: function () {
      // still have to slice the country code off
      let num = this.phoneNumber.replace(/[^\d]/g, '')
      if (num && num[0] === '1' && num.length === 11) {
        num = num.slice(1, num.length)
      }
      return formatNumber({ country: 'US', phone: num }, 'National')
    },
    isValidPhoneNumber: function () {
      return !!this.phoneNumber && isValidNumber(this.phoneNumber, 'US')
    }
  }
}
</script>

<style lang="scss" scoped>

.body {
  font-family: soleil
}

.content-wrapper {
  position: 0px;
  padding-top: 0px;
}

p {
  text-align: center;
  color: white;
}
p a {
  text-decoration: underline;
}

button {
  background: none;
}

.splash-button {
  background-color: white;
  width: 100%;
}

.content-container {
  padding-top: 83px;
}

input.invalid {
  border: 1px solid red;
}

.button-back {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  margin-top: 7px;
  margin-bottom: 8px;
  margin-left: 10px;
  padding: 18px;
  -webkit-box-pack: justify;
  -webkit-justify-content: space-between;
  -ms-flex-pack: justify;
  justify-content: space-between;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
  border-radius: 4px;
  background-color: transparent;
  background-image: url('../assets/arrow-back-white.svg');
  background-position: 50% 50%;
  background-size: 24px 24px;
  background-repeat: no-repeat;
  color: #1f88e9;
}

.button-back:active {
  background-color: hsla(0, 0%, 100%, .2);
  background-image: url('../assets/arrow-back-white.svg');
  background-size: 24px;
}
</style>
