<template>
  <Question
    title="Describe your playdate"
    subtitle="Be sure to include a short description of what you'd like to do or, if you're meeting in a public place, what the plan will be."
    class="container">
    <FormWithTextArea
      class="short"
      maxLength="255"
      placeholder="Title, e.g. 'Storytime at the Brooklyn Public library.'"
      v-model="name" />
    <FormWithTextArea
      class="tall"
      maxLength="30000"
      placeholder="Description, e.g. 'We have been here several times and it's lots of fun!'"
      v-model="description" />
    <div>
      <button
        @click="showCloudinaryWidget"
        class="images-button">
        Add images
      </button>
    </div>
  </Question>
</template>

<script>
import Question from '@/components/base/Question.vue'
import FormWithTextArea from '@/components/base/FormWithTextArea.vue'
import { createWidget } from '@/utils/vendor/cloudinary'

export default {
  name: 'EventDescription',
  components: { Question, FormWithTextArea },
  props: ['value'],
  data () {
    return {
      name: this.value.name,
      images: [],
      description: this.value.description,
      cloudinaryUploadWidget: null,
      defaultSubtitle: "Describe a playdate you'd like to host in your home or public space. It can be a one-time event (like a trip to the zoo) or something you can offer on a regular basis, like arts & crafts, indoor play, or a playground hangout!"
    }
  },
  methods: {
    cloudinaryEventHandler (error, result) {
      this.debug({ result })

      if (!error && result && result.event === 'abort') {
        this.avatarLoading = false
      }
      if (!error && result && result.event === 'success') {
        let transformation = ''
        if (result.info.coordinates.custom) {
          transformation = 'c_thumb,g_custom/'
        }
        const imageUrl = 'https://res.cloudinary.com/' + process.env.CLOUDINARY_CLOUD_NAME + '/image/upload/' + transformation + result.info.path
        this.images.push(imageUrl)
        this.emitData()
        this.disableForm = false
      }
    },
    showCloudinaryWidget () {
      this.cloudinaryUploadWidget.open()
    },
    emitData () {
      this.$emit('input', {
        err: this.errorMessage,
        name: this.name,
        description: this.description,
        images: this.images
      })
    }
  },
  computed: {
    errorMessage () {
      return (this.name && this.name.length >= 1) ? null : 'Please enter a name for your playdate.'
    }
  },
  created () {
    this.cloudinaryUploadWidget = createWidget(this.cloudinaryEventHandler, {
      multiple: true
    })
    this.emitData()
  },
  watch: {
    description: function () {
      this.emitData()
    },
    name: function () {
      this.emitData()
    }
  }
}
</script>
<style>
.images-button {
  display: block;
  width: 50%;
  padding: 13px 16px;
  border-radius: 4px;
  background-color: hsla(0, 0%, 100%, .7);
  cursor: pointer;
  color: #1d8ae7;
  margin-left: auto;
  margin-right: auto;
  text-align: center;
}
</style>
