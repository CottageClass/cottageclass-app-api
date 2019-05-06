 <template>
  <Question
    title="What do you do for a living?"
    subtitle="Tell other families a bit about what you do for work.">
    <FormFieldAndLabel
      placeholder="Your employer"
      label="Where do you work?"
      v-model="internalData.employer"
      />
    <FormFieldAndLabel
      placeholder="Your title or role"
      label="What do you do?"
      v-model="internalData.jobPosition"
      />
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
import FormFieldAndLabel from '@/components/base/FormFieldAndLabel.vue'

export default {
  name: 'Employment',
  components: { Question, FormFieldAndLabel },
  props: ['value'],
  data () {
    return {
      internalData: this.value
    }
  },
  computed: {
    err () {
      if (this.internalData.jobPosition && this.internalData.jobPosition.length) {
        return null
      } else {
        return 'Please enter your job position'
      }
    }
  },
  methods: {
    updateValues () {
      this.$emit('input', {
        employment: this.internalData,
        err: this.err
      })
    }
  },
  watch: {
    internalData: {
      handler: function () {
        this.$emit('input', Object.assign(this.internalData, { err: this.err }))
      },
      deep: true
    }
  }
}

</script>
