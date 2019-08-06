import Vue from 'vue'
import Router from 'vue-router'
import UserPage from '@/views/UserPage.vue'
import SplashPage from '@/views/SplashPage.vue'
import EventPage from '@/views/EventPage.vue'
import Search from '@/views/Search.vue'
import NewEvent from '@/views/NewEvent.vue'
import RsvpInfoCollection from '@/components/RsvpInfoCollection.vue'
import CancelRSVP from '@/components/CancelRSVP.vue'
import Faq from '@/components/Faq.vue'
import YourPlaydates from '@/views/YourPlaydates.vue'
import SocialInvite from '@/views/SocialInvite.vue'
import EventEdit from '@/components/EventEdit.vue'
import ProfileEdit from '@/components/ProfileEdit.vue'
import SignInWithEmail from '@/views/SignInWithEmail.vue'
import SignUpWithEmail from '@/views/SignUpWithEmail.vue'
import PasswordResetRequest from '@/views/PasswordResetRequest.vue'
import PasswordReset from '@/views/PasswordReset.vue'
import ContactForm from '@/views/ContactForm.vue'
import Onboarding from '@/views/Onboarding.vue'
import ProfileCollection from '@/views/ProfileCollection.vue'
import DeclineRSVP from '@/views/DeclineRSVP.vue'
import RequestChildcare from '@/views/RequestChildcare.vue'
import ChildcareRequestPage from '@/views/ChildcareRequestPage.vue'
import DeleteAccountConfirmation from '@/views/DeleteAccountConfirmation'

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/delete-account',
      name: 'DeleteAccountConfirmation',
      component: DeleteAccountConfirmation
    },
    {
      path: '/childcare-request/:id',
      name: 'ChildcareRequestPage',
      component: ChildcareRequestPage,
      props: true
    },
    {
      path: '/request-childcare/:section?/:stepName?',
      name: 'RequestChildcare',
      component: RequestChildcare,
      props: true
    },
    {
      path: '/rsvp/:eventId/decline',
      name: 'DeclineRSVP',
      component: DeclineRSVP,
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
    },
    {
      path: '/events/new/:stepName?',
      name: 'NewEvent',
      component: NewEvent,
      props: true
    },
    {
      path: '/',
      name: 'SplashPage',
      component: SplashPage
    },
    {
      path: '/home',
      name: 'Search',
      component: Search
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
      path: '/event/:id/share',
      name: 'SocialInvite',
      component: SocialInvite,
      props: {
        context: true
      }
    },
    {
      path: '/event/:id/edit',
      name: 'EventEdit',
      component: EventEdit
    },
    {
      path: '/event/:id/',
      name: 'EventPage',
      component: EventPage
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
      path: '/rsvp/:eventId/cancel',
      name: 'CancelRSVP',
      component: CancelRSVP,
      props: true
    },
    {
      path: '/rsvp/:eventId',
      name: 'RsvpInfoCollection',
      component: RsvpInfoCollection
    },
    {
      path: '/password-reset-request',
      name: 'PasswordResetRequest',
      component: PasswordResetRequest,
      props: true
    },
    {
      path: '/contact/event/:eventId',
      name: 'ContactEventForm',
      component: ContactForm,
      props: true
    },
    {
      path: '/contact/user/:userId',
      name: 'ContactUserForm',
      component: ContactForm,
      props: true
    },
    {
      path: '/my', // short link for SMS prompts
      redirect: '/events/new/description'
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
