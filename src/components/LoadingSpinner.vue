<template>
  <div class="loading-container" v-bind:style="containerStyle" >
    <div v-bind:style="styles" class="spinner spinner--circle-8">
      <div v-bind:style="innerStyles" class="spinner-inner">
        <div class="ball-container">
          <div class="contener_mixte"><div class="ballcolor ball_1">&nbsp;</div></div>
          <div class="contener_mixte"><div class="ballcolor ball_2">&nbsp;</div></div>
          <div class="contener_mixte"><div class="ballcolor ball_3">&nbsp;</div></div>
          <div class="contener_mixte"><div class="ballcolor ball_4">&nbsp;</div></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'LoadingSpinner',
  props: {
    marginTop: {
      default: '100px'
    },
    size: {
      default: '50px'
    }
  },
  computed: {
    containerStyle () {
      return { 'margin-top': this.marginTop }
    },
    innerStyles () {
      let size = parseInt(this.size)
      return {
        transform: 'scale(' + (size / 44) + ')'
      }
    },
    styles () {
      return {
        width: this.size,
        height: this.size
      }
    }
  }
}
</script>

<style lang="scss" scoped>
  .onb-body
  {
    height: 100vh;
  }
  .loading-container
  {
    margin: auto;
    width: 50px;
    height: 50px;
    margin-top: 100px;
  }
  .spinner{
    * {
      line-height: 0;
      box-sizing: border-box;
    }
  }
  .ball-container
  {
    animation:animball_two 1.5s infinite;
    width:44px;
    height:44px;
    flex-shrink: 0;
    position: relative;
  }
  .contener_mixte
  {
    width:44px; height:44px; position:absolute;
  }
  .ballcolor
  {
    width: 20px;
    height: 20px;
    border-radius: 50%;
  }
  .ball_1, .ball_2, .ball_3, .ball_4
  {
    position: absolute;
    animation:animball_one 1.5s infinite ease;
  }
  .ball_1
  {
    background-color:#f7484e;
    top:0; left:0;
  }
  .ball_2
  {
    background-color:#f8b334;
    top:0; left:24px;
  }
  .ball_3
  {
    background-color:#41b883;
    top:24px; left:0;
  }
  .ball_4
  {
    background-color:#34495e;
    top:24px; left:24px;
  }

  @keyframes animball_one
  {
    0%{ position: absolute;}
    50%{top:12px; left:12px; position: absolute;opacity:0.5;}
    100%{ position: absolute;}
  }

  @keyframes animball_two
  {
    0%{transform:rotate(0deg) scale(1);}
    50%{transform:rotate(360deg) scale(1.3);}
    100%{transform:rotate(720deg) scale(1);}
  }
</style>
