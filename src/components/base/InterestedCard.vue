<template>
  <div class="primary-action__card--alt">
    <div class="primary-action__positioning">
      <div class="primary-action__title-text--alt">{{title}}</div>
      <div class="primary-action__btns-container--alt">
        <div class="primary-action__btn-group--alt">
          <a class="btn__primary-action--alt w-button"
             :class="showPrimaryStar ? 'star-background' : ''"
             @click="$emit('primary-click')">Yes!</a>
          <div class="utility-spacer-16px">
          </div>
          <a @click.prevent="$emit('secondary-click')"
             class="btn__sec-action--alt w-button">No</a>
        </div>
        <a v-if="otherText"
           @click="$emit('other-click')"
           class="btn__sec-action-text--alt">{{otherText}}</a>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'InterestedCard',
  props: {
    title: {
      type: String,
      required: true
    },
    otherText: {
      type: String,
      default: null
    },
    showPrimaryStar: {
      type: Boolean,
      default: false
    }
  }
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}
.star-background {
  background-image: url(../../assets/star-white.svg);
  background-position: 9px 9px;
  background-size: 18px 18px;
  background-repeat: no-repeat;
  &:hover {
    background-position: 0px 0px, 9px 9px;
    background-size: auto, 18px 18px;
    background-repeat-x: repeat, no-repeat;
    background-repeat-y: repeat, no-repeat;
    background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06)), url(../../assets/star-white.svg);
  }
}

.utility-spacer-16px {
  padding: 0 8px;
}

.primary-action__card--alt {
  position: sticky;
  top: 0;
  z-index: 3000;
  display: flex;
  width: 100%;
  margin-bottom: 16px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: flex-start;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
  list-style-type: none;
}

.primary-action__title-text--alt {
  margin-bottom: 16px;
  font-size: 16px;
  line-height: 24px;
}

.primary-action__btns-container--alt {
  display: flex;
  width: 100%;
  align-items: center;
}

.primary-action__btn-group--alt {
  display: flex;
}

.btn__primary-action--alt {
  min-width: 180px;
  color: #fff;
  border-style: solid;
  border-width: 1px;
  border-color: #fc6f77;
  border-radius: 4px;
  background-color: #fc6f77;
  box-shadow: none;
  font-weight: 500;
  text-align: center;
  text-transform: none;
}

.btn__sec-action--alt {
  min-width: 180px;
  border-style: solid;
  border-width: 1px;
  border-color: #a1a1a1;
  border-radius: 4px;
  background-color: #fff;
  color: #000;
  font-weight: 300;
  text-align: center;
  text-transform: none;
}

.btn__sec-action--alt:hover {
  background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06));
}

.btn__sec-action-text--alt {
  margin-right: 16px;
  margin-left: 16px;
  color: #1f88e9;
}

.primary-action__positioning {
  position: relative;
  width: 100%;
  padding: 16px 20px 18px;
}

@media (max-width: 991px){
  .primary-action__btn-group--alt {
    display: flex;
    justify-content: flex-start;
    align-items: center;
  }
}

@media (max-width: 767px){
  .primary-action__card--alt {
    position: fixed;
    left: 0%;
    top: auto;
    right: 0%;
    bottom: 0;
    margin-bottom: 0;
    align-items: center;
    border-radius: 0;
    box-shadow: 0 1px 10px 0 rgba(0, 0, 0, 0.08);
  }

  .primary-action__title-text--alt {
    margin-bottom: 10px;
    font-size: 14px;
    line-height: 18px;
  }

  .primary-action__btns-container--alt {
    flex-direction: column;
    justify-content: center;
    flex-wrap: wrap;
    align-items: center;
  }

  .primary-action__btn-group--alt {
    width: 100%;
  }

  .btn__primary-action--alt {
    min-width: auto;
    padding-top: 5px;
    padding-bottom: 5px;
    flex: 1;
  }

  .btn__sec-action--alt {
    min-width: auto;
    padding-top: 5px;
    padding-bottom: 5px;
    flex: 1;
  }

  .btn__sec-action-text--alt {
    position: absolute;
    left: auto;
    top: 4px;
    right: 5px;
    bottom: auto;
    margin-top: 12px;
    font-size: 12px;
    line-height: 18px;
  }

}

@media (max-width: 479px){
  .primary-action__btns-container--alt {
    flex-direction: column;
  }

  .primary-action__btn-group--alt {
    width: 100%;
    justify-content: center;
  }

  .btn__primary-action--alt {
    min-width: auto;
    flex: 1;
    font-size: 13px;
  }

  .btn__sec-action--alt {
    min-width: auto;
    flex: 1;
    font-size: 13px;
  }

  .btn__sec-action-text--alt {
    line-height: 18px;
  }

}
</style>
