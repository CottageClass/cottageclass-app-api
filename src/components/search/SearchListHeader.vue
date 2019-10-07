<template>
  <div class="events__actions">
    <ul class="events__actions__button-list">
      <li class="events__actions__button-item">
        <a @click="$emit('offer-playdate-click')" class="events__actions__button offer-playdate w-button">Offer Playdate</a>
      </li>
    </ul>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'SearchListHeader',
  computed: mapGetters(['isAuthenticated'])
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}

.events__actions {
  display: flex;
  width: 100%;
  margin-top: 0;
  padding: 16px 20px 18px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: stretch;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
  list-style-type: none;
}

.events__actions__button-list {
  display: flex;
  margin-bottom: 0;
  padding-left: 0;
  list-style-type: none;
}

.events__actions__button-item {
  margin-right: 8px;
}

.events__actions__button{
  &.offer-playdate {
    background-image: url('../../assets/heart__blue.svg');
    &:hover {
      background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.1), rgba(0, 0, 0, 0.1)), url('../../assets/heart__blue.svg');
    }
  }
  margin-right: 0;
  padding: 4px 10px 5px 26px;
  border-style: solid;
  border-width: 1px;
  border-color: #1f88e9;
  border-radius: 4px;
  background-color: #fff;
  background-position: 6px 49%;
  background-size: 16px 16px;
  background-repeat: no-repeat;
  color: #1f88e9;
  &:hover {
    background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.1), rgba(0, 0, 0, 0.1)), url('../../assets/heart__blue.svg');
    background-position: 0 0, 6px 49%;
    background-size: auto, 16px 16px;
    background-repeat: repeat, no-repeat;
  }
}

@media (max-width: 991px){
  .events__actions__button:hover {
    background-image: linear-gradient(180deg, transparent, transparent), url('../../assets/heart__blue.svg');
  }

  .events__actions__button:active {
    background-position: 0 0, 6px 49%;
    background-size: auto, 16px 16px;
    background-repeat: repeat, no-repeat;
    &.offer-playdate {
      background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.03), rgba(0, 0, 0, 0.03)), url('../../assets/heart__blue.svg');
    }
  }

}

@media (max-width: 767px){
  .events__actions {
    position: fixed;
    left: 0%;
    top: auto;
    right: 0%;
    bottom: 0%;
    z-index: 1000;
    padding: 10px 16px;
    border-radius: 0;
    box-shadow: 0 0 5px 0 rgba(0, 0, 0, 0.08);
  }

  .events__actions__button-list {
    justify-content: center;
  }

}
</style>
