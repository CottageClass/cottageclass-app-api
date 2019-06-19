<template>
  <span id="top">
    <MainNav />
      <div class="body body-2">
          <div class="content-container w-container">
            <div class="primary-container">
              <StyleWrapper styleIs="onboarding">
                <ErrorMessage
                  v-if="showError && (errors.first('email') || errors.first('password')) || errorMessage"
                  :messages="errorMessages"
                  />
              </StyleWrapper>
            <h1 class="auth-heading">Log In</h1>
            <div class="auth-wrapper">
              <FacebookButton v-if="false" />
               <span v-if="false">
                <div class="divider-container">
                  <div class="divider-1px-2"></div>
                  <div class="or-container">
                    <div class="divider-text">OR</div>
                  </div>
                  <div class="divider-1px-2"></div>
                </div>
                <div>Log in with your email</div>
              </span>
              <div class="form-block w-form">
              <form id="email-form" v-on:submit.prevent="signIn">
              <input
                v-validate="'required|email'"
                name="email"
                v-model="email"
                placeholder="Email"
                type="email"
                class="input-field w-input"
                :class="{'invalid': errors.has('email') }"
              >
              <input
                v-validate="'required'"
                type="password"
                name="password"
                v-model="password"
                placeholder="Password"
                :class="{'invalid': errors.has('password') }"
                class="input-field w-input"
              >
                <button type="submit" class="submit-button w-button">Log in</button>
            </form>
              </div>
              <div class="auth-links"><router-link :to="{ name: 'PasswordReset'}" href="">Forgot password?<br></router-link>No account? <a href="" @click.prevent="$router.push({ name: 'SignUp' })">Get started for free!</a></div>
            </div>
          </div>
        </div>
      </div>
    <Footer />
  </span>
</template>

<script>
import ErrorMessage from '@/components/base/ErrorMessage.vue'
import StyleWrapper from '@/components/FTE/StyleWrapper.vue'
import FacebookButton from '@/components/base/FacebookButton'
import Footer from '@/components/Footer.vue'
import MainNav from '@/components/MainNav.vue'
import { providerAuthentication } from '@/mixins'
import { mapGetters } from 'vuex'
import { signIn } from '@/utils/api'

export default {
  name: 'SignInWithEmail',
  components: { ErrorMessage, StyleWrapper, MainNav, Footer, FacebookButton },
  mixins: [ providerAuthentication ],
  data: function () {
    return {
      email: '',
      password: '',
      showError: false,
      errorMessage: null,
      showFacebookLogin: !this.hideFacebookLogin()
    }
  },
  mounted: function () {
    if (this.isAuthenticated) {
      if (this.currentUser.hasAllRequiredFields) {
        this.$router.push({ name: 'Search' })
      } else if (this.currentUser.id) {
        this.$router.push({ name: 'Onboarding' })
      } else {
        return false
      }
    } else {
      this.log('current user does not exist')
    }
    // override for better error messages on this screen and on signup screen.
    // note: changes here affect all vee-validate error messages until page reload.
    const dict = {
      custom: {
        email: {
          required: 'Please enter your email address.',
          email: 'Please enter a valid email address.'
        },
        first_name: {
          required: 'Please enter your first name.'
        },
        last_name: {
          required: 'Please enter your last name.'
        },
        password: {
          required: 'Please choose a password.'
        },
        avatar: {
          required: 'You must add a profile photo, below.'
        }
      }
    }
    // Override and merge the dictionaries
    this.$validator.localize('en', dict)
  },
  methods: {
    hideFacebookLogin: () => {
      return ['(iPhone|iPod|iPad)(?!.*Safari)'].every(expression => {
        return !!navigator.userAgent.match(new RegExp(`(${expression})`, 'ig'))
      })
    },
    async signIn (event) {
      event.preventDefault()
      let validationResult, signInResult
      try {
        validationResult = await this.$validator.validateAll()
      } catch (e) {
        this.logError('validation error')
        this.logError(e)
      }
      if (validationResult) {
        let email = this.email && this.email.trim().toLowerCase()
        let password = this.password && this.password.trim()
        try {
          signInResult = await signIn({ email, password })
          this.log('auth success:', signIn)
          const JWT = signInResult.data[0]
          await this.$store.dispatch('establishUser', { JWT })
          this.redirectOrProceed()
        } catch (e) {
          this.logError('Authentication Error')
          this.logError(e)
          this.showError = true
          this.$scrollTo('#top')
          this.errorMessage = 'There was a problem signing you in. If you forgot your password, email contact@cottageclass.com for help.'
        }
      } else {
        this.$scrollTo('#top')
        this.showError = true
      }
    }
  },
  computed: {
    errorMessages () {
      const res = []
      if (this.errorMessage && this.errorMessage.length) {
        res.push(this.errorMessage)
      }
      if (this.errors.first('email') && this.errors.first('email').length) {
        res.push(this.errors.first('email'))
      }
      if (this.errors.first('password') && this.errors.first('password').length) {
        res.push(this.errors.first('password'))
      }
      return res
    },
    ...mapGetters(['currentUser', 'isAuthenticated'])
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

h2 {
  margin-top: 20px;
  margin-bottom: 10px;
  font-size: 32px;
  line-height: 36px;
  font-weight: bold;
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

.div-block-32 {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
}

.divider-2px {
  width: 100%;
  height: 2px;
  background-color: #f3f3f3;
}

.content-container-2 {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  margin-top: 0px;
  margin-bottom: 0px;
  padding: 112px 32px;
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

.div-block-33 {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  margin-bottom: 99px;
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

.text-block {
  margin-left: 10px;
  line-height: 19px;
}

.body-2 {
  background-color: #f6f6f6;
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

.content-container-3 {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  margin-top: 0px;
  margin-bottom: 0px;
  padding: 112px 32px;
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

.links:hover {
  text-decoration: underline;
}

.heading-2 {
  margin-top: 0px;
  font-size: 24px;
}

.div-block-38 {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  width: 200px;
  height: 200px;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  -webkit-flex-direction: row;
  -ms-flex-direction: row;
  flex-direction: row;
  -webkit-box-pack: center;
  -webkit-justify-content: center;
  -ms-flex-pack: center;
  justify-content: center;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
}

.button-container {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  width: 30%;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  -webkit-flex-direction: column;
  -ms-flex-direction: column;
  flex-direction: column;
}

.container-2 {
  position: relative;
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  padding: 24px 32px;
  -webkit-box-pack: justify;
  -webkit-justify-content: space-between;
  -ms-flex-pack: justify;
  justify-content: space-between;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
}

.button-2 {
  min-height: 40px;
  margin-left: 16px;
  border: 1px solid #c2c2c2;
  border-radius: 4px;
  background-color: #fff;
  color: #000;
  font-size: 12px;
  letter-spacing: 2px;
  text-transform: uppercase;
}

.button-2:hover {
  background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .04)), to(rgba(0, 0, 0, .04)));
  background-image: linear-gradient(180deg, rgba(0, 0, 0, .04), rgba(0, 0, 0, .04));
}

.button-2:active {
  border-color: #1f88e9;
  background-color: #1f88e9;
  background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .1)), to(rgba(0, 0, 0, .1)));
  background-image: linear-gradient(180deg, rgba(0, 0, 0, .1), rgba(0, 0, 0, .1));
  color: #fff;
}

.divider-1px {
  width: 100%;
  min-height: 1px;
  margin-top: 32px;
  background-color: rgba(0, 0, 0, .06);
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

.divider-container {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  width: 100%;
  margin-top: 8px;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
}

.div-block-39 {
  background-color: rgba(0, 0, 0, .06);
}

.divider-1px-2 {
  width: 100%;
  min-height: 1px;
  background-color: rgba(0, 0, 0, .1);
}

.text-or {
  padding-right: 9px;
  padding-left: 8px;
}

.or-container {
  padding: 16px;
}

.divider-text {
  color: rgba(0, 0, 0, .4);
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

.text-field-2 {
  height: 48px;
  border-radius: 4px;
  font-size: 16px;
}

.auth-links {
  line-height: 26px;
  text-align: center;
}

.text-block-2 {
  font-size: 13px;
}

.success-message {
  background-color: #ccffe0;
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

.div-block-40 {
  max-height: 80px;
  max-width: 80px;
  min-height: 80px;
  min-width: 80px;
  margin-bottom: 16px;
}

@media (max-width: 991px) {
  .div-block-32 {
    width: 40%;
    padding: 24px 32px;
    -webkit-box-orient: vertical;
    -webkit-box-direction: normal;
    -webkit-flex-direction: column;
    -ms-flex-direction: column;
    flex-direction: column;
    -webkit-box-align: start;
    -webkit-align-items: flex-start;
    -ms-flex-align: start;
    align-items: flex-start;
    border-top: 1px solid #f4f4f4;
    background-color: #fff;
    box-shadow: 0 14px 20px 0 rgba(0, 0, 0, .11);
  }

  .content-container-2 {
    padding-top: 60px;
    padding-bottom: 60px;
  }

  .content-container-3 {
    padding-top: 60px;
    padding-bottom: 60px;
  }

  .button-container {
    -webkit-box-pack: end;
    -webkit-justify-content: flex-end;
    -ms-flex-pack: end;
    justify-content: flex-end;
  }

  .content-container {
    padding-top: 32px;
    padding-bottom: 128px;
  }
}

@media (max-width: 767px) {
  .body {
    padding-bottom: 100px;
  }

  .div-block-32 {
    width: 260px;
    margin-right: 32px;
  }

  .content-container-2 {
    padding-right: 32px;
    padding-left: 32px;
  }

  .content-container-3 {
    padding-right: 32px;
    padding-bottom: 100px;
    padding-left: 32px;
  }

  .heading-2 {
    font-size: 20px;
    line-height: 26px;
  }

  .div-block-37 {
    display: -webkit-box;
    display: -webkit-flex;
    display: -ms-flexbox;
    display: flex;
    -webkit-box-orient: vertical;
    -webkit-box-direction: normal;
    -webkit-flex-direction: column;
    -ms-flex-direction: column;
    flex-direction: column;
    -webkit-box-pack: center;
    -webkit-justify-content: center;
    -ms-flex-pack: center;
    justify-content: center;
    -webkit-box-align: center;
    -webkit-align-items: center;
    -ms-flex-align: center;
    align-items: center;
  }

  .button-container {
    width: 100%;
    margin-top: 16px;
    -webkit-box-orient: horizontal;
    -webkit-box-direction: normal;
    -webkit-flex-direction: row;
    -ms-flex-direction: row;
    flex-direction: row;
    -webkit-align-self: flex-end;
    -ms-flex-item-align: end;
    align-self: flex-end;
  }

  .container-2 {
    padding: 16px 20px;
  }

  .content-container {
    padding: 0px 0px 100px;
  }
}

@media (max-width: 479px) {
  .body {
    padding-bottom: 110px;
  }

  .div-block-32 {
    width: 100%;
    margin-right: 0px;
  }

  .content-container-2 {
    padding-top: 64px;
    padding-bottom: 64px;
  }

  .primary-container {
    padding: 24px;
  }

  .content-container-3 {
    padding: 64px 16px;
  }

  .heading-2 {
    text-align: center;
  }

  .div-block-37 {
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

  .button-container {
    width: 100%;
    margin-top: 17px;
  }

  .container-2 {
    padding-top: 11px;
    padding-bottom: 11px;
  }

  .button-2 {
    min-height: auto;
    margin-left: 10px;
    padding: 6px 10px;
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
