<template>
  <div class="nav-container" >
    <div class="title-bar"
         :class="{'accomodateNotch': accomodateNotch,
                  'accomodateStatusBar': accomodateStatusBar}"
    >
      <a
        @click="$emit('prev')"
        class="button-back w-inline-block"
        :class="{'button-hidden': !showPrevButton}" />
      <a
        v-if="button !== 'none'"
        @click="$emit('next')"
        :class="classObject">
        <div class="button-next-text">{{ text }}</div>
      </a>
    </div>
  </div>
</template>

<script>

// states are: skip, next, none, inactive
import { platform } from '@/mixins'

export default {
  name: 'Nav',
  mixins: [platform],
  props: {
    button: {},
    hidePrevious: {
      default: false
    }
  },
  computed: {
    showPrevButton () {
      return this.isIOSNativeApp || !this.hidePrevious
    },
    text: function () {
      if (this.button === 'skip') {
        return 'Skip'
      } else if (this.button === 'done') {
        return 'Done'
      } else {
        return 'Next'
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

<style lang="scss" scoped>
.nav-container {
  position: sticky;
  top: 0;
  left: 0;
  right: 0;
}

.title-bar {
  &.accomodateNotch {
    margin-top: 40px;
  }
  &.accomodateStatusBar {
    margin-top: 20px;
  }
  left: 0px;
  top: 0px;
  right: 0px;
  z-index: 1000;
  display: flex;
  overflow: visible;
  width: 100%;
  min-height: 120px;
  margin-right: auto;
  margin-left: auto;
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
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, .08);
}

.title-bar-next-button {
  position: absolute;
  left: auto;
  top: 35px;
  right: 0;
  bottom: auto;
  margin-right: 24px;
  padding: 12px 42px 12px 24px;
  border-radius: 4px;
  background-color: #ff5660;
  background-image: url('../../assets/navigate-next.svg');
  background-position: 63px 50%;
  background-size: 24px 24px;
  background-repeat: no-repeat;
  text-align: center;
  box-shadow: none;
}

.title-bar-next-button-text {
  color: #fff;
}

.button-hidden {
  visibility: hidden;
}

.title-bar-next-button-inactive {
  position: absolute;
  left: auto;
  top: 35px;
  right: 0;
  bottom: auto;
  margin-right: 24px;
  padding: 12px 42px 12px 24px;
  border-radius: 4px;
  background-color: #cacaca;
  background-image: url('../../assets/navigate-next.svg');
  background-position: 63px 50%;
  background-size: 24px 24px;
  background-repeat: no-repeat;
  text-align: center;
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
}

.button-next-text {
  color: #fff;
  cursor: pointer;
}

@media (hover: hover) {
.title-bar-next-button-inactive:hover {
  background-color: #fc6f77;
  box-shadow: none;
}

.button-back:hover {
  background-image: url('../../assets/arrow-back--black.svg'), linear-gradient(180deg, #f1f1f1, #f1f1f1);
  background-position: 50% 50%, 0 0;
  background-size: 24px 24px, auto;
  background-repeat: no-repeat, repeat;
}

}

@media (max-width: 991px) {
  .nav-container{
    width: 100%;
  }
}
@media (max-width: 767px) {
  .title-bar {
    min-height: 60px;
    background-image: url('../../assets/lilypad__logo-abbr.svg');
    background-position: 50% 50%;
    background-size: 36px;
    background-repeat: no-repeat;
  }

  .button-back {
    top: 0;
    .accomodateNotch & {
      top: 40px;
    }
    .accomodateStatusBar & {
      top: 20px;
    }
    margin-top: 0px;
    margin-left: 0px;
    padding: 30px;
    border-radius: 0%;
    background-position: 50% 50%;
    background-size: 24px 24px;
    background-repeat: no-repeat;
  }
  .title-bar-next-button, .title-bar-next-button-inactive  {
    .accomodateNotch & {
      top: 50px;
    }
    .accomodateStatusBar & {
      top: 30px;
    }
    top: 10px;
    min-width: auto;
    margin-right: 16px;
    padding-bottom: 13px;
    line-height: 14px;
  }
}

@media (max-width: 479px) {
  .nav-container{
    align-items: center;
  }
  .button-back {
    left: -5px;
  }
}
</style>
