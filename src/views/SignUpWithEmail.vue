<template>
 <StyleWrapper styleIs="onboarding">

  <!-- wrapper for desktop screens -->
  <div class="onb-body">
    <div class="body">
      <div class="content-wrapper">
<!-- nav -->
    <div class="title-bar">
      <a @click.prevent="$router.go(-1)" class="button-back w-inline-block"></a>
      <a @click="signup" :class="nextButtonClassObject">
        <div class="title-bar-next-button-text">NEXT</div>
      </a>
    </div>

        <!-- title & form -->

        <div v-if="!success">
          <div class="onb-content-container-2">
            <ErrorMessage v-if="showError && (errors.all().length > 0 || error)" :text="error" :messages="allErrors" />
            </div>
            <div class="onb-top-content-container">
              <h1 class="onb-heading-large">Join KidsClub</h1>
              <button
              v-if="showFacebookLogin"
              class="button-text splash-button w-inline-block facebook-sign-in-button"
              @click.prevent="authenticate('facebook')"
              >Continue with Facebook</button>
              <p class="onb-paragraph-subheading-2">
                <span v-if="showFacebookLogin">Or enter</span>
                <span v-else>Enter</span> your information below. Already have an account?
                <a href="" @click.prevent="$router.push( {name: 'SignIn' })">Sign in here</a>.
              </p>
            </div>
          </div>
          <div class="onb-child-info-container">
            <div class="form-block-3 w-form">
              <form v-on:submit.prevent="signup" class="form-2">
                <fieldset :disabled="disableForm === true">
                  <div class="onb-child-group-2">
                    <label class="onb-field-label">First Name</label>
                    <input
                    v-validate="'required'"
                    name="first_name"
                    v-model="first_name"
                    placeholder="First Name"
                    :class="{'invalid': errors.has('first_name') }"
                    class="name-text-field w-input"
                    >
                    <label class="onb-field-label">Last Name</label>
                    <input
                    v-validate="'required'"
                    name="last_name"
                    v-model="last_name"
                    placeholder="Last Name"
                    :class="{'invalid': errors.has('last_name') }"
                    class="name-text-field w-input"
                    >
                    <label class="onb-field-label">Email</label>
                    <input
                    v-validate="'required|email'"
                    name="email"
                    v-model="email"
                    placeholder="e.g. your-email@example.com"
                    :class="{'invalid': errors.has('email') }"
                    class="name-text-field w-input"
                    type="email"
                    >
                    <label class="onb-field-label">Password</label>
                    <input
                    type="password"
                    v-validate="'required'"
                    name="password"
                    v-model="password"
                    placeholder="Password"
                    :class="{'invalid': errors.has('password') }"
                    class="name-text-field w-input"
                    >
                  </div>
                  <div class="avatar-photo" v-if="!!avatar_url">
                    <img :src="avatar_url" height="128">
                  </div>
                  <label for="avatar" class="onb-button-add-group w-inline-block">
                    <img src="@/assets/add.svg" alt="" class="image-7">
                    <div class="onb-button-add-group-text" :class="{'invalid': errors.has('avatar') }">
                      <span v-if="!avatar_url">Add profile photo</span>
                      <span v-else>Replace photo</span>
                    </div>
                  </label>
                <input
                type="file"
                style="visibility:hidden;"
                v-validate="'required'"
                id="avatar"
                name="avatar"
                v-on:change="upload"
                accept="image/*"
                >
              </fieldset>
            </form>
          </div>
        </div>
      </div>
      <div v-if="!!success" class="onb-content-container-2" >
        <div class="onb-top-content-container">
          <br><br><br>
          <h1 class="onb-heading-large">Registration complete!</h1>
          <p class="onb-paragraph-subheading-2">Sign in to continue.</p>
        </div>

        <button @click.prevent="$router.push( {name: 'SignIn' })" class="button-text splash-button w-inline-block">Sign in</button>
      </div>
    </div>
  </div>
</StyleWrapper>
</template>

<script>
import ErrorMessage from '@/components/base/ErrorMessage.vue'
import StyleWrapper from '@/components/FTE/StyleWrapper.vue'
import providerAuth from '@/mixins/providerAuthentication'

export default {
  name: 'SignUpWithEmail',
  components: { ErrorMessage, StyleWrapper },
  mixins: [providerAuth],
  data: function () {
    return {
      success: false,
      disableForm: false,
      first_name: '',
      last_name: '',
      email: '',
      password: '',
      avatar_url: null,
      showError: false,
      cloudinary: {
        uploadPreset: 'avatar',
        apiKey: '415594396214129',
        cloudName: 'cottageclass2'
      },
      showFacebookLogin: !this.hideFacebookLogin(),
      error: null
    }
  },
  computed: {
    cloudinaryUploadUrl: function () {
      return `https://api.cloudinary.com/v1_1/${
        this.cloudinary.cloudName
      }/image/upload`
    },
    formHasErrors: function () {
      return this.errors
    },
    allErrors: function () {
      return this.errors.all()
    },
    nextButtonClassObject: function () {
      return {
        'title-bar-next-button-inactive': this.button === 'inactive',
        'title-bar-next-button': !(this.button === 'inactive'),
        'w-inline-block': true
      }
    },
    button: function () {
      // todo: should show errors until avatar upload
      if (this.first_name && this.last_name && this.email && this.password && this.avatar_url && this.errors.items.length === 0) {
        return 'next'
      } else {
        return 'inactive'
      }
    }
  },
  mounted: function () {
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
    upload: function (event) {
      let files = event.target.files

      let formData = new FormData()
      formData.append('file', files[0])
      formData.append('upload_preset', this.cloudinary.uploadPreset)

      this.disableForm = true

      fetch(this.cloudinaryUploadUrl, { method: 'POST', body: formData })
        .then(response => {
          if (response.ok) {
            return response.json()
          } else {
            throw new Error('Network response was not ok')
          }
        })
        .then(response => {
          console.log('cloudinary upload success', response)
          this.disableForm = false
          this.avatar_url = response.secure_url
        })
        .catch(error => {
          console.error('cloudinary upload error', error)
          this.disableForm = false
        })
    },
    signup: function () {
      let component = this

      this.$validator
        .validateAll()
        .then(function (result) {
          if (result) {
            component.disableForm = true

            let first_name =
              component.first_name && component.first_name.trim()
            let last_name = component.last_name && component.last_name.trim()
            let email = component.email && component.email.trim().toLowerCase()
            let password = component.password && component.password.trim()
            let avatar = component.avatar_url && component.avatar_url.trim()

            component.$auth
              .register({ first_name, last_name, email, password, avatar })
              .then(response => {
                console.log('signup success:', response)
                component.success = true
                component.disableForm = false
                component.$auth
                  .login({ email, password })
                  .then(res => {
                    console.log('auth success:', res)
                    return component.$router.push({ name: 'OnboardNewUser' })
                  })
                  .catch(function (err) {
                    console.log('auth FAILURE or user not onboarded yet')
                    console.error(err)
                  })
              })
              .catch(function (error) {
                console.error('signup failure:', error)
                component.disableForm = false
                component.showError = true
                component.error = 'Sorry, there was a problem creating your account. Did you already create an account with this email address directly or via Facebook?'
              })
          } else {
            component.showError = true
          }
        })
        .catch(function (error) {
          console.error('validation error', error)
        })
    }
  }
}
</script>

<style lang="scss" scoped>

.title-bar-next-button {
  position: static;
  display: block;
  margin-top: 0px;
  margin-right: 10px;
  margin-bottom: 0px;
  padding: 10px 12px;
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
  border: 1px none #000;
  border-radius: 4px;
  background-color: #fff;
  box-shadow: none;
  color: #64426b;
}

.title-bar-next-button:active {
  background-color: #64426b;
  color: #fff;
}

.title-bar-next-button-text {
  margin-bottom: 2px;
  font-size: 14px;
  line-height: 14px;
  font-weight: 700;
  letter-spacing: 1.2px;
  text-transform: uppercase;
}

.title-bar-next-button-inactive {
  position: static;
  display: block;
  margin-top: 0px;
  margin-right: 10px;
  margin-bottom: 0px;
  padding: 10px 12px;
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
  border: 1px none #000;
  border-radius: 4px;
  background-color: hsla(0, 0%, 100%, .3);
  box-shadow: none;
  color: rgba(1, 1, 1, .2);
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

.content-wrapper {
  position: 0px;
  padding-top: 0px;
}

.full-height-background {
  min-height: 100vh;
  background-color: #1d8be7;
}

.onb-content-container-2 {
  padding-top: 83px;
}

.facebook-sign-in-button {
  background-color: white;
  max-width: 256px;
  padding: 16px;
  margin: 32px auto 16px auto;
}

.avatar-photo {
  text-align: center;
}

.avatar-photo img {
  height: 96px;
}

.onb-button-add-group-text.invalid {
  border: red;
}

.onb-button-add-group {
  margin-bottom: 16px;
}

p a {
  text-decoration: underline
}

input.invalid {
  border: 1px solid red;
}

button {
  background: none;
}

.splash-button {
  background-color: white;
  width: 100%;
}

@media (max-width: 479px) {
  .facebook-sign-in-button {
    max-width: none;
    width: 100%;
  }
}

</style>
