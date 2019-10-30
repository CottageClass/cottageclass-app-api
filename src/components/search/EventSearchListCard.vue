<template>
  <li class="events-list__event-summary-card"
      @click.stop="goToItem">
    <router-link
      :to="link"
      @click.native="$event.stopImmediatePropagation()">
      <div class="header">
        <div class="header__date"
             :class="{'time-past': timePast}" >
          {{ eventTimeHeader }}
          <span v-if="eventAgeRange !== ''" class="gray-bullet-text">•</span>
          {{ eventAgeRange }}
        </div>
        <div v-if="distance" class="header__distance">{{distance}}</div>
      </div>
      <div class="event-summary-card__title line-clamp--1">{{name}}</div>
    </router-link>
    <router-link
      :to="link"
      @click.native="$event.stopImmediatePropagation()">

      <div class="event-summary-card__info">
        <div class="event-summary-card__text">
          <div class="event-summary-card__loca-desc"><span class="place-name">{{playdateLocationNameListItem}}</span>{{description}}</div>
        </div>
        <div class="event-summary-card__image">
          <AvatarImage
            className="photo"
            :event="event"
            :person="user"
            imageSize="85"
          />
        </div>
      </div>

    </router-link>
    <div class='event-summary-card__actions-avatars'>
      <div class='event-summary-card__actions'>
        <SearchListCardActions
          :user="item.user"
          :event="item.event"
          @user-updated="$emit('user-updated', $event)"
          @event-updated="$emit('event-updated', $event)"
          @event-deleted="$emit('event-deleted', id)"
          @going-click="goingClick"
          @contact-click="contactClick"
          @edit-click="editClick"
          @interested-click="interestedClick('card')"
          :timePast="timePast"
          :showGoingButton="showGoingButton"
          :showEditButton="showEditButton"
          :showInterestedButton="showInterestedButton"
        />
      </div>
    </div>

  </li>
</template>

<script>
import AvatarImage from '@/components/base/AvatarImage'
import SearchListCardActions from '@/components/search/SearchListCardActions'

// most of the functionality is in the itemActions mixin
import { item, screen } from '@/mixins'

export default {
  name: 'EventSearchListCard',
  props: {
    item: { required: true },
    distanceCenter: {}
  },
  mixins: [item, screen],
  components: { AvatarImage, SearchListCardActions },
  computed: {
    user () {
      return this.item && this.item.user
    },
    event () {
      return this.item && this.item.event
    },
    link () {
      if (this.event) {
        return { name: 'EventPage', params: { id: this.event.id } }
      } else if (this.user) {
        return { name: 'UserPage', params: { id: this.user.id } }
      } else {
        console.log('item is neither a user nor an event')
        return null
      }
    }
  }
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  -webkit-text-fill-color: #000;  // keep for safari
  text-decoration: none;
}

.badge-verified {
  position: absolute;
  left: 10px;
  top: auto;
  right: 10px;
  bottom: -8px;
  display: flex;
  min-height: 19px;
  min-width: 24px;
  justify-content: center;
  align-items: center;
  border-radius: 1000px;
  background-color: #0cba52;
  opacity: 0.92;
}

.badge-text {
  margin-left: 4px;
  color: #fff;
  -webkit-text-fill-color: #fff;  // keep for safari
  font-size: 8px;
  line-height: 12px;
  text-align: center;
  letter-spacing: .5px;
  text-transform: uppercase;
}

.unicode-character {
  color: #fff;
  -webkit-text-fill-color: #fff;  // keep for safari
  font-size: 8px;
  line-height: 12px;
  text-align: center;
  letter-spacing: .5px;
  text-transform: uppercase;
}
.action-button-icon {
  width: 20px;
  height: 20px;
  margin-right: 6px;
  opacity: 1;
}
.gray-bullet-text {
  color: #f1f1f1;
  -webkit-text-fill-color: #f1f1f1
}

.text-block-6 {
  color: #000;
  font-size: 13px;
}

.event-action__icon-button__star {
  &.active {
    background-image: url('../../assets/star_2.svg');
  }
  min-height: 30px;
  min-width: 30px;
  margin-right: 2px;
  padding: 4px;
  border-radius: 50%;
  background-color: transparent;
  background-image: url('../../assets/star-inactive.svg');
  background-position: 50% 50%;
  background-size: 24px 24px;
  background-repeat: no-repeat;
}

.event-action__icon-button__star:hover {
  &.active {
    background-image: url('../../assets/star_2.svg');
  }
  background-color: rgba(0, 0, 0, 0.06);
  background-image: url('../../assets/star-inactive.svg');
  background-position: 50% 50%;
  background-size: 24px 24px;
  background-repeat: no-repeat;
}

.event-action__icon-button__star:active {
  background-color: rgba(0, 0, 0, 0.06);
}

.other-events-card__footer-actions__more-wrapper {
  display: flex;
  min-height: 30px;
  min-width: 30px;
  justify-content: center;
  align-items: center;
}

.event-action-button--selected {
  display: flex;
  padding: 8px 12px;
  justify-content: flex-start;
  align-items: center;
  border-style: solid;
  border-width: 1px;
  border-color: rgba(0, 0, 0, 0.03);
  border-radius: 4px;
  background-color: #f3f3f3;
  color: #0dba52;
}

.event-action-button--selected:hover {
  background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06));
}

.event-action-button--selected:active {
  background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06));
}

.events-list__event-summary-card {
  &:hover {
    background-color: #F8F8F8;
  }
  cursor: pointer;
  position: relative;
  display: flex;
  width: 100%;
  margin-top: 16px;
  margin-bottom: 16px;
  padding: 20px 20px 28px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: stretch;
  border-bottom: 1px solid #f5f5f5;
  border-radius: 8px;
  background-color: #fff;
  box-shadow: 0 4px 20px 0 rgba(0, 0, 0, 0.2);
}

.event-summary-card__title {
  margin-bottom: 8px;
  font-size: 18px;
  line-height: 26px;
  font-weight: 700;
}

.event-summary-card__title.line-clamp--1 {
  margin-bottom: 8px;
}

.event-summary-card__info {
  display: flex;
  margin-bottom: 12px;
  justify-content: space-between;
  align-items: flex-start;
}

.event-summary-card__loca-desc {
  color: grey;
  -webkit-text-fill-color: grey;
  font-weight: 400;
}

.event-summary-card__text {
  width: 100%;
  margin-right: 16px;
}

.event-summary-card__image {
  overflow: hidden;
  width: 80px;
  height: 80px;
  min-height: 80px;
  min-width: 80px;
  margin-top: 4px;
  border-radius: 8px;
}

.event-summary-card__actions {
  display: flex;
  width: auto;
  flex-wrap: wrap;
  align-content: flex-start;
  flex: 0 0 auto;
}

.event-summary-card__actions-avatars {
  display: flex;
  justify-content: flex-start;
  flex-wrap: wrap;
  align-items: center;
}

.place-name {
  font-weight: 700;
}

.header {
  position: relative;
  display: flex;
  width: 100%;
  min-height: 12px;
  margin-bottom: 12px;
  justify-content: space-between;
  align-items: center;
}

.header__date {
  color: #fc6f77;
  -webkit-text-fill-color:#fc6f77;;  // keep for safari
  font-size: 13px;
  line-height: 12px;
  font-weight: 600;
  letter-spacing: .7px;
  text-transform: uppercase;
}

.header__distance {
  color: grey;
  -webkit-text-fill-color: grey;  // keep for safari
  position: static;
  right: 0;
  font-size: 13px;
  line-height: 12px;
  text-transform: uppercase;
}

.description {
  position: relative;
  display: flex;
  margin-bottom: 12px;
  justify-content: space-between;
  align-items: center;
}

.footer {
  position: relative;
  display: flex;
  justify-content: space-between;
  flex-wrap: wrap;
  align-items: flex-end;
}

.footer__user-summary {
  position: relative;
  display: flex;
  align-items: center;
}

.footer__actions {
  position: relative;
  z-index: 2;
  display: flex;
  flex-direction: row;
}

.description-text {
  font-size: 16px;
  line-height: 22px;
}

.photo {
  width: 80px;
  height: 80px;
  min-height: 80px;
  min-width: 80px;
}

.footer__list-item {
  display: flex;
  margin-top: 0;
  margin-right: 8px;
  margin-left: 0;
  align-items: flex-end;
}

.user-info__name {
  color: rgba(0, 0, 0, 0.86);
  -webkit-text-fill-color: rgba(0, 0, 0, 0.86);  // keep for safari
  font-size: 12px;
  line-height: 17px;
  font-weight: 700;
}

.user-info__occupation {
  overflow: hidden;
  width: 360px;
  color: rgba(0, 0, 0, 0.6);
  -webkit-text-fill-color: rgba(0, 0, 0, 0.6);  // keep for safari
  font-size: 12px;
  line-height: 17px;
}

.user-info__kids {
  overflow: hidden;
  width: 360px;
  color: rgba(0, 0, 0, 0.6);
  -webkit-text-fill-color: rgba(0, 0, 0, 0.6);  // keep for safari
  font-size: 12px;
  line-height: 17px;
}

.footer__actions--mobile {
  position: absolute;
  right: -10px;
  display: none;
  align-items: center;
}

.event-action__icon-button__more {
  min-height: 30px;
  min-width: 30px;
  margin-right: 2px;
  padding: 4px;
  border-radius: 50%;
  background-color: transparent;
  background-image: url('../../assets/more.svg');
  background-position: 50% 50%;
  background-size: 24px 24px;
  background-repeat: no-repeat;
}

.event-action__icon-button__more:hover {
  background-color: rgba(0, 0, 0, 0.06);
  background-image: url('../../assets/more.svg');
  background-position: 50% 50%;
  background-size: 24px 24px;
  background-repeat: no-repeat;
}

.event-action__icon-button__more:active {
  background-color: rgba(0, 0, 0, 0.06);
}

.user-info--container {
  display: flex;
  margin-left: 12px;
  flex-direction: row;
  flex-wrap: wrap;
  align-items: center;
}

.user-info_list {
  margin-right: 20px;
  line-height: 20px;
}

.entry__hyperlink {
  position: absolute;
  left: 0%;
  top: 0%;
  right: auto;
  bottom: auto;
  z-index: 0;
  width: 100%;
  height: 100%;
  min-height: 100%;
  min-width: 100%;
  background-color: transparent;
}

.entry__hyperlink:hover {
  background-color: rgba(0, 0, 0, 0.03);
}
.line-clamp--2 {
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.event-action-button {
  margin-right: 8px;
}

@media (max-width: 991px){
  .event-action-button:hover {
    background-image: linear-gradient(180deg, transparent, transparent);
  }

  .event-action-button:active {
    background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.03), rgba(0, 0, 0, 0.03));
  }

  .footer__user-summary {
    min-width: 240px;
  }

  .user-info__occupation {
    width: 480px;
  }

  .user-info__kids {
    width: 480px;
  }

  .entry__hyperlink {
    background-color: transparent;
  }

  .entry__hyperlink:hover {
    background-color: transparent;
  }

  .entry__hyperlink:active {
    background-color: rgba(0, 0, 0, 0.03);
  }

}

@media (max-width: 767px){
  .badge-text {
    margin-left: 0;
  }

  .unicode-character {
    display: none;
  }

  .text-block-6 {
    font-size: 13px;
    line-height: 16px;
  }

  .event-action__icon-button__star {
    min-height: 40px;
    min-width: 40px;
    margin-right: 8px;
  }

  .event-action__icon-button__star:hover {
    background-color: transparent;
  }

  .event-action__icon-button__star:active {
    background-color: rgba(0, 0, 0, 0.06);
  }

  .events-list__event-summary-card {
    padding: 16px 16px 24px;
    border-radius: 0;
  }

  .footer__user-summary {
    min-width: auto;
  }

  .footer__actions {
    display: none;
  }

  .description-text {
    font-size: 13px;
    line-height: 19.5px;
  }

  .user-info__occupation {
    width: 320px;
  }

  .user-info__kids {
    width: 320px;
  }

  .footer__actions--mobile {
    left: auto;
    top: auto;
    right: -12px;
    bottom: -8px;
    z-index: 1;
    display: flex;
    margin-right: 0;
  }

  .event-action__icon-button__more {
    min-height: 40px;
    min-width: 40px;
  }

  .event-action__icon-button__more:hover {
    background-color: transparent;
  }

  .event-action__icon-button__more:active {
    background-color: rgba(0, 0, 0, 0.06);
  }

}

@media (max-width: 479px){
  .badge-verified {
    left: 6px;
    right: 6px;
  }

  .event-action-button--selected {
    width: 100%;
  }

  .footer__actions {
    width: 100%;
  }

  .footer__list-item {
    width: 100%;
    margin-top: 0;
    margin-bottom: 8px;
  }

  .user-info__occupation {
    width: 200px;
  }

  .user-info__kids {
    width: 200px;
  }

}
</style>
