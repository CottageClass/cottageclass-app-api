<template>
  <div class="div-block-22">
    <AvatarImage
      :person="sender"
      :imageSize="48"
      class="home-item--photo photo-fit" />
    <div class="div-block-23">
      <div class="comment--username">
        {{ userName }}
        <span class="comment--timestamp">{{ timestamp }}</span>
      </div>
      <div class="comment--comment-text">{{ comment.content }}</div>
    </div>
  </div>
</template>

<script>
import moment from 'moment'
import AvatarImage from '@/components/base/AvatarImage'

export default {
  name: 'UserGroupComment',
  components: { AvatarImage },
  props: {
    comment: {
      required: true,
      type: Object
    }
  },
  computed: {
    timestamp () {
      const formatString = 'DDDDYYYY'
      const time = moment(this.comment.createdAt)
      const now = moment().format(formatString)
      const yesterday = moment().subtract(1, 'days').format(formatString)

      if (time.format(formatString) === now) {
        return `Today at ${time.format('h:mm A')}`
      }
      if (time.format(formatString) === yesterday) {
        return `Yesterday at ${time.format('h:mm A')}`
      }

      return time.format('MMM D, h:mm A')
    },
    sender () {
      return this.comment.sender
    },
    userName () {
      return `${this.sender.firstName} ${this.sender.lastInitial}.`
    }
  }
}
</script>

<style scoped lang="scss">
.home-item--photo {
  width: 48px;
  height: 48px;
  min-height: 48px;
  min-width: 48px;
  border-radius: 8px;
}

.home-item--photo.photo-fit {
  width: 48px;
  height: 48px;
  min-height: 48px;
  min-width: 48px;
}

.div-block-22 {
  display: flex;
  margin-bottom: 12px;
  align-items: flex-start;
}

.div-block-23 {
  width: 100%;
  margin-top: 3px;
  margin-left: 16px;
}

.comment--username {
  font-size: 14px;
  font-weight: 600;
}

.comment--timestamp {
  color: #b3b3b3;
  font-size: 12px;
  line-height: 16px;
  font-weight: 400;
}

@media (max-width: 767px){
  .home-item--photo {
    width: 36px;
    height: 36px;
    min-height: 36px;
    min-width: 36px;
  }

  .home-item--photo.photo-fit {
    width: 36px;
    height: 36px;
    min-height: 36px;
    min-width: 36px;
  }

  .div-block-23 {
    margin-top: -3px;
  }

}
</style>
