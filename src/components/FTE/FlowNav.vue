<template>
  <div class="onb-body">
    <div class="title-bar">
      <a
        @click="$emit('prev')"
        v-bind:class="['button-back w-button', 'w-inline-block', {'button-hidden': hidePrevious}]">
      </a>
      <a
        v-if="button !== 'none'"
        @click="$emit('next')"
        :class="classObject"
        class="button-next-text w-button">{{ text }}
      </a>
    </div>
  </div>
</template>

<script>

// states are: skip, next, none, inactive

export default {
  name: 'Nav',
  props: {
    button: {},
    hidePrevious: {
      default: false
    }
  },
  computed: {
    text: function () {
      if (this.button === 'skip') {
        return 'SKIP'
      } else if (this.button === 'done') {
        return 'DONE'
      } else {
        return 'NEXT'
      }
    },
    classObject: function () {
      return {
        'title-bar-next-button-inactive': this.button === 'inactive',
        'title-bar-next-button': !(this.button === 'inactive'),
        'w-inline-block': true
      }
    }
  }
}

</script>

<style scoped>
.onb-body {
  background-color: #f6f6f6;
}

.title-bar {
  font-family: soleil, sans-serif;
}

/* NEW THINGS, CLEAN UP */

.title-bar-next-button {
  position: static;
  display: block;
  margin-top: 0px;
  margin-right: 10px;
  margin-bottom: 0px;
  padding: 10px 12px;
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
  border: 1px none #000;
  border-radius: 4px;
  background-color: #fff;
  box-shadow: none;
  color: #fff;
}

.title-bar-next-button:active {
  background-color: rgba(255, 255, 255, 0.2);
}

.title-bar-next-button-text {
  margin-bottom: 2px;
  font-size: 14px;
  line-height: 14px;
  font-weight: 700;
  letter-spacing: 1.2px;
  text-transform: uppercase;
}

.title-bar-back-button {
  position: absolute;
  left: 0%;
  top: 30px;
  right: auto;
  bottom: auto;
  display: flex;
  margin-top: 8px;
  margin-bottom: 8px;
  margin-left: 16px;
  padding: 24px;
  justify-content: space-between;
  align-items: center;
  border-radius: 50%;
  background-color: transparent;
  background-image: url('../../assets/arrow-back--black.svg');
  background-position: 50% 50%;
  background-size: 24px 24px;
  background-repeat: no-repeat;
  color: #1f88e9;
}

.button-hidden {
  visibility: hidden;
}

.title-bar-back-button:active {
  background-color: hsla(0, 0%, 100%, .2);
  background-image: url('../../assets/arrow-back-white.svg');
  background-size: 24px;
}

.title-bar-next-button-inactive {
  position: static;
  display: block;
  margin-top: 0px;
  margin-right: 10px;
  margin-bottom: 0px;
  padding: 10px 12px;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  border: 1px none #000;
  border-radius: 4px;
  background-color: hsla(0, 0%, 100%, .3);
  box-shadow: none;
}

/* EXISTING WORK FROM WEBFLOW MOCK */

a {
  text-decoration: none;
}

.title-bar {
  position: sticky;
  left: 0;
  top: 0;
  right: 0;
  z-index: 1000;
  display: flex;
  overflow: visible;
  width: 100%;
  min-height: 120px;
  justify-content: space-between;
  align-items: center;
  border-style: none;
  border-width: 1px;
  border-color: rgba(255, 255, 255, 0.1);
  background-color: rgba(255, 255, 255, 0.97);
  background-image: url('../../assets/lilypad__logo.svg');
  background-position: 50% 50%;
  background-size: 125px;
  background-repeat: no-repeat;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.03);
}

.button-back {
  position: absolute;
  left: 0%;
  top: 30px;
  right: auto;
  bottom: auto;
  display: flex;
  margin-top: 8px;
  margin-bottom: 8px;
  margin-left: 16px;
  padding: 24px;
  justify-content: space-between;
  align-items: center;
  border-radius: 50%;
  background-color: transparent;
  background-image: url('../../assets/arrow-back--black.svg');
  background-position: 50% 50%;
  background-size: 24px 24px;
  background-repeat: no-repeat;
  color: #1f88e9;
}

.button-back:active {
  background-color: hsla(0, 0%, 100%, .2);
  background-image: url('../../assets/arrow-back-white.svg');
  background-size: 24px;
}

.button-next {
  position: static;
  display: block;
  margin-top: 0px;
  margin-right: 10px;
  margin-bottom: 0px;
  padding: 10px 12px;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  border: 1px none #000;
  border-radius: 4px;
  background-color: #fff;
  box-shadow: none;
  color: #64426b;
}

.button-next:active {
  background-color: #64426b;
  color: #fff;
}

.button-next-text {
  position: absolute;
  left: auto;
  top: 35px;
  right: 0;
  bottom: auto;
  margin-right: 24px;
  padding: 12px 42px 12px 24px;
  border-radius: 4px;
  background-color: #fc6f77;
  background-image: url('../../assets/navigate-next.svg');
  background-position: 63px 50%;
  background-size: 24px 24px;
  background-repeat: no-repeat;
  text-align: center;
}

@media (max-width: 991px) {
  .title-bar {
    width: auto;
  }
}

@media (max-width: 767px) {
  .button-next-text {
    top: 10px;
    min-width: auto;
    margin-right: 16px;
    padding-bottom: 13px;
    line-height: 14px;
  }

  .title-bar {
    min-height: 60px;
    background-image: url('../../assets/lilypad__logo-abbr.svg');
    background-position: 50% 50%;
    background-size: 36px;
    background-repeat: no-repeat;
  }
}

@media (max-width: 479px) {
  .title-bar {
    display: flex;
    align-items: center;
  }
}
</style>
