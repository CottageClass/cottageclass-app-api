<template>
  <span class="body">
  <div class="scrolling-wrapper">
    <div class="card" v-for="image in person.images"><img :src="image"></div>
  </div>
</span>
</template>

<script>
export default {
  name: 'Images',
  props: ['person']
}
</script>

<style scoped>

.scrolling-wrapper {
  overflow-x: auto;
}

.card {
    flex: 0 0 auto;
  }

.card img {
  height: 100%;
  width: auto;
}

.scrolling-wrapper {
  -webkit-overflow-scrolling: touch;
}

.scrolling-wrapper {
  &::-webkit-scrollbar {
    display: none;
  }
}

.body {
  background-color: #f2f2f2;
}

.child {
  white-space:nowrap;
}

.scrolling-wrapper {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
  background-color: #fff;
}

.card {
  width: auto;
  height: 111px;
  margin-right: 4px;
  background-color: #fff;
}

</style>
