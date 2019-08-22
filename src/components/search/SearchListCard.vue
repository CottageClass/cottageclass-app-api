<template>
<li class="events-list__event-summary-card"
    @click.stop="goToItem">
  <div class="header">
    <div class="header__date"
         :class="{'time-past': timePast,
                  'childcare-request': item && item.childcareRequest}" >
      {{timeHeader}}
    </div>
    <div v-if="distance && !isCurrentUser" class="header__distance">{{distance}}</div>
  </div>
  <div class="description">
    <div class="description-text line-clamp--2">{{description}}</div>
  </div>
  <div class="footer">
    <div class="footer__user-summary">
      <div class="photo-wrapper">
        <AvatarImage
          className="photo"
          :person="user"
          imageSize="85"
          />
        <div class="badge-verified" v-if="user.facebookUid">
          <div class="unicode-character">✓</div>
          <div class="badge-text">Verified</div>
        </div>
      </div>
      <div class="user-info--container">
        <div class="user-info_list">
          <div class="user-info__name">{{userName}}</div>
          <div v-if="occupation"
               class="user-info__occupation lp-truncate">
            {{occupation}}<br />
          </div>
          <div class="user-info__kids lp-truncate">{{kidsAges}}</div>
          <div v-if="neighborhood" class="user-info__kids lp-truncate">{{neighborhood}}</div>
          <HouseholdImages :user="user" />
        </div>
      </div>
    </div>
    <div class="footer__actions--mobile">
      <a  v-if="!childcareRequest"
          class="event-action__icon-button__star w-inline-block"
          :class="isStarred?'active':''"
          @click.stop="interestedClick"></a>
      <div class="other-events-card__footer-actions__more-wrapper">
        <a class="event-action__icon-button__more w-inline-block"
           @click.stop="overlayOpen=true"></a>
      </div>
    </div>
    <SearchListCardActions
                    v-if="!isPhone"
                    :user="item.user"
                    :event="item.event"
                    :childcareRequest="item.childcareRequest"
                    @user-updated="$emit('user-updated', $event)"
                    @event-updated="$emit('event-updated', $event)"
                    @event-deleted="$emit('event-deleted', id)"
                    @going-click="goingClick"
                    @cancel-click="cancelClick"
                    @interested-click="interestedClick"
                    @share-click="shareClick"
                    @contact-click="contactClick"
                    :timePast="timePast"
                    :showGoingButton="showGoingButton"
                    :showMeetButton="showMeetButton"
                    :showShareButton="showShareButton"
                    :showInterestedButton="showInterestedButton"
                    :showContactButton="showContactButton"
                    :showCancelButton="showCancelButton"
                    :allowWaveUndo="true"/>
    <SearchListCardActionsOverlay
                    v-if="showOverlay"
                    :user="item.user"
                    :event="item.event"
                    :childcareRequest="item.childcareRequest"
                    @user-updated="$emit('user-updated', $event)"
                    @event-updated="$emit('event-updated', $event)"
                    @event-deleted="$emit('event-deleted', id)"
                    @clickaway="overlayOpen=false"
                    @going-click="goingClick"
                    @cancel-click="cancelClick"
                    @interested-click="interestedClick"
                    @share-click="shareClick"
                    @contact-click="contactClick"
                    :showGoingButton="showGoingButton"
                    :showMeetButton="showMeetButton"
                    :showShareButton="showShareButton"
                    :showContactButton="showContactButton"
                    :showInterestedButton="showInterestedButton"
                    :showCancelButton="showCancelButton"
                    :allowWaveUndo="true"/>
  </div>
</li>
</template>

<script>
import AvatarImage from '@/components/base/AvatarImage'
import HouseholdImages from '@/components/search/HouseholdImages'
import SearchListCardActions from '@/components/search/SearchListCardActions'
import SearchListCardActionsOverlay from '@/components/search/SearchListCardActionsOverlay'

// most of the functionality is in the itemActions mixin
import { item, screen } from '@/mixins'

export default {
  name: 'SearchListCard',
  props: {
    item: { required: true },
    mapCenter: {}
  },
  mixins: [item, screen],
  components: { AvatarImage, HouseholdImages, SearchListCardActions, SearchListCardActionsOverlay },
  computed: {
    user () {
      return this.item && this.item.user
    },
    event () {
      return this.item && this.item.event
    },
    childcareRequest () {
      return this.item && this.item.childcareRequest
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
  margin-top: 0;
  padding: 20px 20px 28px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: stretch;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
}

.header {
  position: relative;
  display: flex;
  min-height: 12px;
  margin-bottom: 12px;
  justify-content: space-between;
  align-items: center;
}

.header__date {
  &.time-past {
    -webkit-text-fill-color: #aaaaaa;  // keep for safari
    color: #aaaaaa;
  }
  &.childcare-request {
    -webkit-text-fill-color: #FD6F77;  // keep for safari
    color: #FD6F77;
  }
  color: #1f88e9;
  -webkit-text-fill-color: #1f88e9;  // keep for safari
  font-size: 12px;
  line-height: 12px;
  text-transform: uppercase;
}

.header__distance {
  position: absolute;
  right: 0;
  color: #64426b;
  -webkit-text-fill-color: #64426b;  // keep for safari
  font-size: 12px;
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

.photo-wrapper {
  position: relative;
  height: 100%;
}

.photo {
  position: static;
  max-height: 85px;
  max-width: 85px;
  min-height: 85px;
  min-width: 85px;
  margin: 0 1px 1px 0;
  border-radius: 4px;
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

@media (max-width: 991px){
  .event-action-button:hover {
    background-image: linear-gradient(180deg, transparent, transparent);
  }

  .event-action-button:active {
    background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.03), rgba(0, 0, 0, 0.03));
  }

  .event-action-button--selected:hover {
    background-image: linear-gradient(180deg, transparent, transparent);
  }

  .event-action-button--selected:active {
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
    margin-right: 0;
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

  .photo {
    max-height: 75px;
    max-width: 75px;
    min-height: 75px;
    min-width: 75px;
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

  .event-action-button {
    width: 100%;
  }

  .event-action-button--selected {
    width: 100%;
  }

  .footer__actions {
    width: 100%;
  }

  .photo-wrapper {
    max-height: 77px;
  }

  .photo {
    max-height: 65px;
    max-width: 65px;
    min-height: 65px;
    min-width: 65px;
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
