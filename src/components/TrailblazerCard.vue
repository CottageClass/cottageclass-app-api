<template>
  <div class="card-playdates-promo">
    <img src="@/assets/invite.svg" alt="" class="card-photo">
    <div class="card-title">Get more childcare! Invite your friends to share care.</div>
    <div class="card-subtitle">
      Kidsclub.io works best when you invite your friends to share childcare. The more friends
      who join, the more free childcare you get!
      </div>
    <router-link :to="{name: 'SocialInvite'}" class="button-primary w-button">Invite your friends</router-link>
    <div class="card-divider"></div>
    <div class="card-subtitle">
      <strong>No friends? No problem!</strong> Share us with your local online parent groups.
    </div>
    <div class="copy-area">
      <input type="text" class="copy-link w-input" :placeholder="linkText" readonly>
      <button class="copy-button"
              v-clipboard:copy="linkText"
              v-clipboard:success="onCopy">
        {{ copyButtonText }}
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'TrailblazerCard',
  data () {
    return {
      copyButtonText: 'Copy Link'
    }
  },
  computed: {
    linkText: () => 'https://www.kidsclub.io'
  },
  methods: {
    onCopy () {
      this.copyButtonText = 'Copied!'
    }
  }

}
</script>

<style scope lang="scss">

.card-playdates-promo {
  display: flex;
  width: 100%;
  margin-bottom: 16px;
  padding: 32px;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  border-radius: 4px;
  background-color: #fff;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, .08);
}
.card-photo {
  margin-right: 16px;
  margin-bottom: 24px;
}
.card-title {
  margin-bottom: 8px;
  font-size: 17px;
  font-weight: 700;
  text-align: center;
}
.card-subtitle {
  margin-bottom: 16px;
  color: #7d7d7d;
  font-size: 13px;
  line-height: 20px;
  font-weight: 400;
  text-align: center;
}
.card-divider {
  display: block;
  width: 100%;
  height: 1px;
  margin-top: 32px;
  margin-bottom: 32px;
  background-color: rgba(0, 0, 0, .2);
}
.button-primary {
  margin-right: 4px;
  padding: 12px 32px;
  align-self: auto;
  border: 1px solid hsla(208, 82.11%, 51.76%, 1.00);
  border-radius: 4px;
  background-color: #1f88e9;
  text-align: center;
  &:hover {
    border-color: #1b7bd1;
    background-color: #1b7bd1;
    text-decoration: none;
  }
  &:active {
    background-color: #1b7bd1;
  }
}
.copy-area {
  display: flex;
  flex-direction: row;
  width:100%;
}
.copy-link {
  width: 100%;
  height: 50px;
  margin-bottom: 0px;
  padding-top: 6px;
  border-style: solid;
  border-width: 1px;
  border-color: #d9d9d9;
  border-radius: 4px 0px 0px 4px;
  background-color: rgba(0, 0, 0, .04);
  font-size: 16px;
  font-weight: 400;
  &:focus {
   background-color: hsla(0, 0%, 100%, .04);
  }
}

.copy-button {
  white-space: nowrap;
  min-width: 90px;
  padding: 9px 15px;
  border-style: solid;
  border-width: 1px;
  border-color: rgba(0, 0, 0, .15);
  border-radius: 0px 4px 4px 0px;
  background-color: #fff;
  color: hsla(208.8118811881188, 82.11%, 51.76%, 1.00);
  &:hover {
    background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .1)), to(rgba(0, 0, 0, .1)));
    background-image: linear-gradient(180deg, rgba(0, 0, 0, .1), rgba(0, 0, 0, .1));
    text-decoration: none;
  }
}

@media (max-width: 991px) {
  .card-photo {
    margin-right: 16px;
  }
}

@media (max-width: 767px) {
  .card-playdates-promo {
    padding: 24px;
    border-radius: 0px;
  }
  .card-photo {
    margin-right: 0px;
    margin-bottom: 16px;
  }
  .button-primary {
    display: block;
    align-self: center;
    flex: 0 auto;
  }
  .copy-area {
    flex-direction: column;
    width: 100%;
  }
  .copy-button {
    border-radius: 0px 0px 4px 4px;
    border-top: none;
  }
  .copy-link {
      border-radius: 4px 4px 0px 0px;
  }

}
@media (max-width: 479px) {
  .card-photo {
    margin-right: 0px;
    margin-bottom: 16px;
  }
  .button-primary {
    width: 100%;
  }
  .copy-link {
    -webkit-box-orient: vertical;
    -webkit-box-direction: normal;
    -webkit-flex-direction: column;
    -ms-flex-direction: column;
    flex-direction: column;
  }
  .copy-button {
    width: 100%;
    padding: 16px;
    border-top-right-radius: 0px;
    border-bottom-left-radius: 4px;
  }
}
</style>
