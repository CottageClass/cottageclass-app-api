<template>
  <div class="filter-btn-container-alt">
    <div class="filter-button w-button"
         :class="active ? 'active' : ''"
         @click="openSelector">
      <slot name="buttonContents" />
    </div>
    <div v-if="state.open"
         class="modal-background"
         @click="closeSelector"
         @touchmove="preventTouchMove">
    </div>
    <div v-if="state.open" class="selector-box-container"
         @click.stop
         @touchmove="selectorTouchMove">
      <div class="selector-top-bar">
        <div @click="closeSelector" class="mob-selector-close w-inline-block">
          <img src="@/assets/close-x-black.svg" alt="" />
        </div>
        <div class="mob-selector-title">{{ title }}</div>
        <div class="mob-selector-clear-all" v-if="showClear">
          <div class="mob-selector-clear-all-link"
               @click="$emit('clearFilterClicked')">Clear</div>
        </div>
      </div>
      <div class="selector-top">
        <div class="selector-content-container">
          <slot name="selectorContents"></slot>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'FilterSelector',
  props: [ 'title', 'active', 'showClear' ],
  data () {
    return {
      state: {
        open: false,
        active: false
      }
    }
  },
  methods: {
    openSelector () {
      this.state.open = true
    },
    closeSelector () {
      this.state.open = false
    },
    selectorTouchMove (e) {
      e.preventDefault()
    },
    preventTouchMove (e) {
      if (this.state.open) {
        e.preventDefault()
        e.stopPropagation()
      }
    }
  }
}
</script>

<style scoped lang="scss">
body {
  font-family: soleil, sans-serif;
  color: #333;
  font-size: 14px;
  line-height: 20px;
}

.button {
  min-height: 40px;
  margin-left: 16px;
  border: 1px solid #c2c2c2;
  border-radius: 4px;
  background-color: #fff;
  color: #000;
  font-size: 12px;
  letter-spacing: 2px;
  text-transform: uppercase;
}

.button:hover {
  background-image: linear-gradient(180deg, rgba(0, 0, 0, .04), rgba(0, 0, 0, .04));
}

.button:active {
  border-color: #1f88e9;
  background-color: #1f88e9;
  background-image: linear-gradient(180deg, rgba(0, 0, 0, .1), rgba(0, 0, 0, .1));
  color: #fff;
}

.body {
  background-color: #f5f5f5;
}

.playdates-content-container {
  position: relative;
  display: -ms-flexbox;
  display: flex;
  margin-bottom: 100px;
  padding: 40px 32px;
  -ms-flex-direction: row;
  flex-direction: row;
  -ms-flex-pack: start;
  justify-content: flex-start;
  -ms-flex-align: start;
  align-items: flex-start;
}

.top-container {
  position: relative;
  display: -ms-flexbox;
  display: flex;
  padding-right: 32px;
  padding-bottom: 24px;
  padding-left: 32px;
  -ms-flex-direction: column;
  flex-direction: column;
  -ms-flex-align: start;
  align-items: flex-start;
}

.docnote {
  min-height: 50px;
  color: #d9d9d9;
  font-size: 12px;
  line-height: 15px;
  text-align: center;
  text-transform: uppercase;
}

.date-title {
  font-size: 24px;
  line-height: 28px;
  text-align: center;
}

.filter-button {
  margin-right: auto;
  margin-left: auto;
  padding: 4px 10px 5px;
  border: 1px solid #1f88e9;
  border-radius: 4px;
  background-color: transparent;
  color: #1f88e9;
  font-size: 13px;
}

.filter-button.active {
  background-image: linear-gradient(180deg, rgba(31 ,136 ,233 ,1), rgba(31 ,136 ,233 ,1));
  color: #ff;
  -webkit-text-fill-color: #fff;  // keep for safari
}

.selector-box-container {
  position: absolute;
  z-index: 1000;
  min-height: 300px;
  margin-top: 4px;
  border-radius: 4px;
  background-color: #fff;
  box-shadow: 1px 1px 24px 0 rgba(0, 0, 0, .2);
}

.selector-content-container {
  display: -ms-flexbox;
  display: flex;
  width: 100%;
  min-height: 200px;
  justify-content: center;
  align-items: flex-start;
}

.selector-top {
  width: 100%;
  padding: 24px;
}

.selector-top-bar {
  position: relative;
  display: -ms-flexbox;
  display: flex;
  height: 60px;
  -ms-flex-pack: start;
  justify-content: flex-start;
  -ms-flex-align: center;
  align-items: center;
  border-bottom: 1px solid rgba(223, 79, 79, .11);
}

.mob-selector-close {
  position: absolute;
  left: 0%;
  top: 0%;
  right: auto;
  bottom: auto;
  display: none;
  height: 59px;
  padding-right: 20px;
  padding-left: 20px;
  -ms-flex-align: center;
  align-items: center;
  background-color: #fff;
}

.mob-selector-close:active {
  background-color: rgba(0, 0, 0, .1);
}

.mob-selector-clear-all {
  position: absolute;
  left: auto;
  top: 0%;
  right: 0%;
  bottom: auto;
  display: -ms-flexbox;
  display: flex;
  height: 59px;
  padding-right: 20px;
  padding-left: 20px;
  -ms-flex-pack: end;
  justify-content: flex-end;
  -ms-flex-align: center;
  align-items: center;
  background-color: transparent;
}

.mob-selector-clear-all:active {
  background-color: rgba(0, 0, 0, .1);
}

.mob-selector-title {
  margin-left: 24px;
  font-size: 15px;
  text-align: center;
}

.mob-selector-clear-all-link {
  cursor: pointer;
  color: #1f88e9;
  font-size: 13px;
}

.modal {
  position: relative;
  left: 0%;
  top: 32px;
  right: 0%;
  bottom: auto;
  z-index: 1000;
  display: -ms-flexbox;
  display: flex;
  width: 720px;
  min-height: 300px;
  margin-top: 0px;
  margin-right: auto;
  margin-left: auto;
  -ms-flex-direction: column;
  flex-direction: column;
  border-radius: 4px;
  background-color: #fff;
  box-shadow: 1px 1px 24px 0 rgba(0, 0, 0, .2);
}

.modal-content-container {
  position: relative;
  width: 100%;
  padding: 32px;
}

.modal-content {
  display: -ms-flexbox;
  display: flex;
  width: 100%;
  min-height: 200px;
  margin-top: 43px;
  -ms-flex-direction: column;
  flex-direction: column;
  -ms-flex-pack: start;
  justify-content: flex-start;
  -ms-flex-align: start;
  align-items: flex-start;
  background-color: transparent;
}

.mob-selector-close2 {
  position: absolute;
  left: 0%;
  top: 0%;
  right: auto;
  bottom: auto;
  display: -ms-flexbox;
  display: flex;
  height: 59px;
  padding-right: 20px;
  padding-left: 20px;
  -ms-flex-align: center;
  align-items: center;
  background-color: transparent;
}

.mob-selector-close2:active {
  background-color: rgba(0, 0, 0, .1);
}

.modal-background {
  position: fixed;
  left: 0px;
  top: 0px;
  right: auto;
  bottom: auto;
  z-index: 999;
  width: 100%;
  height: 10000px;
  padding-top: 16px;
  padding-right: 16px;
  padding-left: 16px;
  border-radius: 0px;
  background-color: rgba(0, 0, 0, 0);
}

@media (max-width: 991px) {
  .playdates-content-container {
    padding-top: 32px;
    padding-bottom: 32px;
    -ms-flex-direction: column-reverse;
    flex-direction: column-reverse;
  }

  .modal {
    width: auto;
    margin-right: 32px;
    margin-left: 32px;
  }
}

@media (max-width: 767px) {
  .playdates-content-container {
    padding-top: 0px;
    padding-right: 20px;
    padding-left: 20px;
  }

  .top-container {
    padding-right: 20px;
    padding-left: 20px;
  }

  .date-title {
    font-size: 22px;
    line-height: 26px;
  }

  .selector-box-container {
    position: fixed;
    left: 16px;
    top: 16px;
    right: 16px;
    bottom: auto;
    width: auto;
    min-height: 100px;
    margin-top: 0px;
    margin-right: 0px;
    margin-left: 0px;
  }

  .selector-top-bar {
    -ms-flex-pack: center;
    justify-content: center;
    border-top-left-radius: 4px;
    border-top-right-radius: 4px;
  }

  .mob-selector-close {
    display: -ms-flexbox;
    display: flex;
    background-color: transparent;
  }

  .mob-selector-title {
    margin-left: 0px;
  }

  .modal {
    top: 0px;
    width: auto;
    margin-right: 0px;
    margin-left: 0px;
  }

  .modal-content-container {
    padding: 20px;
  }

  .modal-background {
    background-color: rgba(0, 0, 0, .4);
  }

  .mob-selector-close2 {
    display: -ms-flexbox;
    display: flex;
    background-color: transparent;
  }
}

@media (max-width: 479px) {
  .button {
    min-height: auto;
    margin-left: 10px;
    padding: 6px 10px;
  }

  .date-title {
    font-size: 18px;
    line-height: 24px;
    text-align: left;
  }

  .selector-content-container {
    -ms-flex-align: start;
    align-items: flex-start;
  }

  .modal-content {
    -ms-flex-align: start;
    align-items: flex-start;
  }
}
</style>
