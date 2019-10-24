<template>
  <span>
    <MainNav />
    <div class="body body-2">
      <div class="content-container w-container">
        <div class="primary-container">
          <ErrorMessage
            v-if="showError && errors.first('password')"
            :messages="[errors.first('password')]"
            class="editing"
          />
          <h1 class="auth-heading">Reset Password</h1>
          <div>Please Enter your new password</div>
          <div class="auth-wrapper">
            <div class="form-block w-form">
              <form v-on:submit.prevent="submitRequest">
                <input
                  @keyup.enter="submitRequest"
                  v-validate.immediate="'required|min:4|max:128'"
                  type="password"
                  name="password"
                  v-model="password"
                  placeholder="Password"
                  :class="{'invalid': errors.has('password') }"
                  class="input-field w-input"
                >
                <button type="submit"
                        class="submit-button w-button">Reset Password</button>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
    <Footer />
  </span>
</template>

<script>
import ErrorMessage from '@/components/base/ErrorMessage.vue'
import MainNav from '@/components/MainNav.vue'
import Footer from '@/components/Footer.vue'

import { alerts, goHome } from '@/mixins'
import { submitNewPassword, signIn } from '@/utils/api'

export default {
  name: 'PasswordReset',
  components: { ErrorMessage, MainNav, Footer },
  mixins: [ alerts, goHome ],
  data: function () {
    return {
      password: '',
      showError: false
    }
  },
  computed: {
    isValid () {
      return !this.errors.first('password')
    }
  },
  methods: {
    async submitRequest (event) {
      if (!this.isValid) {
        this.showError = true
        return
      }
      event.preventDefault()
      try {
        const params = {
          user: {
            reset_password_token: this.$route.params.token,
            password: this.password
          }
        }
        const res = await submitNewPassword(params)

        const email = res.data.email
        const password = this.password
        const signInResult = await signIn({ email, password })
        this.log('auth success:', signIn)
        const JWT = signInResult.data[0]
        await this.$store.dispatch('establishUser', { JWT })
        await signIn({ email, password })
        this.showAlertOnNextRoute('Your password has been reset', 'success')
        this.goHome()
      } catch (err) {
        this.logError(err)
        this.showAlertOnNextRoute('Something went wrong.  Please contact us at contact@joinlilypad.com.', 'failure')
        this.$router.push({ name: 'SplashPage' })
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.body {
  font-family: soleil, sans-serif;
  color: #333;
  font-size: 14px;
  line-height: 20px;
}

h1 {
  margin-top: 20px;
  margin-bottom: 10px;
  font-size: 55px;
  line-height: 44px;
  font-weight: 700;
  text-align: center;
}
a {
  color: #1f88e9;
  text-decoration: none;
}

.body {
  overflow: visible;
  background-color: #fff;
  font-family: soleil, sans-serif;
}

.body-2 {
  background-color: #f6f6f6;
}

.links:hover {
  text-decoration: underline;
}
.content-container {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  margin-top: 0px;
  margin-bottom: 0px;
  padding: 32px 32px 60px;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  -webkit-flex-direction: column;
  -ms-flex-direction: column;
  flex-direction: column;
  -webkit-box-pack: start;
  -webkit-justify-content: flex-start;
  -ms-flex-pack: start;
  justify-content: flex-start;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
}

.auth-heading {
  margin-top: 0px;
  margin-bottom: 24px;
  font-size: 35px;
  line-height: 49px;
  text-align: center;
  letter-spacing: -0.5px;
}

.text-or {
  padding-right: 9px;
  padding-left: 8px;
}

.form-block {
  width: 100%;
  margin-top: 20px;
  margin-bottom: 20px;
}

.input-field {
  height: 44px;
  margin-bottom: 12px;
  border-style: solid;
  border-width: 1px;
  border-color: rgba(0, 0, 0, .15);
  border-radius: 4px;
  background-color: transparent;
  background-image: -webkit-gradient(linear, left top, left bottom, from(#fff), to(#fff));
  background-image: linear-gradient(180deg, #fff, #fff);
  font-size: 16px;
}

.submit-button {
  width: 100%;
  padding: 12px 32px;
  border-radius: 4px;
  background-color: #1f88e9;
}

.submit-button:hover {
  background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .1)), to(rgba(0, 0, 0, .1)));
  background-image: linear-gradient(180deg, rgba(0, 0, 0, .1), rgba(0, 0, 0, .1));
}

.submit-button:active {
  background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .1)), to(rgba(0, 0, 0, .1))), -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .1)), to(rgba(0, 0, 0, .1)));
  background-image: linear-gradient(180deg, rgba(0, 0, 0, .1), rgba(0, 0, 0, .1)), linear-gradient(180deg, rgba(0, 0, 0, .1), rgba(0, 0, 0, .1));
}

.success-message {
  background-color: #ccffe0;
}

.primary-container {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  width: 100%;
  padding: 32px 32px 44px;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  -webkit-flex-direction: column;
  -ms-flex-direction: column;
  flex-direction: column;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
  background-color: #fff;
}

.auth-wrapper {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  width: 300px;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  -webkit-flex-direction: column;
  -ms-flex-direction: column;
  flex-direction: column;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
}

.button-3 {
  border-style: solid;
  border-width: 1px;
  border-color: rgba(0, 0, 0, .15);
  border-radius: 4px;
  background-color: #fff;
  color: #000;
}

@media (max-width: 991px) {
  .content-container {
    padding: 0px 0px 100px;
  }
}

@media (max-width: 479px) {
  .primary-container {
    padding: 24px;
  }

  .body {
    padding-bottom: 110px;
  }
  .content-container {
    padding-bottom: 32px;
    background-color: #f4f4f4;
  }

  .auth-heading {
    font-size: 28px;
    line-height: 26px;
  }

  .auth-wrapper {
    width: 100%;
  }
}
</style>
