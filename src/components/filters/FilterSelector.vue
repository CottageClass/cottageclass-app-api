<template>
<div class="filter-btn-container" @touchmove="preventTouchMove">
  <div class="filter-button w-button"
       :class="active ? 'active' : ''"
       @click="buttonClick">
    <slot name="buttonContents" />
  </div>
  <div v-if="state.open"
         class="modal-background"
         @click="state.open=false" >
    <div class="dsk-selector-box-container"
         @click.stop >
      <div class="mob-selector-top-bar">
        <div @click="state.open=false" class="mob-selector-close w-inline-block">
          <img src="@/assets/close-x-black.svg" alt="" />
        </div>
        <div class="mob-selector-title">{{ title }}</div>
        <div class="mob-selector-clear-all">
          <div class="mob-selector-clear-all-link"
               @click="$emit('clearFilterClicked')">Clear all</div>
        </div>
      </div>
      <div class="dsk-selector-top">
        <div class="selector-content-container">
          <slot name="selectorContents"></slot>
        </div>
      </div>
      <div class="dsk-selector-action"><a @click.prevent="state.open=false" class="selector-action-btn w-button">Show playdates</a></div>
    </div>
  </div>
</div>
</template>

<script>
export default {
  name: 'FilterSelector',
  props: [ 'title', 'active' ],
  data () {
    return {
      state: {
        open: false,
        active: false
      }
    }
  },
  methods: {
    preventTouchMove (e) {
      if (this.state.open) {
        e.preventDefault()
        e.stopPropagation()
      }
    },
    buttonClick () {
      this.state.open = !this.state.open
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

.container {
  position: relative;
  display: -ms-flexbox;
  display: flex;
  padding: 24px 32px;
  -ms-flex-pack: justify;
  justify-content: space-between;
  -ms-flex-align: center;
  align-items: center;
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
  color: rgba(255 ,255 ,255 ,1);
}

.filter-btn-container {
  margin-bottom: 20px;
}

.dsk-selector-box-container {
  position: absolute;
  z-index: 1000;
  width: 280px;
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
  height: 200px;
  -ms-flex-pack: center;
  justify-content: center;
  -ms-flex-align: start;
  align-items: flex-start;
  background-color: #f2f2f2;
}

.dsk-selector-top {
  width: 100%;
  padding: 24px;
}

.dsk-selector-action {
  display: -ms-flexbox;
  display: flex;
  width: 100%;
  padding: 12px 24px;
  -ms-flex-pack: center;
  justify-content: center;
  -ms-flex-align: center;
  align-items: center;
  border-top: 1px solid rgba(223, 78, 78, .11);
}

.selector-action-btn {
  padding: 8px 16px 9px;
  border-radius: 4px;
  background-color: #1f88e9;
  font-size: 13px;
  text-align: center;
}

.selector-action-btn:active {
  background-image: linear-gradient(180deg, rgba(0, 0, 0, .1), rgba(0, 0, 0, .1));
}

.mob-selector-top-bar {
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
  .container {
    padding: 16px 20px;
  }

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

  .dsk-selector-box-container {
    position: relative;
    width: 100%;
    min-height: 100px;
    margin-top: 0px;
    margin-right: 0px;
    margin-left: 0px;
  }

  .dsk-selector-action {
    position: static;
    left: 0%;
    top: auto;
    right: 0%;
    bottom: 0%;
  }

  .mob-selector-top-bar {
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
    position: fixed;
    left: 0px;
    top: 0px;
    right: auto;
    bottom: auto;
    z-index: 2000;
    width: 100%;
    height: 10000px;
    padding-top: 16px;
    padding-right: 16px;
    padding-left: 16px;
    border-radius: 0px;
    background-color: rgba(0, 0, 0, .4);
  }

  .mob-selector-close2 {
    display: -ms-flexbox;
    display: flex;
    background-color: transparent;
  }
}

@media (max-width: 479px) {
  .container {
    padding-top: 11px;
    padding-bottom: 11px;
  }

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
