<template>
  <div class="container-3 w-container">
    <div class="primary-action__card--alt-2">
      <div class="primary-action__positioning-alt-2" :class="{native: isNative}">
        <div class="primary-action__title-text--alt-2">Get the most out of Lilypad!</div>
        <div class="primary-action__btns-container--alt-2">
          <div class="primary-action__btn-group--alt-2">
            <a @click="$emit('offer-playdate-click')" class="btn__primary-action--alt-2 w-button">Offer a playdate</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { platform } from '@/mixins'

export default {
  name: 'GetTheMost',
  mixins: [platform]
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}

.utility-spacer-16px {
  padding: 0 8px;
}

.btn__sec-action--alt-2 {
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

.btn__sec-action--alt-2:hover {
  background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06));
}

.btn__primary-action--alt-2 {
  min-width: 100px;
  border-style: solid;
  border-width: 1px;
  border-color: #fc6f77;
  border-radius: 4px;
  background-color: #fc6f77;
  background-image: none;
  box-shadow: none;
  font-weight: 500;
  text-align: center;
  text-transform: none;
  -webkit-text-fill-color: #fff;
}

.btn__primary-action--alt-2:hover {
  background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06));
}

.primary-action__btn-group--alt-2 {
  display: flex;
}

.primary-action__btns-container--alt-2 {
  display: flex;
  width: 100%;
  align-items: center;
}

.primary-action__title-text--alt-2 {
  margin-bottom: 16px;
  font-size: 16px;
  line-height: 24px;
}

.primary-action__positioning-alt-2 {
  &.native {
    padding-bottom: 30px;
  }
  position: relative;
  width: 100%;
  padding: 16px 20px 18px;
}

.primary-action__card--alt-2 {
  z-index: 900;
  display: flex;
  width: 100%;
  margin-bottom: 0;
  flex-direction: column;
  justify-content: flex-start;
  align-items: flex-start;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
  list-style-type: none;
}

.container-3 {
  position: sticky;
  top: 0;
  z-index: 800;
}

@media (max-width: 991px){
  .btn__sec-action--alt-2:hover {
    background-image: none;
  }

  .btn__primary-action--alt-2:hover {
    background-image: none;
  }

  .primary-action__btn-group--alt-2 {
    display: flex;
    justify-content: flex-start;
    align-items: center;
  }

}

@media (max-width: 767px){
  .btn__sec-action--alt-2 {
    min-width: auto;
    padding-top: 5px;
    padding-bottom: 5px;
    flex: 1;
  }

  .btn__primary-action--alt-2 {
    min-width: auto;
    padding-top: 5px;
    padding-bottom: 5px;
    flex: 1;
  }

  .primary-action__btn-group--alt-2 {
    width: 100%;
  }

  .primary-action__btns-container--alt-2 {
    flex-direction: column;
    justify-content: center;
    flex-wrap: wrap;
    align-items: center;
  }

  .primary-action__title-text--alt-2 {
    margin-bottom: 10px;
    font-size: 14px;
    line-height: 18px;
  }

  .primary-action__card--alt-2 {
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

  .container-3 {
    margin-top: 0;
  }

}

@media (max-width: 479px){
  .btn__sec-action--alt-2 {
    min-width: auto;
    padding-bottom: 8px;
    flex: 1;
    font-size: 13px;
    line-height: 15px;
  }

  .btn__primary-action--alt-2 {
    display: flex;
    min-width: auto;
    padding-bottom: 8px;
    justify-content: center;
    align-items: center;
    flex: 1;
    font-size: 13px;
    line-height: 15px;
  }

  .primary-action__btn-group--alt-2 {
    width: 100%;
    justify-content: center;
    align-items: stretch;
  }

  .primary-action__btns-container--alt-2 {
    flex-direction: column;
  }

}
</style>
