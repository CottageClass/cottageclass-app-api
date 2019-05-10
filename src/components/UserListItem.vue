<template>
  <div class="user-summary-card">
    <div class="photo-wrapper">
      <AvatarImage
        :person="user"
        className="photo-fit"/>
      <div class="badge-verified" v-if="user.facebookUid">
        <div class="unicode-character">✓</div>
        <div class="badge-text">Verified</div>
      </div>
    </div>

    <div class="user-info-wrapper">
      <div class="username truncatable">{{user.firstName}}</div>
      <div class="occupation truncatable">{{profession}}</div>
      <ChildAges class="number-of-kids truncatable"
                 :childAgesInMonths="user.childAgesInMonths"
                 :verbose="false"
                 singular="kid"
                 plural="kids" />
    </div>
    <div class="action-content">
      <div class="distance">{{distanceFromMapCenter(user.location) + 'mi'}}</div>
      <MeetButton :targetUser="user"
                  fillStyle="outline"
                  layoutStyle="fat"
                  @meetButtonClick="registerMeetClick"/>
    </div>
  </div>
</template>

<script>
import AvatarImage from '@/components/base/AvatarImage'
import MeetButton from '@/components/base/MeetButton'
import ChildAges from '@/components/ChildAges'
import { distanceHaversine } from '@/utils/api'
import { mapGetters } from 'vuex'
import _ from 'lodash'

export default {
  name: 'UserListItem',
  data () {
    return {
      isSelected: false,
      inviteComplete: false,
      sendingTimeout: null,
      lastMeetButtonClick: null
    }
  },
  props: ['user'],
  components: { AvatarImage, MeetButton, ChildAges },
  methods: {
    registerMeetClick (e) {
      this.lastMeetButtonClick = e
    },
    goToProfile (e) {
      if (!this.lastMeetButtonClick ||
          Math.abs(this.lastMeetButtonClick.event.timeStamp - e.timeStamp) > 0.001) {
        this.$router.push({ name: 'ProviderProfile', params: { id: this.user.id } })
      }
    }
  },
  computed: {
    distanceFromMapCenter () {
      return function (location) {
        return distanceHaversine(location.lat, location.lng, this.mapArea.center.lat, this.mapArea.center.lng)
      }
    },
    profession () {
      const list = []
      if (this.user.jobPosition) {
        list.push(_.capitalize(this.user.jobPosition))
      }
      if (this.user.employer) {
        list.push(_.capitalize(this.user.employer))
      }
      return list.join(', ')
    },
    ...mapGetters([ 'currentUser', 'mapArea' ])
  }
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}

.user-summary-card {
  display: flex;
  width: 100%;
  margin-top: 0;
  padding: 20px 20px 28px;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.08);
}

.photo-fit {
  position: static;
  max-height: 80px;
  max-width: 80px;
  min-height: 80px;
  min-width: 80px;
  margin: 0 1px 1px 0;
  border-radius: 50%;
}

.username {
  margin-bottom: 4px;
  font-size: 16px;
  line-height: 20.8px;
  font-weight: 700;
}

.number-of-kids {
  color: rgba(0, 0, 0, 0.6);
  font-size: 12px;
  line-height: 17px;
  font-weight: 400;
}

.occupation {
  display: block;
  margin-bottom: 2px;
  color: rgba(0, 0, 0, 0.6);
  font-size: 12px;
  line-height: 17px;
  font-weight: 400;
}

.truncatable {
  flex: 1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.btn-meet {
  padding: 4px 10px 5px;
  border: 1px solid #1f88e9;
  border-radius: 4px;
  background-color: transparent;
  color: #1f88e9;
  font-size: 13px;
}

.btn-meet:active {
  background-image: linear-gradient(180deg, rgba(31, 136, 233, 1), rgba(31, 136, 233, 1));
  color: rgba(255, 255, 255, 1);
}

.user-info-wrapper {
  display: flex;
  width: 100%;
  margin-right: 16px;
  margin-left: 16px;
  flex-direction: column;
  align-items: flex-start;
}

.distance {
  margin-bottom: 6px;
  font-size: 12px;
  font-weight: 700;
  text-align: center;
}

.photo-wrapper {
  position: relative;
}

.badge-verified {
  position: absolute;
  left: 0%;
  top: auto;
  right: 0%;
  bottom: -10px;
  display: flex;
  min-height: 24px;
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
  font-size: 10px;
  line-height: 12px;
  text-align: center;
  letter-spacing: .5px;
  text-transform: uppercase;
}

.unicode-character {
  color: #fff;
  font-size: 10px;
  line-height: 12px;
  text-align: center;
  letter-spacing: .5px;
  text-transform: uppercase;
}

@media (max-width: 767px){
  .user-summary-card {
    padding: 16px 16px 24px;
    border-radius: 0;
  }

  .photo-fit {
    max-height: 60px;
    max-width: 60px;
    min-height: 60px;
    min-width: 60px;
  }

  .username {
    width: 240px;
    margin-bottom: 1px;
  }

  .badge-text {
    margin-left: 0;
  }

  .unicode-character {
    display: none;
  }

}

@media (max-width: 479px){
  .username {
    width: 138px;
  }

  .number-of-kids {
    width: 138px;
    display: block;
  }

  .occupation {
    width: 138px;
  }
}
</style>
