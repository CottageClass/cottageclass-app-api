
<template>
  <div>
    <div class="providerp-background-check-badge-container2" v-if="person.verified">
      <div class="providerp-background-check-badge"><img src="../../assets/check-green.svg" alt="" class="checkmark-image">
        <div class="background-check-text">Background checked</div>
      </div>
    </div>

    <div class="tag-group-container" v-if="person.activities.length"><img src="../../assets/tag.svg" class="image-tag">
      <div class="tags-container" v-for="activity in person.activities">
        <div class="tag">
          <div class="small-text-upper-black-40">{{ activity }}</div>
        </div>
      </div>
    </div>
    <div class="time-group-container">
      <img src="../../assets/time.svg" class="image-time">
      <div class="times-container">
        <div class="time" v-if="person.availableMornings">
          <div class="time-tags">9a–3p</div>
        </div>
        <div class="time" v-if="person.availableAfternoons">
          <div class="time-tags">3p–7p</div>
        </div>
        <div class="time" v-if="person.availableEvenings">
          <div class="time-tags">7p-</div>
        </div>
        <div class="time" v-if="person.availableWeekends">
          <div class="time-tags">WEEKENDS</div>
        </div>
      </div>
    </div>
    <div class="list-item-content-container"></div>
  </div>
</template>


<script>
export default {
  name: 'ProviderInfo',
  props: ['person'],
  components: { }
}
</script>

<style scoped>
.providerp-background-check-badge-container2 {
  margin-top: 8px;
  margin-bottom: 6px;
}
.providerp-background-check-badge {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  padding: 5px 10px;
  -webkit-box-align: center;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
  border-radius: 500px;
  background-color: rgba(12, 186, 82, .2);
}

.background-check-text {
  margin-top: 1px;
  color: #0dba52;
  font-size: 10px;
  line-height: 9px;
  font-weight: 700;
  letter-spacing: 1.5px;
  text-transform: uppercase;
}

.providerp-background-check-badge-container {
  margin-bottom: 6px;
}

.time-group-container {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  -webkit-box-align: start;
  -webkit-align-items: flex-start;
  -ms-flex-align: start;
  align-items: flex-start;
}

.tag-group-container {
  display: -webkit-box;
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  margin-top: 6px;
  margin-bottom: 8px;
  -webkit-box-align: start;
  -webkit-align-items: flex-start;
  -ms-flex-align: start;
  align-items: flex-start;
  flex-wrap: wrap;
}

.times-container {
  width: 100%;
}

.times-container {
  width: 100%;
}

.time {
  display: inline-block;
  margin-right: 6px;
  margin-bottom: 6px;
  padding: 4px 6px;
  clear: none;
  border-radius: 2px;
  background-color: rgba(100, 66, 107, .2);
}

.tag {
  display: inline-block;
  margin-right: 4px;
  margin-bottom: 4px;
  padding: 4px 6px;
  clear: none;
  border-radius: 2px;
  background-color: rgba(0, 0, 0, .1);
}

.time-block {
  color: #2b8eea;
  font-size: 16px;
}

.time-tags {
  margin-top: 1px;
  color: #64426b;
  font-size: 9px;
  line-height: 9px;
  font-weight: 700;
  letter-spacing: 1.03px;
}

@media (max-width: 479px) {
 .tag-group-container {
    display: -webkit-box;
    display: -webkit-flex;
    display: -ms-flexbox;
    display: flex;
    -webkit-box-align: start;
    -webkit-align-items: flex-start;
    -ms-flex-align: start;
    align-items: flex-start;
  }

  .tag {
    clear: both;
  }

  .time {
    clear: both;
  }

}

</style>
