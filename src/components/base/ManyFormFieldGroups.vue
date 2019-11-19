<template>
  <span>
    <form v-on:submit.prevent id="email-form-2" name="email-form-2" data-name="Email Form 2" class="form-2">
      <div
        v-for="(object, index) in objects"
        class="onb-child-group-2">
        <FormFieldGroup
          :fieldGroups="fieldGroups"
          :key="object.key"
          :heading="headingWord ? headingWord + ' ' + (index + 1) : headings ? headings[index] : ''"
          v-model="objects[index]"
          @remove="removeGroup(object.key)"
          :showRemoveButton="addAndRemove"
        />
      </div>
    </form>
    <div
      v-if="addAndRemove"
      @click="add"
      class="onb-button-add-group w-inline-block">
      <a class="onb-button-add-group-text">Add Another {{ headingWord }}</a>
    </div>
  </span>
</template>
<script>
/*
 * This component is for when you need multiple forms that collect identical information, like child info. It lets you determine the number of forms, or (if addAndRemove === true) it lets the user add them ad hoc depending on, say, how many kids they have or contacts they want to add.
*/

import FormFieldGroup from '@/components/base/FormFieldGroup.vue'

export default {
  name: 'ManyFormFieldGroups',
  components: { FormFieldGroup },
  props:
    [
      'value',
      'headingWord', // e.g. 'Child' which will become 'Child 1', 'Child 2', etc
      'headings', // a list of headings e.g. Mary, Alice
      'addAndRemove', // if true, the user can add and remove field groups.
      'fieldGroups' // an array of objects { name: '', label: '', placeholder: '', type: '', selectData: ''}
    ],
  data () {
    return {
      currentKey: 0,
      objects: this.value
    }
  },
  mounted: function () {
    if (this.objects.length < 1) {
      this.objects = [this.newObject()]
    } else {
      // verify keys are in object
      for (let object of this.objects) {
        object.key = this.nextKey()
      }
    }
  },
  computed: {
    anEmptyObject: function () {
      return this.fieldGroups.reduce(function (obj, aFieldGroup) {
        return { ...obj, [aFieldGroup.name]: '' }
      }, {})
    },
    objectsWithKeysRemoved: function () {
      return this.objects.map(obj => {
        let newObj = JSON.parse(JSON.stringify(obj))
        delete newObj.key
        return newObj
      })
    }
  },
  methods: {
    nextKey () {
      return this.currentKey++
    },
    add: function () {
      this.objects.push(this.newObject())
    },
    removeGroup: function (key) {
      this.objects = this.objects.filter(obj => obj.key !== key)
    },
    newObject: function () {
      let obj = JSON.parse(JSON.stringify(this.anEmptyObject))
      obj.key = this.nextKey()
      return obj
    }
  },
  watch: {
    objectsWithKeysRemoved: function () {
      this.$emit('input', this.objectsWithKeysRemoved)
    }
  }
}
</script>

<style lang="scss" scoped>
.flow {
  .onb-button-add-group {
  display: flex;
  margin-top: 24px;
  margin-bottom: 24px;
  justify-content: center;
  }

  .onb-button-add-group-text {
  padding: 3px 10px;
  border-style: solid;
  border-width: 1px;
  border-color: #fb6f77;
  border-radius: 4px;
  background-color: #fff;
  color: #fb6f77;
  font-size: 13px;
  }

  .onb-button-add-group-text:active {
  background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06));
  }

  .onb-child-group-2 {
    margin-bottom: 24px;
    padding: 24px 32px 32px;
    background-color: hsla(0, 0%, 100%, .1);
    box-shadow: 0 1px 3px 0 rgba(0, 0, 0, .1);
  }
}
</style>
