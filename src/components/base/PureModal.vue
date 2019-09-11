<template>
<div class="modal-tint"
     @touchmove="preventTouchMove">
  <div class="modal">
    <div class="modal-content-container">
      <div class="modal-content">
        <div class="modal-title-text">{{ title }}</div>
        <div class="modal-description-text" v-html="bodyText"></div>
      </div>
      <div class="mob-selector-close2 w-inline-block"
           @click="$emit('closeButtonClick')">
        <img src="@/assets/close-x-black.svg" alt="" />
      </div>
    </div>
    <div class="modal-actions">
      <div class="modal-primary-action w-button"
         @click="$emit('primaryClick')">
        {{ buttonNames[0] }}
      </div>
      <div class="spacer-12px"></div>
      <div v-if="buttonNames.length > 1"
           class="modal-secondary-action w-button"
           @click="$emit('secondaryClick')">
        {{ buttonNames[1] }}
      </div>
    </div>
  </div>
</div>
</template>

<script>
export default {
  name: 'PureModal',
  props: ['title', 'bodyText', 'buttonNames'],
  data () {
    return {
    }
  },
  methods: {
    preventTouchMove (e) {
      e.preventDefault()
      e.stopPropagation()
    }
  },
  mounted () {
    document.body.classList.add('no-scroll')
    document.documentElement.classList.add('no-scroll')
  },
  destroyed () {
    document.body.classList.remove('no-scroll')
    document.documentElement.classList.remove('no-scroll')
  }
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}

.modal {
  position: relative;
  left: 0%;
  top: 32px;
  right: 0%;
  bottom: auto;
  z-index: 1000;
  display: flex;
  width: 720px;
  min-height: 300px;
  margin-top: 0;
  margin-right: auto;
  margin-left: auto;
  flex-direction: column;
  border-radius: 4px;
  background-color: #fff;
  box-shadow: 1px 1px 24px 0 rgba(0, 0, 0, 0.2);
}

.modal-tint {
  position: fixed;
  left: 0%;
  top: 0%;
  right: 0%;
  bottom: auto;
  z-index: 1;
  min-height: 100vh;
  background-color: rgba(0, 0, 0, 0.6);
}

.modal-content-container {
  position: relative;
  padding: 32px;
}

.modal-actions {
  display: flex;
  width: 100%;
  padding: 24px 32px;
  justify-content: flex-start;
  align-items: center;
  border-top: 1px solid rgba(223, 78, 78, 0.11);
}

.modal-content {
  display: flex;
  min-height: 200px;
  margin-top: 43px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: flex-start;
  background-color: transparent;
}

.modal-primary-action {
  padding: 8px 16px 9px;
  border-style: solid;
  border-width: 1px;
  border-color: rgba(31, 136, 233, 1);
  border-radius: 4px;
  background-color: #1f88e9;
  font-size: 13px;
  text-align: center;
}

.modal-primary-action:active {
  background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.1), rgba(0, 0, 0, 0.1));
}

.modal-secondary-action {
  padding: 8px 16px 9px;
  border-style: solid;
  border-width: 1px;
  border-color: rgba(31, 136, 233, 1);
  border-radius: 4px;
  background-color: rgba(255, 255, 255, 1);
  color: #1f88e9;
  font-size: 13px;
  text-align: center;
}

.modal-secondary-action:active {
  background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.1), rgba(0, 0, 0, 0.1));
}

.spacer-12px {
  min-height: 12px;
  min-width: 12px;
}

.modal-title-text {
  margin-bottom: 20px;
  font-size: 18px;
  line-height: 23.400000000000002px;
  font-weight: 700;
}

.mob-selector-close2 {
  position: absolute;
  left: 0%;
  top: 0%;
  right: auto;
  bottom: auto;
  display: flex;
  height: 59px;
  padding-right: 20px;
  padding-left: 20px;
  align-items: center;
  background-color: transparent;
  cursor: pointer;
}

.mob-selector-close2:active {
  background-color: rgba(0, 0, 0, 0.1);
}

@media (max-width: 991px){
  .modal {
    width: auto;
    margin-right: 32px;
    margin-left: 32px;
  }

}

@media (max-width: 767px){
  .modal {
    top: 0;
    width: auto;
    margin-right: 0;
    margin-left: 0;
  }

  .modal-tint {
    padding: 16px;
  }

  .modal-content-container {
    padding: 20px;
  }

  .modal-actions {
    padding: 16px 20px;
  }

  .mob-selector-close2 {
    display: flex;
    background-color: transparent;
  }

}

@media (max-width: 479px){
  .modal-content {
    align-items: flex-start;
  }

}
</style>
