<template>
  <StyleWrapper styleIs="onboarding">
    <div class="onb-body">
      <div class="body">
        <div class="content-wrapper">
          <div class="content-container">
            <div class="title-container">
              <h1 class="lp-title">When do you need care</h1>
            </div>
            <DateTimePicker v-model="bookingRequest.dateTimeSelected"/>
            <div class="form-describe-need w-form">
              <form v-on:submit.prevent id="email-form-2">
                <p class="describe-label">Need care on multiple days?</p>
                <textarea
                  v-model="bookingRequest.description"
                  id="field"
                  name="field"
                  placeholder="Describe your need and schedule here."
                  maxlength="5000"
                  class="text-area-decribe-need w-input">
                </textarea>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </StyleWrapper>
</template>

<script>
import DateTimePicker from '@/components/DateTimePicker.vue'
import StyleWrapper from '@/components/FTE/StyleWrapper.vue'

export default {
  name: 'RequestCare',
  props: ['value'],
  components: { DateTimePicker, StyleWrapper },
  data () {
    return {
      bookingRequest: this.value
    }
  },
  watch: {
    bookingRequest: {
      handler: function () {
        if (this.bookingRequest.description || this.bookingRequest.dateTimeSelected) {
          this.bookingRequest.err = false
        } else if (this.bookingRequest.description === '' && this.bookingRequest.dateTimeSelected === null) {
          this.bookingRequest.err = 'skippable'
        }
      },
      deep: true
    }
  }
}

</script>
