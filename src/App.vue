<template>
  <p>{{ message }}</p>
</template>

<script>
export default {
  name: "App",
  props: ["token"],
  computed: {
    message: function() {
      return `Got token ${this.token}`;
    }
  }
};
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
