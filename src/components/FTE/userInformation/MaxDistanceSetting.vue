<template>
  <Question
    title="How far can you travel?"
    subtitle="What's the most you would travel to meet another parent for a playdate?">
    <RadioButtons
      v-model="miles"
      :choices="choices"
      :labels="labels"
    />

    <slot></slot>
  </Question>
</template>

<script>
import { mapGetters } from 'vuex'

import Question from '@/components/base/Question.vue'
import RadioButtons from '@/components/base/RadioButtons.vue'

import { } from '@/mixins'

export default {
  name: 'MaxDistanceSetting',
  props: { value: {} },
  components: { Question, RadioButtons },
  mixins: [],
  data () {
    return {
      miles: this.value || '2'
    }
  },
  computed: {
    choices () {
      return ['0.5', '1.0', '2.0', '3.0', '5.0', '8.0', '13.0', '20.0']
    },
    labels () {
      return [
        ['0.5', '0.5 miles'],
        ['1.0', '1 mile'],
        ['2.0', '2 miles'],
        ['3.0', '3 miles'],
        ['5.0', '5 miles'],
        ['8.0', '8 miles'],
        ['13.0', '13 miles'],
        ['20.0', '20 miles']
      ]
    },
    ...mapGetters([])
  },
  mounted: function () {
    this.emitData()
  },
  methods: {
    emitData: function () {
      this.$emit('input', this.miles)
    }
  },
  watch: {
    miles: function () {
      this.emitData()
    }
  }
}
</script>

<style scoped>

</style>
