<template>
  <div class="page-actions-wrapper">
    <div class=button-container>
      <div v-if="$slots.first"><slot name="first"/></div>
      <a v-else @click="primaryActive && $emit('primary-click')"
        class="button-primary w-button"
        :class="!primaryActive ? 'inactive' : ''">
          {{ primaryText }}
      </a>
    </div>
    <div v-if="hasTwoButtons" class=button-container>
      <div v-if="$slots.second"><slot name="second"/></div>
      <a v-else @click="secondaryActive && $emit('secondary-click')"
        class="button-secondary w-button"
        :class="!secondaryActive ? 'inactive' : ''">
        {{ secondaryText }}
      </a>
    </div>
  </div>
</template>

<script>
export default {
  props: ['buttons'],
  name: 'PageActionsFooter',
  computed: {
    firstIsComponent () {
      console.log(this.buttons[0])
      return false
    },
    hasTwoButtons () {
      return this.buttons.length >= 2 || this.$slots.second
    },
    primaryText () {
      return this.buttons[0].text
    },
    secondaryText () {
      return this.buttons[1].text
    },
    primaryActive () {
      return this.isActive(0)
    },
    secondaryActive () {
      return this.isActive(1)
    },
    isActive () {
      return function (i) {
        if (this.buttons[i].hasOwnProperty('active') && !this.buttons[i].active) {
          return false
        }
        return true
      }
    }
  }
}
</script>

<style scoped>
.button-container {
  width: 100%;
  margin-right: 4px;
  margin-left: 4px;
}
.page-actions-wrapper a {
  display: flex;
  margin-bottom: 0px;
  padding: 6px 10px;
  justify-content: center;
  align-items: center;
  font-size: 12px;
  line-height: 15px;
  text-align: center;
  border-radius: 4px;
}
.page-actions-wrapper a.inactive {
  opacity: 0.3;
  cursor: default;
}
.button-primary {
  background-color: #1f88e9;
  border-color: hsla(208.8118811881188, 82.11%, 51.76%, 1.00);
}
.button-secondary {
  border: 1px hsla(208, 82.11%, 51.76%, 1.00) solid;
  background-color: hsla(208, 0.00%, 100.00%, 1.00);
  color: hsla(208, 82.11%, 51.76%, 1.00);
}

.button-primary:hover {
  border-color: #1b7bd1;
  background-color: #1b7bd1;
  text-decoration: none;
}

.page-actions-wrapper {
  position: fixed;
  left: 0%;
  top: auto;
  right: 0%;
  bottom: 0%;
  padding: 16px;
  background-color: #fff;
  box-shadow: 0 -1px 2px 0 rgba(0, 0, 0, .08);
  display: flex;
  margin-top: 16px;
  justify-content: space-between;
  align-items: center;
}

@media (max-width: 991px) {

  .button-primary {
    height: auto;
  }

  .button-primary:hover {
    border-color: #1f88e9;
    background-color: #1f88e9;
  }

  .button-primary:active {
    background-color: #1b7bd1;
  }
}

@media (max-width: 767px) {

  .button-primary {
    display: block;
    padding-top: 6px;
    padding-bottom: 7px;
    -webkit-align-self: center;
    -ms-flex-item-align: center;
    -ms-grid-row-align: center;
    align-self: center;
    -webkit-box-flex: 0;
    -webkit-flex: 0 auto;
    -ms-flex: 0 auto;
    flex: 0 auto;
  }

  .page-actions-wrapper {
    width: auto;
    min-width: 0px;
    padding-top: 8px;
    padding-bottom: 8px;
    -webkit-box-orient: horizontal;
    -webkit-box-direction: normal;
    -webkit-flex-direction: row;
    -ms-flex-direction: row;
    flex-direction: row;
    -webkit-box-pack: center;
    -webkit-justify-content: center;
    -ms-flex-pack: center;
    justify-content: center;
    -webkit-box-align: center;
    -webkit-align-items: center;
    -ms-flex-align: center;
    align-items: center;
  }
}

@media (max-width: 479px) {
  .button-primary {
    width: 100%;
  }
}
</style>
