<template>
<li class="attendee__list-item">
  <router-link
    :to="{name: 'UserPage', params: {id: user.userId}}"
    class="attendee__link-wrapper w-inline-block">
     <AvatarImage className="attendee__photo"
                   :person="{facebookUid: user.userFacebookUid, avatar: user.userAvatar}"
                   imageSize="100"/>
    <img :src="goingIcon" width="24" height="24" alt="" class="attendees__going-icon-medium" />
    <div class="attendee__user-name truncate">{{ firstName }}</div>
  </router-link>
</li>
</template>

<script>
import { capitalize } from '@/utils/utils'
import AvatarImage from '@/components/base/AvatarImage'
import goingIcon from '@/assets/going__green.svg'

export default {
  name: 'Attendee',
  components: { AvatarImage },
  props: { user: { required: true } },
  computed: {
    goingIcon: () => goingIcon,
    firstName: function () { return capitalize(this.user.userFirstName) }
  }
}
</script>

<style scoped lang="scss">
.attendee__list-item {
  position: relative;
  display: flex;
  width: 63px;
  margin: 8px 8px 16px;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  list-style-type: none;
}

.attendee__photo {
  width: 60px;
  height: 60px;
  border-radius: 50%;
}

.attendee__photo.photo-fit {
  width: 60px;
  height: 60px;
}

.attendee__user-name {
  overflow: hidden;
  width: 52px;
  margin-top: 12px;
  color: rgba(0, 0, 0, 0.86);
  font-size: 12px;
  line-height: 17px;
  font-weight: 400;
  text-align: center;
}

.attendee__user-name:hover {
  text-decoration: underline;
}

.attendees__going-icon-medium {
  position: absolute;
  left: auto;
  top: 47px;
  right: auto;
  bottom: auto;
}

.attendee__link-wrapper {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  transition: all 140ms ease;
  text-decoration: none;
  color: #000;
  &:hover {
    transform: scale(1.1);
  }
}

@media (max-width: 991px){
  .attendee__link-wrapper:hover {
    transform: none;
  }

}

@media (max-width: 767px){
  .attendee__link-wrapper {
    margin-bottom: 0;
  }

}
</style>
