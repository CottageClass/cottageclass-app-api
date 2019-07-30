<template>
<li class="card-empty">
  <img v-if="options.image" :src="options.image" class="card-empty__image" />
  <div class="card-empty__title-text">{{ options.title }}</div>
  <a
     @click.prevent="$emit('button-click')"
     class="card-empty__btn-small-blue w-button">{{ options.buttonText }}</a>
  <a
     @click.prevent="$emit('additional-link-click')"
     class="card-empty__btn-link">{{ options.additionalLinkText }}</a>
</li>
</template>

<script>
export default {
  name: 'ListSectionEmptyCard',
  props: {
    options: { required: true }
  }
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}

.card-empty {
  display: flex;
  width: 100%;
  margin-top: 0;
  margin-bottom: 4px;
  padding: 32px 20px 40px;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
  list-style-type: none;
}

.card-empty__image {
  width: 100px;
  height: 100px;
  margin-bottom: 8px;
}

.card-empty__title-text {
  margin-bottom: 16px;
  font-size: 15px;
  text-align: center;
}

.card-empty__btn-link {
  color: #198ef8;
  text-align: center;
}

.card-empty__btn-small-blue {
  display: block;
  margin-bottom: 16px;
  padding: 4px 16px 5px;
  border: 1px solid transparent;
  border-radius: 4px;
  background-color: #1f88e9;
  color: #fff;
  font-size: 12px;
  font-weight: 400;
}

.card-empty__btn-small-blue:hover {
  background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06));
}

@media (max-width: 991px){
  .card-empty__btn-small-blue:hover {
    background-image: none;
  }

  .card-empty__btn-small-blue:active {
    background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06));
  }

}

@media (max-width: 767px){
  .card-empty {
    margin-bottom: 0;
    padding: 16px;
    border-radius: 0;
  }

}

@media (max-width: 479px){
  .card-empty__btn-small-blue {
    text-align: center;
  }

}
</style>
