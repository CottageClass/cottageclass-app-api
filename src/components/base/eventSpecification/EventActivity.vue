<template>
  <Question
    title="Choose your activity"
    subtitle="All members must provide one activity per month. These tried-and-true options work great, and we'll walk you through whichever one you choose.">
    <RadioButtons
      v-model="activitySelected"
      :choices="activities"
      :labels='fullDescriptions'
    />
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
import RadioButtons from '@/components/base/RadioButtons.vue'

export default {
  name: 'EventActivity',
  components: { Question, RadioButtons },
  props: ['value'],
  data () {
    return {
      activitySelected: this.value.selected,
      errorMesg: 'Please choose an activity option from the list.',
      activities: [
        'Arts & Crafts',
        'Baby playgroup',
        'Books & Storytime',
        'Drawing & Coloring',
        'Games & Puzzles',
        'Kids\' Movie Night',
        'Playing outside (weather permitting)',
        'Playground Meetup',
        'Waldorf Nature Walk'
      ],
      ages: {
        'Arts & Crafts': [2, 11],
        'Baby playgroup': [0, 3],
        'Books & Storytime': [0, 9],
        'Drawing & Coloring': [0, 9],
        'Games & Puzzles': [3, 11],
        'Kids\' Movie Night': [3, 11],
        'Playing outside (weather permitting)': [0, 11],
        'Playground Meetup': [0, 11],
        'Waldorf Nature Walk': [0, 11]
      }
    }
  },
  methods: {
    emitInput: function () {
      this.$emit('input', {
        selected: this.activitySelected,
        err: this.err
      })
    }
  },
  mounted: function () {
    this.emitInput()
  },
  computed: {
    err: function () {
      if (!this.activitySelected) {
        return this.errorMesg
      } else {
        return false
      }
    },
    fullDescriptions () {
      return this.activities.map(activity => {
        return [activity, activity + ' (ages ' + this.ages[activity][0] + '-' + this.ages[activity][1] + ')']
      })
    }
  },
  watch: {
    activitySelected: function () {
      this.emitInput()
    }
  }
}
</script>

<style scoped>

.describe-label {
  color: white;
  padding-top: 16px;
}

textarea {
  height: 96px;
}

.onb-content-container {
  min-height: 100vh;
}

</style>
