<template>
  <li class="other-events__list-item">
    <a @click="$emit('item-click')">
      <div class="other-events-card__header">
        <div class="other-events-card__header__date">{{timeHeader}}</div>
        <div class="other-events-card__header__distance">{{distance}}</div>
      </div>
      <div class="other-events-card__description-text lp-truncate">{{description}}</div>
      <div class="other-events-card__footer">
        <div v-if="event.participatingParents.length" class="other-events-card__footer__attendees">
          <AvatarImage v-for="participant of displayedParticipants"
                       :key="participant.attributes.userId"
                       class="other-events-card__attendees--photo-fit"
                       imageSize="30"
                       :person="{facebookUid: participant.attributes.userFacebookUid, avatar: participant.attributes.userAvatar}"
          />
          <div class="attendees__going-icon"></div>
          <div v-if="undisplayedParticipantsCount" class="other-events-card__attendees--more">{{undisplayedParticipantsCount}} more</div>
        </div>
      </div>
    </a>
  </li>
</template>

<script>
import AvatarImage from '@/components/base/AvatarImage'
import { item } from '@/mixins'
export default {
  name: 'OtherEvent',
  mixins: [item],
  components: { AvatarImage },
  props: { event: { required: true } },
  computed: {
    displayedParticipants () {
      return this.event.participatingParents.slice(0, 3)
    },
    undisplayedParticipantsCount () {
      return this.event.participatingParents.length - this.displayedParticipants.length
    }
  }
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}
.other-events-card__description-text {
  color: black;
}
.other-events__list-item {
  position: relative;
  display: flex;
  width: 100%;
  margin-top: 0;
  padding: 16px 20px 18px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: stretch;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
  list-style-type: none;
}

.other-events-card__header {
  position: relative;
  display: flex;
  min-height: 12px;
  margin-bottom: 8px;
  justify-content: space-between;
  align-items: center;
}

.other-events-card__header__date {
  color: #1f88e9;
  font-size: 12px;
  line-height: 12px;
  text-transform: uppercase;
}

.other-events-card__header__distance {
  position: absolute;
  right: 0;
  color: #64426b;
  font-size: 12px;
  line-height: 12px;
  text-transform: uppercase;
}

.other-events-card__description-text {
  font-size: 13px;
  line-height: 16px;
}

.other-events-card__footer {
  position: relative;
  display: flex;
  margin-top: 8px;
  align-items: center;
}

.other-events-card__footer__attendees {
  position: relative;
  left: 14px;
  display: flex;
  margin-top: 0;
  margin-left: -10px;
  align-items: center;
}

.other-events-card__attendees--more {
  margin-left: 6px;
  color: rgba(0, 0, 0, 0.5);
  font-size: 12px;
  line-height: 14px;
}

.other-events-card__attendees--more:hover {
  text-decoration: underline;
}

.other-events-card__attendees--photo-fit {
  max-height: 30px;
  max-width: 30px;
  min-height: 30px;
  min-width: 30px;
  margin-left: -8px;
  border-style: solid;
  border-width: 2px;
  border-color: #fff;
  border-radius: 50%;
}

.attendees__going-icon {
  position: static;
  left: 59px;
  top: 12px;
  right: auto;
  bottom: auto;
  min-height: 16px;
  min-width: 16px;
  margin-top: 12px;
  margin-left: -9px;
  border-style: none;
  border-width: 1px;
  border-color: rgba(255, 255, 255, 0.25);
  border-radius: 50%;
  background-image: url('../assets/going__green.svg');
  background-position: 0 0;
  background-size: cover;
  opacity: 1;
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

@media (max-width: 991px){
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
  .other-events__list-item {
    padding: 16px 16px 24px;
    border-radius: 0;
  }

  .other-events-card__description-text {
    font-size: 13px;
    line-height: 19.5px;
  }

}
</style>
