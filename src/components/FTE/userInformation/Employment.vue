 <template>
  <Question
    title="What do you do for a living?"
    subtitle="Tell other families a bit about what you do for work.">
    <FormFieldAndLabel
      placeholder="Your employer"
      label="Where do you work?"
      v-model="employerValue"
      />
    <FormFieldAndLabel
      placeholder="Your title or role"
      label="What do you do?"
      v-model="jobPositionValue"
      />
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
import FormFieldAndLabel from '@/components/base/FormFieldAndLabel.vue'

export default {
  name: 'Employment',
  components: { Question, FormFieldAndLabel },
  props: ['jobPosition', 'employer'],
  data () {
    return {
      err: false,
      jobPositionValue: this.jobPosition,
      employerValue: this.employer
    }
  },
  methods: {
    updateValues () {
      this.$emit('valueUpdated', {
        jobPosition: this.jobPositionValue,
        employer: this.employerValue
      })
    }
  },
  watch: {
    jobPositionValue: function () {
      this.updateValues()
    },
    employerValue: function () {
      this.updateValues()
    }
  }
}

</script>
