<template>
  <div class="lo-navigation__actions">
    <router-link :to="{name: 'SignUp'}"
                 class="lo-navigation__button w-inline-block">
      <div class="lo-navigation__button-label">Sign up</div>
    </router-link>
    <ul class="lo-navigation__links-list w-list-unstyled">
      <li class="lo-navigation__link-item">
        <router-link :to="{name: 'SignIn'}"
                     class="lo-navigation__button-secondary w-inline-block">
          <div class="lo-navigation__button-label">Log in</div>
        </router-link>
      </li>
      <li class="lo-navigation__link-item faq">
        <router-link :to="{name:'Faq'}"
                     class="lo-navigation__button-secondary w-inline-block">
          <div class="lo-navigation__button-label">FAQ</div>
        </router-link>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'LoggedOutNav'
}
</script>

<style scoped lang="scss">
a {
  color: #000;
  text-decoration: none;
}

.lo-navigation__links-list {
  display: flex;
  margin-right: 0;
  margin-bottom: 0;
  margin-left: 0;
  padding-right: 0;
  padding-left: 0;
  align-items: center;
}

.lo-navigation__link-item {
  margin-right: 8px;
}

.lo-navigation__button {
  display: flex;
  margin-right: 16px;
  padding: 10px 12px;
  align-items: center;
  border-radius: 4px;
  background-color: #fd6f77;
  color: #fff;
}

.lo-navigation__button:hover {
  background-color: #fd6f77;
  background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06));
}

.lo-navigation__button-label {
  margin-left: 0;
  font-size: 13px;
  text-align: center;
  letter-spacing: .5px;
  text-transform: uppercase;
}

.lo-navigation__button-secondary {
  display: flex;
  padding: 10px 12px;
  align-items: center;
  border-radius: 4px;
}

.lo-navigation__button-secondary:hover {
  background-color: rgba(0, 0, 0, 0.06);
}

.lo-navigation__actions {
  display: flex;
  width: 100%;
  margin-right: -8px;
  justify-content: flex-end;
}

@media (max-width: 991px){
  .lo-navigation__button:hover {
    background-color: #fd6f77;
    background-image: linear-gradient(180deg, transparent, transparent);
  }

  .lo-navigation__button:active {
    background-color: #fd6f77;
    background-image: linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06)), linear-gradient(180deg, rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.06));
  }

  .lo-navigation__button-secondary:hover {
    background-color: transparent;
  }

  .lo-navigation__button-secondary:active {
    background-color: rgba(0, 0, 0, 0.06);
  }

}

@media (max-width: 767px){
  .lo-navigation__actions {
    padding-top:12px;
    padding-bottom:12px;
  }
}

@media (max-width: 479px){

  .lo-navigation__link-item {
    margin-right: 4px;
  }

  .lo-navigation__button {
    margin-right: 8px;
    padding-right: 8px;
    padding-left: 8px;
  }

  .lo-navigation__button-label {
    margin-top: 0;
    margin-left: 0;
    font-size: 12px;
    line-height: 10px;
    text-align: center;
  }

  .lo-navigation__button-secondary {
    padding-right: 6px;
    padding-left: 6px;
    flex-direction: column;
    border-radius: 0;
  }

}
@media (max-width: 320px){
  .faq {
    display: none
  }
}
</style>
