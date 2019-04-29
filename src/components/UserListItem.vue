<template>
  <div class="item-container" @click="goToProfile">
    <div class="avatar-container">
        <AvatarImage
        :person="user"
        className="avatar"/>
    </div>
    <div class="info-container">
      <div class="heading">
        <span class="name">{{ user.firstName }}</span>
        <ChildAges class="children"
                   :childAges="user.childAges"
                   :verbose="false"
                   singular="kid"
                   plural="kids" />
      </div>
      <div class="details">
        <span class="distance">{{distanceFromMapCenter(user.location) + 'mi'}}</span>
        <span class="profession" v-if="user.childAges && user.childAges.length">
          {{profession}}
        </span>
      </div>
    </div>
  <MeetButton :targetUser="user"
              fillStyle="outline"
              layoutStyle="fat"
              @meetButtonClick="registerMeetClick"/>
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
    distanceFromCurrentUser () {
      if (this.currentUser) {
        const location = this.currentUser.location
        return function () {
          return distanceHaversine(location.lat, location.lng, this.mapArea.center.lat, this.mapArea.center.lng)
        }
      } else {
        return ''
      }
    },
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

<style lang="scss" scoped>
.avatar-container {
  min-width: 80px;
  height: 80px;
}
.avatar {
  height: 80px;
  min-width: 80px;
  max-width: 80px;
  margin: 0px 1px 1px 0px;
  border-radius: 50%;
}
.item-container {
  display: flex;
  width: 100%;
  margin-top: 0px;
  padding: 20px;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #f5f5f5;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, .08);
  cursor: pointer;
  &:hover {
    background-color: #00000010;
  }
}
.name {
  font-size: 16px;
  line-height: 20.8px;
  font-weight: 700;
}
.children {
  margin-bottom: -1px;
  margin-left: 8px;
  color: rgba(0, 0, 0, .6);
  font-size: 11px;
  line-height: 20.8px;
  font-weight: 400;
}
.details {
  color: rgba(0, 0, 0, .6);
  font-size: 11px;
  line-height: 20.8px;
  font-weight: 400;
}

.distance {
  font-weight: bold;
}
.info-container {
  margin-right: 16px;
  margin-left: 16px;
  flex-direction: column;
  width: 100%;
}

@media (max-width: 767px){
  .avatar, .avatar-container {
    max-height: 60px;
    max-width: 60px;
    min-height: 60px;
    min-width: 60px;
  }
}

</style>
