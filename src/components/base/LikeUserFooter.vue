<template>
<div class="floating-buttons-container">
  <div class="floating-buttons__title-text">Are you interested in a playdate with {{user.firstName}}?</div>
  <ul class="floating-buttons-list">
    <li class="floating-button-item">
      <IconButton label="Yes"
                  :icon="starIcon"
                  @click="$emit('click-yes')"
      />
    </li>
    <li class="floating-button-item">
      <IconButton label="No"
                  :icon="null"
                  @click="$emit('click-no')"
      />
    </li>
  </ul>
</div>
</template>

<script>
import starIcon from '@/assets/star-black-outline.svg'
import { mapGetters } from 'vuex'
import IconButton from '@/components/search/IconButton'

export default {
  name: 'LikeUserFooter',
  components: { IconButton },
  props: {
    user: { required: true }
  },
  computed: {
    starIcon: () => starIcon,
    ...mapGetters(['currentUser'])
  }
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}

.floating-buttons-container {
  position: fixed;
  left: 0%;
  top: auto;
  right: 0%;
  bottom: 0%;
  display: flex;
  width: 230px;
  margin: 0 auto 16px;
  padding: 24px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  border-radius: 4px;
  background-color: #1f88e9;
  box-shadow: 0 -1px 30px 0 rgba(0, 0, 0, 0.3);
  list-style-type: none;
}

.floating-buttons__title-text {
  text-align: center;
  color: #fff;
  font-size: 14px;
  line-height: 15.600000000000001px;
}

.floating-buttons-list {
  display: flex;
  margin-top: 16px;
  margin-right: -8px;
  margin-bottom: 0;
  padding-left: 0;
  list-style-type: none;
}

.floating-button-item {
  display: flex;
  margin: 0 8px 0 0;
  align-items: flex-end;
}

@media (max-width: 991px){
  .floating-buttons-container {
    width: 230px;
  }
}

@media (max-width: 479px){
  .floating-buttons-container {
    padding: 16px 16px 20px;
  }

  .floating-buttons-list {
    flex-direction: row;
  }

  .floating-button-item {
    margin-top: 0;
  }

}
</style>
