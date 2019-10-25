<template>
  <div class="page-container editing" id="top-of-form">
    <DeleteEventConfirmationModal
      v-if="showDeleteConfirmationModal"
      v-on:closeModal="showDeleteConfirmationModal = false"
      :eventId="eventId"/>
    <MainNav />
    <div class="lp-container w-container" v-if="event">
      <h1 class="heading-1">Editing event #{{ eventId }} </h1>
      <ErrorMessage v-if="showError && error" text="Your entries have errors. Please fix them to continue..." />
      <EventName v-model="event.name" />
      <EventDescription v-model="event.description" />
      <ErrorMessage v-if="event.ageRange.err" :text="event.ageRange.err" />
      <AgeRange v-model="event.ageRange" />
      <ErrorMessage v-if="!datesValidate" text="Please enter a valid start and end time for your event." />
      <Question title="When is your event?">
        From...
        <br>
        <br>
        <DateTimePicker v-model="event.startsAt" showDate="true" />
        <br>
        To...
        <br><br>
        <DateTimePicker v-model="event.endsAt" showDate="true" />
      </Question>
      <Question
        title="Got any photos you'd like to share?"
        subtitle="Adding photos to your event helps give other members a sense of what will be happening."
      >
        <MultipleImageUpload v-model="event.images" @input="submitImageUpload"/>
      </Question>
      <Question title="Delete this event" subtitle="Are you unable to host this event? This cannot be undone. Your guests will receive a text message informing them that the event has been cancelled.">
        <button
          class="delete-event-button"
          v-on:click="showDeleteConfirmationModal=true">
          Delete
        </button>
      </Question>
      <PageActionsFooter :buttons="footerButtons" @primary-click="saveEvent" />
    </div>
  </div>

</template>

<script>
import MultipleImageUpload from '@/components/base/MultipleImageUpload.vue'
import EventName from '@/components/base/eventSpecification/EventName.vue'
import EventDescription from '@/components/base/eventSpecification/EventDescription.vue'
import MainNav from '@/components/MainNav.vue'
import DateTimePicker from '@/components/DateTimePicker.vue'
import PageActionsFooter from '@/components/PageActionsFooter.vue'
import ErrorMessage from '@/components/base/ErrorMessage.vue'
import Question from '@/components/base/Question.vue'
import DeleteEventConfirmationModal from '@/components/DeleteEventConfirmationModal.vue'
import AgeRange from '@/components/base/eventSpecification/AgeRange.vue'

import { fetchEvent, updateEvent } from '@/utils/api'

var moment = require('moment')

var VueScrollTo = require('vue-scrollto')

export default {
  name: 'EventEdit',
  components: {
    MainNav,
    PageActionsFooter,
    ErrorMessage,
    Question,
    DateTimePicker,
    EventName,
    EventDescription,
    AgeRange,
    DeleteEventConfirmationModal,
    MultipleImageUpload
  },
  data () {
    return {
      eventId: this.$route.params.id,
      saveButtonText: 'Save',
      eventDataFromAPI: null,
      event: null, // the client-side data model for events
      showError: false,
      showDeleteConfirmationModal: false
    }
  },
  mounted: function () {
    this.fetchEvent()
  },
  computed: {
    footerButtons () {
      return [{
        text: this.saveButtonText
      }]
    },
    datesValidate: function () {
      if (moment(this.event.startsAt).isBefore(this.event.endsAt)) {
        return true
      } else {
        return false
      }
    },
    err: function () {
      return !this.datesValidate || this.event.ageRange.err
    },
    eventDataForSubmissionToAPI: function () {
      return {
        'event': {
          'name': this.event.name,
          'starts_at': this.event.startsAt,
          'ends_at': this.event.endsAt,
          'child_age_minimum': this.event.ageRange.minimum,
          'child_age_maximum': this.event.ageRange.maximum
        }
      }
    }
  },
  methods: {
    submitImageUpload: async function () {
      if (!this.hasError) {
        const data = { images: this.event.images }
        try {
          await updateEvent(this.event.id, data)
        } catch (e) {
        }
      } else {
        this.showError = true
        VueScrollTo.scrollTo('#top-of-form')
      }
    },
    fetchEvent: async function () {
      this.event = await fetchEvent(this.eventId)
      this.event = this.parseEventDataFromAPI(this.event)
    },
    parseEventDataFromAPI: function (dataFromAPI) {
      let e = dataFromAPI
      return {
        ...e,
        ageRange: {
          maximum: e.childAgeMaximum,
          minimum: e.childAgeMinimum
        }
      }
    },
    submitEventData: async function () {
      try {
        await updateEvent(this.event.id, this.eventDataForSubmissionToAPI)
      } catch (e) {
        this.logError(e)
        this.saveButtonText = 'Problem saving. Click to try again.'
      }
    },
    saveEvent: function () {
      if (this.err) {
        this.showError = true
        VueScrollTo.scrollTo('#top-of-form')
      } else {
        this.saveButtonText = 'Saving...'
        this.submitEventData().then(res => {
          this.saveButtonText = ' \u2714 Saved'
          console.log('event update SUCCESS')
          console.log(res)
          this.fetchEvent()
          return res
        }).catch(err => {
          console.log('Error saving', err)
          this.saveButtonText = 'Problem saving. Click to try again.'
        })
      }
    }
  }
}
</script>

<style scoped>

.page-container {
  font-family: soleil;
  color: #333;
  font-size: 14px;
  line-height: 20px;
  background-color: #f5f5f5;
}

.heading-1 {
  margin-bottom: 32px;
}

.lp-container {
  padding: 32px 32px 100px;
}

.delete-event-button {
  padding: 12px 32px;
  border-radius: 4px;
  background-color: #e91f29;
  text-align: center;
  color: #fff;
}

.delete-event-button:hover {
  background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .1)), to(rgba(0, 0, 0, .1)));
  background-image: linear-gradient(180deg, rgba(0, 0, 0, .1), rgba(0, 0, 0, .1));
}

.delete-event-button:active {
  background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .1)), to(rgba(0, 0, 0, .1)));
  background-image: linear-gradient(180deg, rgba(0, 0, 0, .1), rgba(0, 0, 0, .1));
}

@media (max-width: 991px) {
  .page-container {
    padding-bottom: 77px;
  }

  .lp-container {
    padding-bottom: 32px;
  }
}

@media (max-width: 767px) {
  .page-container {
    padding-bottom: 50px;
  }

  .heading-1 {
    margin-right: 24px;
    margin-left: 24px;
  }

  .lp-container {
    padding-top: 16px;
    padding-right: 0px;
    padding-left: 0px;
  }
}

@media (max-width: 479px) {
  .heading-1 {
    font-size: 34px;
    line-height: 44px;
  }
}

</style>
