<template>
  <a @click="$emit('click')"
     class="btn-small-outline w-button">{{ title }}</a>
</template>

<script>
export default {
  name: 'ListSectionHeaderButton',
  props: { title: { required: true } }
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}

.btn-small-outline {
  margin-right: 0;
  padding: 4px 10px 5px;
  flex: 0 0 auto;
  border: 1px solid #1f88e9;
  border-radius: 4px;
  background-color: transparent;
  color: #1f88e9;
  font-size: 13px;
}

.btn-small-outline:hover {
  background-color: rgba(0, 0, 0, 0.06);
}

.btn-small-outline:active {
  background-image: linear-gradient(180deg, #1f88e9, #1f88e9);
  color: #fff;
}

@media (max-width: 991px){
  .btn-small-outline:hover {
    background-color: #fff;
  }

}
</style>
