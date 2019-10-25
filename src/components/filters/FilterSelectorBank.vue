<template>
  <li class="events-list__title-bar">
    <div class="selectors-group">
      <FilterSelector title="Distance" :showClear="false" :active="shortDescription" >
        <template v-slot:buttonContents>
          <LocationFilterButton :shortDescription="shortDescription" />
        </template>
        <template v-slot:selectorContents>
          <LocationFilterSelector
            @locationUpdated="updateMapAreaFromFilter"
            :searchRadius="mapArea.maxDistance"
          />
        </template>
      </FilterSelector>

      <div class="utility-spacer-16px"></div>

      <FilterSelector title="Child Age"
                      :showClear="true"
                      @clearFilterClicked="resetAgeRange"
                      :active="ageRangeActive" >
        <template v-slot:buttonContents>
          <AgeRangeFilterButton :range="ageRange" />
        </template>
        <template v-slot:selectorContents>
          <AgeRangeFilterSelector
            :value="ageRange"
            @input="updateAgeRange"
          />
        </template>
      </FilterSelector>
    </div>
  </li>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from 'vuex'

import FilterSelector from '@/components/filters/FilterSelector'
import AgeRangeFilterButton from '@/components/filters/AgeRangeFilterButton'
import AgeRangeFilterSelector from '@/components/filters/AgeRangeFilterSelector'
import LocationFilterSelector from '@/components/filters/LocationFilterSelector'
import LocationFilterButton from '@/components/filters/LocationFilterButton'

export default {
  name: 'FilterSelectorBank',
  components: {
    FilterSelector,
    AgeRangeFilterSelector,
    AgeRangeFilterButton,
    LocationFilterSelector,
    LocationFilterButton
  },
  computed: {
    ageRangeActive () {
      return (this.ageRange.min || this.ageRange.min === 0) ||
        (this.ageRange.max || this.ageRange.max === 0)
    },
    shortDescription () {
      return this.mapArea.shortDescription
    },
    ...mapGetters(['mapArea', 'ageRange'])
  },
  methods: {
    updateMapAreaFromFilter (e) {
      this.setMapArea(e)
    },
    updateAgeRange (e) {
      this.setAgeRange(e)
    },
    resetAgeRange () {
      this.setAgeRange({ min: null, max: null })
    },
    ...mapMutations([]),
    ...mapActions(['setAgeRange', 'setMapArea'])
  }
}
</script>

<style scoped>

.events-list__title-bar {
  display: flex;
  width: 100%;
  margin-top: 0px;
  padding: 16px 20px 18px;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
  list-style-type: none;
}

.other-events__title-text {
  overflow: hidden;
  margin-right: 16px;
  font-size: 16px;
  line-height: 24px;
}

.selectors-group {
  display: flex;
  flex-direction: row;
  justify-content: flex-end;
  align-items: flex-start;
}

.utility-spacer-16px {
  padding: 0px 8px;
}

@media (max-width: 767px){
  .other-events__title-text {
    font-size: 14px;
        line-height: 18px;
  }
}
</style>
