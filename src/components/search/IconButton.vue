<template>
<a class="event-action-button" @click="$emit('click')">
    <img v-if="icon" :src="icon" class="action-button-icon" />
    <div class="label-text">{{label}}</div>
</a>
</template>

<script>
export default {
  name: 'IconButton',
  props: {
    label: { required: true },
    icon: {}
  }
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}

.event-action-button {
  display: flex;
  padding: 8px 12px;
  justify-content: flex-start;
  align-items: center;
  border-style: solid;
  border-width: 1px;
  border-color: rgba(0, 0, 0, 0.03);
  border-radius: 4px;
  background-color: #f3f3f3;
  display: flex;
  margin-top: 0;
  margin-right: 8px;
  margin-left: 0;
  align-items: flex-end;
}

.event-action-button:hover {
  background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06));
}

.event-action-button:active {
  background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06));
}

.action-button-icon {
  width: 20px;
  height: 20px;
  margin-right: 6px;
  opacity: 1;
}

.label-text {
  color: #000;
  font-size: 13px;
}

@media (max-width: 991px){
  .event-action-button:hover {
    background-image: linear-gradient(180deg, transparent, transparent);
  }

  .event-action-button:active {
    background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.03), rgba(0, 0, 0, 0.03));
  }

}

@media (max-width: 767px){
  .label-text {
    font-size: 13px;
    line-height: 16px;
  }

}

@media (max-width: 479px){
  .event-action-button {
    width: 100%;
    width: 100%;
    margin-top: 0;
    margin-bottom: 8px;
  }
}
</style>
