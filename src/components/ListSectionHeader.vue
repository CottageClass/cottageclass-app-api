<template>
  <li class="card-list-title-bar">
    <div class="card-list__title-text">{{ title }}</div>
    <ListSectionHeaderButton
      v-if="buttonText"
      :title="buttonText"
      @click="handleClick"/>
  </li>
</template>

<script>
import ListSectionHeaderButton from '@/components/ListSectionHeaderButton'
export default {
  name: 'ListSectionHeader',
  components: { ListSectionHeaderButton },
  props: {
    title: { required: true },
    buttonText: { required: false }
  },
  methods: {
    handleClick () {
      this.$emit('button-click')
    }
  }
}
</script>

<style scoped lang="scss">
.card-list-title-bar {
  display: flex;
  width: 100%;
  margin-top: 0;
  margin-bottom: 4px;
  padding: 16px 20px 18px;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
  list-style-type: none;
}

.card-list__title-text {
  overflow: hidden;
  width: 220px;
  font-size: 16px;
  line-height: 24px;
}

@media (max-width: 991px){
  .card-list__title-text {
    width: 600px;
  }

}

@media (max-width: 767px){
  .card-list-title-bar {
    margin-bottom: 0;
    padding: 16px;
    border-radius: 0;
  }

  .card-list__title-text {
    width: 430px;
    font-size: 14px;
    line-height: 18px;
  }

}

@media (max-width: 479px){
  .card-list__title-text {
    width: 270px;
  }

}
</style>
