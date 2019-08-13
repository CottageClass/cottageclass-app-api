<template>
  <Question
    title="How far can you travel?"
    subtitle="What is the maximum distance that you would like to get recommendations from us?">
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
      return ['0.5', '1', '2', '3', '5', '8', '13', '20']
    },
    labels () {
      return [
        ['0.5', '0.5 miles'],
        ['1', '1 mile'],
        ['2', '2 miles'],
        ['3', '3 miles'],
        ['5', '5 miles'],
        ['8', '8 miles'],
        ['13', '13 miles'],
        ['20', '20 miles']
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
