import Vue from 'vue'
import Router from 'vue-router'
import ProviderProfile from '@/views/ProviderProfile.vue'
import SplashPage from '@/views/SplashPage.vue'
import EventPage from '@/components/EventPage.vue'
import Events from '@/views/Events.vue'
import EventsDetail from '@/views/EventsDetail.vue'
import NewEvent from '@/views/NewEvent.vue'
import RsvpInfoCollection from '@/components/RsvpInfoCollection.vue'
import CancelRSVP from '@/components/CancelRSVP.vue'
import MyRSVPs from '@/components/MyRSVPs.vue'
import Faq from '@/components/Faq.vue'
import MyEvents from '@/components/MyEvents.vue'
import SocialInvite from '@/views/SocialInvite.vue'
import EventEdit from '@/components/EventEdit.vue'
import ProfileEdit from '@/components/ProfileEdit.vue'
import EmergencyContacts from '@/components/FTE/EmergencyContacts.vue'
import ChildSpecialRequirements from '@/components/FTE/ChildSpecialRequirements.vue'
import ChildSpecialRequirementsYesNo from '@/components/FTE/ChildSpecialRequirementsYesNo.vue'
import SignInWithEmail from '@/views/SignInWithEmail.vue'
import SignUpWithEmail from '@/views/SignUpWithEmail.vue'
import InviteExistingUsers from '@/views/InviteExistingUsers.vue'
import PasswordReset from '@/views/PasswordReset.vue'
import ContactForm from '@/views/ContactForm.vue'
import Onboarding from '@/views/Onboarding.vue'

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [
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
      path: '/events',
      name: 'Events',
      component: Events
    },
    {
      path: '/events/detail',
      name: 'EventsDetail',
      component: EventsDetail,
      props: true
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
      name: 'ProviderProfile',
      component: ProviderProfile,
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
      path: '/event/:id/invite',
      name: 'InviteExistingUsers',
      component: InviteExistingUsers
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
      // NB: this route has beforeRouteEnter redirect in the component
    },
    {
      path: '/my-events',
      name: 'MyEvents',
      component: MyEvents
    },
    {
      path: '/onboarding/emergency-contacts/:eventId?',
      name: 'EmergencyContacts',
      component: EmergencyContacts
    },
    {
      path: '/onboarding/child-special-requirements-2/:eventId?',
      name: 'ChildSpecialRequirements',
      component: ChildSpecialRequirements
    },
    {
      path: '/onboarding/child-special-requirements-1/:eventId?',
      name: 'ChildSpecialRequirementsYesNo',
      component: ChildSpecialRequirementsYesNo
    },
    {
      path: '/my-rsvps',
      name: 'MyRSVPs',
      component: MyRSVPs
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
      path: '/password-reset',
      name: 'PasswordReset',
      component: PasswordReset
    },
    {
      path: '/contact/:eventId',
      name: 'ContactForm',
      component: ContactForm,
      props: true
    }
  ],
  scrollBehavior (to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { x: 0, y: 0 }
    }
  }
})
