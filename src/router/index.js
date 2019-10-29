import Vue from 'vue'
import Router from 'vue-router'

import UserPage from '@/views/UserPage.vue'
import SplashPage from '@/views/SplashPage.vue'
import EventPage from '@/views/EventPage.vue'
import Search from '@/views/Search.vue'
import Chats from '@/views/Chats.vue'
import Conversation from '@/views/Conversation.vue'
import Faq from '@/components/Faq.vue'
import YourPlaydates from '@/views/YourPlaydates.vue'
import EventEdit from '@/components/EventEdit.vue'
import ProfileEdit from '@/components/ProfileEdit.vue'
import SignInWithEmail from '@/views/SignInWithEmail.vue'
import SignUpWithEmail from '@/views/SignUpWithEmail.vue'
import PasswordResetRequest from '@/views/PasswordResetRequest.vue'
import PasswordReset from '@/views/PasswordReset.vue'
import ErrorPage from '@/views/ErrorPage'

// FlowPage components
import FlowPage from '@/views/FlowPage.vue'
import ProfileCollection from '@/views/ProfileCollection.vue'
import NewEvent from '@/views/NewEvent.vue'
import CancelRSVP from '@/components/CancelRSVP.vue'
import SocialInvite from '@/views/SocialInvite.vue'
import Onboarding from '@/views/Onboarding.vue'
import RsvpInfoCollection from '@/components/RsvpInfoCollection.vue'
import DisinterestedSurvey from '@/views/DisinterestedSurvey.vue'
import DeclineRSVP from '@/views/DeclineRSVP.vue'
import DeleteAccountConfirmation from '@/views/DeleteAccountConfirmation'

import { isNative } from '@/utils/platform'

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [
    {
      path: 'NOT USED.  THESE ARE PAGES THAT USE THE FlowPage AS A WRAPPER',
      component: FlowPage,
      children: [
        {
          path: '/rsvp/:eventId',
          name: 'RsvpInfoCollection',
          component: RsvpInfoCollection,
          props: true
        },
        {
          path: '/users/:userId/decline',
          name: 'DisinterestedSurvey',
          component: DisinterestedSurvey,
          props: true
        },
        {
          path: '/delete-account',
          name: 'DeleteAccountConfirmation',
          component: DeleteAccountConfirmation
        },
        {
          path: '/rsvp/:eventId/decline',
          name: 'DeclineRSVP',
          component: DeclineRSVP,
          props: true
        },
        {
          path: '/share',
          name: 'SocialInvite',
          component: SocialInvite
        },
        {
          path: '/event/:id/share',
          name: 'SocialEventInvite',
          component: SocialInvite,
          props: {
            context: true
          }
        },
        {
          path: '/rsvp/:eventId/cancel',
          name: 'CancelRSVP',
          component: CancelRSVP,
          props: true
        },
        {
          path: '/events/new/:stepName?',
          name: 'NewEvent',
          component: NewEvent,
          props: true
        },
        {
          path: '/profile',
          name: 'ProfileCollection',
          component: ProfileCollection
        },
        {
          path: '/welcome/:section?/:stepName?',
          name: 'Onboarding',
          component: Onboarding,
          props: true
        }
      ]
    },
    {
      path: '/',
      name: 'SplashPage',
      component: SplashPage,
      beforeEnter (to, from, next) {
        if (isNative()) {
          next({ name: 'SignUp' })
        } else {
          next()
        }
      }
    },
    {
      path: '/chat/:userId',
      name: 'Conversation',
      component: Conversation,
      props: true
    },
    {
      path: '/chats',
      name: 'Chats',
      component: Chats
    },
    {
      path: '/playdates',
      name: 'Events',
      component: Search,
      props: {
        itemType: 'event'
      }
    },
    {
      path: '/parents',
      name: 'Parents',
      component: Search,
      props: {
        itemType: 'all'
      }
    },
    {
      path: '/password-reset/:token',
      name: 'PasswordReset',
      component: PasswordReset
    },
    {
      path: '/log-in',
      name: 'SignIn',
      component: SignInWithEmail
    },
    {
      path: '/sign-up',
      name: 'SignUp',
      component: SignUpWithEmail
    },
    {
      path: '/profile/edit',
      name: 'ProfileEdit',
      component: ProfileEdit
    },
    {
      path: '/users/:id',
      name: 'UserPage',
      component: UserPage,
      props: true
    },
    {
      path: '/event/:id/edit',
      name: 'EventEdit',
      component: EventEdit
    },
    {
      path: '/event/:id/',
      name: 'EventPage',
      component: EventPage,
      props: true
    },
    {
      path: '/faq',
      name: 'Faq',
      component: Faq
    },
    {
      path: '/your-playdates',
      name: 'YourPlaydates',
      component: YourPlaydates
    },
    {
      path: '/password-reset-request',
      name: 'PasswordResetRequest',
      component: PasswordResetRequest,
      props: true
    },
    {
      path: '/my', // short link for SMS prompts
      redirect: '/events/new/'
    },
    {
      path: '*',
      name: 'NotFound',
      component: ErrorPage,
      props: { status: 404 }
    }

  ],
  scrollBehavior (to, from, savedPosition) {
    if (to.hash) {
      return { selector: to.hash }
    } else if (savedPosition) {
      return savedPosition
    } else {
      return { x: 0, y: 0 }
    }
  }
})
