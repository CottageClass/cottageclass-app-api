<template>
  <div class="onboarding onb-body">
    <div class="onb-content-container">
      <div class="onb-top-content-container">
        <h1 class="onb-heading-large">{{ titleText }}</h1>
        <p class="onb-paragraph-subheading-2">{{ sharingPromptText }}</p>
      </div>
      <ul class="onb-social-button-list">
        <li v-if="isMobileDevice" class="onb-button-social-list-item">
          <TextMessageLink :message="textMessage"
                           number=""
                           class="onb-button-social w-inline-block">
            <img src="@/assets/mms.svg" width="32" height="32" alt="">
            <div class="onb-button-social-text">Text message</div>
          </TextMessageLink>
        </li>
        <li v-if="isMobileDevice" class="onb-button-social-list-item">
          <a :href="fbMessengerLink" class="onb-button-social w-inline-block">
            <img src="@/assets/messenger.svg" width="32" height="32" alt="">
            <div class="onb-button-social-text">Facebook Messenger</div>
          </a>
        </li>
        <li class="onb-button-social-list-item">
          <a :href="fbLink" target="_blank" class="onb-button-social w-inline-block">
            <img src="@/assets/facebook-hover.svg" width="32" height="32" alt="">
            <div class="onb-button-social-text">Facebook</div>
          </a>
        </li>
        <li v-if="!isMobileDevice" class="onb-button-social-list-item">
          <a :href="tweetLink" target="_blank" class="onb-button-social w-inline-block">
            <img src="@/assets/twitter.svg" width="32" height="32" alt="">
            <div class="onb-button-social-text">Twitter</div>
          </a>
        </li>
        <li class="onb-button-social-list-item">
          <a :href="emailLink" class="onb-button-social w-inline-block">
            <img src="@/assets/email.svg" width="32" height="32" alt="">
            <div class="onb-button-social-text">Email</div>
          </a>
        </li>
      </ul>
      <div class="onb-copy-link-container">
        <div class="onb-copy-link-form-block w-form">
          <form id="email-form" name="email-form" data-name="Email Form" class="onb-copy-link-form">
            <input type="text"
                   class="copy-text-link-field w-input"
                   maxlength="256"
                   name="name"
                   data-name="Name"
                   :placeholder="shareUrl"
                   id="name">
            <a
              v-clipboard:copy="shareUrl"
              v-clipboard:success="onCopy"
              class="onb-button-copy-link w-button"
            >{{ copyButtonText }}</a>
          </form>
        </div>
      </div>
      <EventSearchListCard
        v-if="eventToShare"
        :doNotShowCancel="true"
        :item="item"
        @user-updated="updateUser"/>
    </div>
  </div>
</template>

<script>

import EventSearchListCard from '@/components/search/EventSearchListCard.vue'
import TextMessageLink from '@/components/TextMessageLink.vue'
import { fetchEvent } from '@/utils/api'
import { goHome } from '@/mixins'

export default {
  name: 'SocialInvite',
  components: { TextMessageLink, EventSearchListCard },
  mixins: [ goHome ],
  data () {
    return {
      copyButtonText: 'copy link',
      emailSubject: 'Sharing%20childcare%20(we%20should%20do%20this!)',
      // the content for tweets and emails depends on whether we are sharing a specific event or just the Lilypad site.
      tweetTextWithEvent: 'Would anyone like to join me for this?',
      emailBodyWithEvent: 'Hi%20everyone!%0A%0AI%20hope%20you%20can%20all%20join%20me%20at%20this%20playdate%20for%20families%20interested%20in%20sharing%20childcare!%20Can%20you%20come%3F%0A%0A',
      tweetTextWithoutEvent: 'This site helps families come together to share childcare and playdates for free. Want to try it with me?',
      emailBodyWithoutEvent: 'Hi%20everyone%2C%0A%0AI%E2%80%99m%20trying%20out%20this%20new%20site%20that%20lets%20families%20come%20together%20to%20share%20childcare%20and%20playdates%20for%20free.%20Want%20to%20try%20it%20with%20me%3F%0A%0A',
      textMessageWithEvent: 'Hi! Want to join me for this?',
      textMessageWithoutEvent: 'This site helps families come together to share childcare and playdates for free. Want to try it with me?',
      isMobileDevice: typeof window.orientation !== 'undefined',
      sharingPromptWithEvent: "Invite a few friends to attend this activity. When they join, they'll be prompted to offer their own activities and invite a few more friends. Before you know it, you'll have a thriving community of parents sharing activities and childcare!",
      sharingPromptWithoutEvent: "Invite a few friends to join Lilypad. As they join, they'll be prompted to start a profile and invite more friends. Before you know it, you'll have a thriving community of parents sharing activities and childcare!",
      fetchedEvent: null,
      eventId: this.$route.params.id
    }
  },
  created () {
    this.$emit('set-nav-props', {
      nextButtonHandler: this.nextStep,
      hidePrevious: true,
      button: 'done'
    })
    if (this.eventId) {
      this.fetchEvent()
    }
  },
  computed: {
    item () {
      return {
        event: this.eventToShare,
        user: this.eventToShare.user
      }
    },
    shareUrl: function () {
      if (this.eventId) {
        return `${window.location.origin}/event/` + this.eventId
      } else {
        return window.location.origin
      }
    },
    eventToShare: function () {
      return this.fetchedEvent
    },
    titleText () {
      return this.$route.params.context === 'spontaneous' ? 'Offer posted! Share it?' : 'Build your village'
    },
    sharingPromptText: function () {
      if (this.$route.params.context === 'spontaneous') {
        return 'Yay! We\'ve posted your offer to other parents. Now would you like to invite some people?'
      }
      if (this.eventId) {
        return this.sharingPromptWithEvent
      } else {
        return this.sharingPromptWithoutEvent
      }
    },
    textMessage: function () {
      return (this.eventId ? this.textMessageWithEvent : this.textMessageWithoutEvent) + ' ' + this.shareUrl
    },
    fbMessengerLink: function () {
      return 'fb-messenger://share/?link=' + this.shareUrl
    },
    fbLink: function () {
      return 'https://www.facebook.com/sharer/sharer.php?u=' + this.shareUrl
    },
    tweetLink: function () {
      return 'https://twitter.com/intent/tweet?text=' + (this.eventId ? this.tweetTextWithEvent : this.tweetTextWithoutEvent) + ' ' + this.shareUrl
    },
    emailLink: function () {
      return 'mailto:?subject=' + this.emailSubject + '&body=' + (this.eventId ? this.emailBodyWithEvent : this.emailBodyWithoutEvent) + this.shareUrl + '%2F%0A%0AThanks!%0A%3C3'
    }
  },
  methods: {
    async updateUser (payload) {
      this.eventToShare.host = payload.user
    },
    async fetchEvent () {
      this.fetchedEvent = await fetchEvent(this.eventId)
    },
    nextStep () {
      this.goHome()
    },
    onCopy: function () {
      this.copyButtonText = 'copied!'
    }
  }
}
</script>

<style lang="scss" scoped src="@/assets/style/scss/flow.scss"></style>

<style lang="scss" scoped>
.flow {

  .onb-heading-large {
    margin-top: 0px;
    margin-bottom: 10px;
    color: #333;
    font-size: 24px;
    line-height: 34px;
    text-align: center;
    font-weight: bold;
  }
  .onb-content-container {
    margin-bottom: 0px;
    padding: 32px 32px 72px;
    font-family: soleil;
  }

  .scrolling-wrapper {
    overflow-x: auto;
  }

  .card {
    flex: 0 0 auto;
  }
    .scrolling-wrapper {
    -webkit-overflow-scrolling: touch;
  }
  .scrolling-wrapper {
    &::-webkit-scrollbar {
      display: none;
    }
  }
  .onb-button-social {
    position: relative;
    display: flex;
    width: 100%;
    padding: 13px 16px;
    align-items: center;
    border-radius: 4px;
    background-color: #f0f0f0;
    cursor: pointer;
  }

  .onb-button-social:active {
    background-color: #fafafa;
  }

  .onb-button-social-text {
    margin-left: 10px;
    color: #333;
  }

  .onb-social-button-list {
    width: 100%;
    margin-bottom: 0px;
    padding-left: 0px;
    list-style-type: none;
  }

  .onb-button-social-list-item {
    margin-bottom: 8px;
  }

  .onb-copy-link-container {
    display: flex;
    width: 100%;
    margin-bottom: 8px;
    margin-top: 24px;
    align-items: center;
  }

  .copy-text-link-field {
    width: 100%;
    height: 56px;
    margin-bottom: 0px;
    padding-top: 8px;
    padding-left: 18px;
    border: 1px solid #e4e4e4;
    border-radius: 4px;
    background-color: #f0f0f0;
    color: #fff;
    font-size: 16px;
  }

  .copy-text-link-field:active {
    background-color: #fff;
  }

  .copy-text-link-field:focus {
    border-color: #0dba52;
    background-color: #fff;
  }

  .copy-text-link-field::-webkit-input-placeholder {
    color: #333;
    font-weight: 700;
  }

  .copy-text-link-field:-ms-input-placeholder {
    color: #333;
    font-weight: 700;
  }

  .copy-text-link-field::placeholder {
    color: #333;
    font-weight: 700;
  }

  .onb-copy-link-form {
    position: relative;
    display: flex;
    width: 100%;
    justify-content: flex-start;
    align-items: center;
    color: #333;
  }

  .onb-copy-link-form-block {
    display: flex;
    width: 100%;
    margin-bottom: 16px;
    align-items: center;
  }

  .button-2 {
    position: absolute;
    right: -1px;
  }

  .onb-button-copy-link {
  position: absolute;
  right: 0;
  display: flex;
  min-height: 100%;
  padding-right: 16px;
  padding-left: 16px;
  flex-direction: column;
  justify-content: center;
  border-style: solid;
  border-width: 1px;
  border-color: #e4e4e4;
  border-top-right-radius: 4px;
  border-bottom-right-radius: 4px;
  background-color: #fff;
  color: #1f88e9;
  font-size: 12px;
  letter-spacing: 1px;
  text-transform: uppercase;
  }

  .onb-button-copy-link:active {
  background-color: #fb6f77;
  color: #fff;
  }

  .onb-button-facebook:active {
    opacity: 0.8;
  }
}
</style>
