<template>
  <div>
    <MainNav />
    <div class="error-page-content-container w-container">
      <div class="error-page-image-container">
        <img src="@/assets/oops.png"
             srcset="@/assets/oops-p-500.png 500w,
                     @/assets/oops-p-800.png 800w,
                     @/assets/oops.png 1842w"
             sizes="(max-width: 479px) 230px, (max-width: 767px) 400px, 500px"
             alt=""
             class="error-page-main-image" />
      </div>
      <div class="error-page-content">
        <h1 class="h3-center-black">{{ titleText }}</h1>
        <div class="error-page-subheading-container">
          <div class="body1-center-black"
               v-html="bodyText" />
        </div>
      </div>
    </div>
    <Footer />
  </div>
</template>

<script>
import MainNav from '@/components/MainNav'
import Footer from '@/components/Footer.vue'
export default {
  name: 'ErrorPage',
  components: { MainNav, Footer },
  props: { status: {} },
  computed: {
    titleText () {
      return 'Page not found'
    },
    bodyText () {
      return `<p>Sorry, the page you're looking for does not exist.</p>
      <p>Try back later or send us an email at <a href="mailto:contact@joinlilypad.com">contact@joinlilypad.com</a> if you think you got this page in error.</p>`
    }
  }
}
</script>

<style scoped lang="scss">
h1 {
  margin-top: 0;
  margin-bottom: 3.48rem;
  color: rgba(0, 0, 0, 0.86);
  font-size: 3.48rem;
  line-height: 4.176rem;
  font-weight: 700;
  letter-spacing: -.03rem;
}

.error-page-content {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.body1-center-black {
  color: #212121;
  text-align: center;
  letter-spacing: 0;
}

.link-2 {
  color: #1f88e9;
}

.error-page-content-container {
  display: flex;
  margin-top: 0;
  margin-bottom: 0;
  padding: 72px 32px;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  color: rgba(255, 255, 255, 0.86);
}

.error-page-main-image {
  width: 100%;
  padding-bottom: 1.97rem;
}

.h3-center-black {
  margin-bottom: 1.97rem;
  color: #212121;
  font-size: 1.97rem;
  line-height: 2.37rem;
  text-align: center;
  letter-spacing: 0;
}

.error-page-image-container {
  width: 500px;
}

@media (max-width: 991px){
  .error-page-subheading-container {
    padding-bottom: 40px;
  }

  .error-page-content-container {
    padding-top: 112px;
    padding-bottom: 112px;
  }

  .error-page-main-image {
    padding-bottom: 1.57rem;
  }

  .h3-center-black {
    margin-bottom: 1.57rem;
    font-size: 1.57rem;
    line-height: 1.89rem;
  }

}

@media (max-width: 767px){
  .body1-center-black {
    font-size: .89rem;
    line-height: 1.34rem;
  }

  .error-page-subheading-container {
    padding-bottom: 24px;
  }

  .error-page-content-container {
    padding-top: 112px;
    padding-right: 20px;
    padding-left: 20px;
  }

  .error-page-main-image {
    padding-bottom: 1.4rem;
  }

  .h3-center-black {
    margin-bottom: 1.4rem;
    font-size: 1.4rem;
    line-height: 1.69rem;
  }

  .error-page-image-container {
    width: 400px;
  }

}

@media (max-width: 479px){
  .error-page-content {
    width: 90%;
  }

  .error-page-content-container {
    padding-top: 64px;
    padding-bottom: 64px;
  }

  .error-page-image-container {
    width: 230px;
  }

}
</style>
