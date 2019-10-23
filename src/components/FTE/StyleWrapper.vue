<template>
  <span :class="[styleIs]">
    <slot></slot>
  </span>
</template>

<script>
export default {
  name: 'StyleWrapper',
  props: ['styleIs']
}
</script>

<style lang="scss">

.content-wrapper__request{
  position: relative;
  left: 0%;
  top: 40px;
  right: 0%;
  bottom: auto;
  z-index: 1000;
  display: flex;
  width: 876px;
  min-height: 500px;
  margin: 0 auto 100px;
  flex-direction: column;
  border-radius: 4px;
  background-color: #fff;
  box-shadow: 1px 1px 35px 0 rgba(0, 0, 0, 0.2);
}

.body__request{
background-color: #f6f6f6;
}

.onb-error-text a.error-link {
  color: #c96168;
  text-decoration: underline;
}

.onb-checkbox {
  margin-top: 22px !important;
  padding-top: 0px;
  padding-bottom: 0px;
}
.modal-style {
  .question-title {
  margin-top: 0;
  margin-bottom: 10px;
  color: #333;
  font-size: 24px;
  line-height: 34px;
  text-align: center;
  letter-spacing: -.3px;
  }

  .onb-paragraph-subheading-2 {
  margin-bottom: 8px;
  color: #333;
  font-size: 13px;
  line-height: 21px;
  text-align: center;
  }

  .content-container {
  margin-bottom: 0;
  padding: 32px;
  color: #fff;
  }

  .title-container {
  margin-bottom: 0;
  color: #fff;
  }

  .text-area-decribe-need {
    height: 200px;
  }

  @media (max-width: 991px) {
    .content-wrapper__request {
        width: auto;
        margin-right: 32px;
        margin-left: 32px;
    }
    .content-wrapper {
        width: auto;
        margin-right: 32px;
        margin-left: 32px;
    }

    .title-bar {
      width: auto;
    }
  }

  @media (max-width: 767px) {
    .content-wrapper__request {
    position: relative;
    top: 0;
    width: auto;
    margin-right: 0px;
    margin-left: 0px;
    border-radius: 0px;
    box-shadow: none;
    }
    .content-wrapper {
      margin-top: 28px;
    }
  }

  @media (max-width: 479px) {
    .title-bar {
      -webkit-box-align: center;
      -webkit-align-items: center;
      -ms-flex-align: center;
      align-items: center;
    }

    .content-container {
      overflow: visible;
    }
  }
}

.editing {

  .avatar-upload-button {
    background-color: white;
  }

  body {
    font-family: soleil;
    color: #333;
    font-size: 14px;
    line-height: 20px;
  }
  w-form {
    margin-left: 0;
    margin-right: 0;
  }
  .describe-label {
    color: #3333338f;
  }

  .image-7 {
    display: none;
  }

  .onb-button-add-group {
    padding-bottom: 16px;
  }

  a {
    color: hsla(208.8118811881188, 82.11%, 51.76%, 1.00);
    text-decoration: none;
  }

  .page-actions-wrapper a {
    color: white;
  }

  a:hover {
    text-decoration: underline;
  }

  .body {
    background-color: #f5f5f5;
  }

  .heading-1 {
    margin-bottom: 32px;
  }

  .card, .content-container, .onb-content-container, .onb-content-container-2 {
    display: -webkit-box;
    display: -webkit-flex;
    display: -ms-flexbox;
    display: flex;
    flex-wrap: wrap;
    width: 100%;
    margin-top: 16px;
    padding: 0 32px 40px 32px;
    -webkit-box-orient: vertical;
    -webkit-box-direction: normal;
    -webkit-flex-direction: column;
    -ms-flex-direction: column;
    flex-direction: row;
    -webkit-box-pack: start;
    -webkit-justify-content: flex-start;
    -ms-flex-pack: start;
    justify-content: flex-start;
    -webkit-box-align: start;
    -webkit-align-items: flex-start;
    -ms-flex-align: start;
    align-items: flex-start;
    border-radius: 4px;
    background-color: #fff;
    box-shadow: 0 1px 2px 0 rgba(0, 0, 0, .08);
  }

  /* TODO: Make all these one style in the components themselves! */

  .onb-child-info-container {
    width: 100%;
  }

  .onb-child-group-2 {
    width: 100%;
  }

  .question-title {
    font-size: 17px;
  }

  .card-title, .title, .onb-heading-large, .onb-child-group-heading {
    margin-bottom: 8px;
    font-size: 17px;
    font-weight: 700;
    line-height: 24px;
  }

  .w-input {
    width: 100%
  }

  .location-search-container {
    width: 100%;
  }

  .onb-error-text {
    color: #ff7575;
    margin-top: 16px;
  }
  .card-subtitle {
    margin-bottom: 16px;
    color: #7d7d7d;
    font-size: 13px;
    line-height: 20px;
    font-weight: 400;
  }

  .radio-form-block, .w-form {
    width: 100%;
  }

  .radio-form, .w-form {
    margin-top: 8px;
  }

  .radio-button-field, .checkbox-field-extra-space {
    margin-bottom: 8px;
    padding-left: 35px;
    border-radius: 4px;
    background-color: rgba(0, 0, 0, .04);
  }

  .radio-button-field, .checkbox-field-extra-space:active {
    background-color: rgba(0, 0, 0, .08);
  }

  .radio-button {
    margin-top: 22px;
  }

  .radio-button-label, .onb-checkbox-label {
    width: 100%;
    padding-top: 18px;
    padding-bottom: 18px;
    padding-left: 6px;
    color: #000;
    font-weight: 400;
  }

  .text-field-label {
    margin-bottom: 8px;
  }

  .form {
    display: -webkit-box;
    display: -webkit-flex;
    display: -ms-flexbox;
    display: flex;
  }

  .select-field {
    width: 70px;
    height: 50px;
    border: 1px solid transparent;
    background-color: #fff;
    background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .06)), to(rgba(0, 0, 0, .06)));
    background-image: linear-gradient(180deg, rgba(0, 0, 0, .06), rgba(0, 0, 0, .06));
    font-size: 16px;
  }

  .dropdown-group {
    display: -webkit-box;
    display: -webkit-flex;
    display: -ms-flexbox;
    display: flex;
    -webkit-box-orient: vertical;
    -webkit-box-direction: normal;
    -webkit-flex-direction: column;
    -ms-flex-direction: column;
    flex-direction: column;
    -webkit-box-align: start;
    -webkit-align-items: flex-start;
    -ms-flex-align: start;
    align-items: flex-start;
  }

  .text-field, .w-input {
    width: 100%;
    padding-top: 6px;
    border: 1px solid transparent;
    border-radius: 4px;
    background-color: rgba(0, 0, 0, .04);
    font-size: 16px;
    font-weight: 400;
  }

  .text-field:focus {
    background-color: hsla(0, 0%, 100%, .04);
  }

  .textarea {
    width: 100%;
    min-height: 100px;
    border: 1px solid transparent;
    border-radius: 4px;
    background-color: rgba(0, 0, 0, .04);
    font-size: 16px;
  }

  .textarea:focus {
    border-color: #1f88e9;
    background-color: hsla(0, 0%, 100%, .04);
  }

  .dropdown {
    height: 50px;
    margin-right: 12px;
    border: 1px solid transparent;
    background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, .06)), to(rgba(0, 0, 0, .06)));
    background-image: linear-gradient(180deg, rgba(0, 0, 0, .06), rgba(0, 0, 0, .06));
    font-size: 16px;
  }

  .form-block {
    width: 100%;
  }

  .form-block-2 {
    display: block;
    width: 100%;
  }

  .form-3 {
    width: 100%;
  }

  .button-primary {
    margin-right: 4px;
    padding: 12px 32px;
    -webkit-align-self: auto;
    -ms-flex-item-align: auto;
    -ms-grid-row-align: auto;
    align-self: auto;
    border-style: solid;
    border-width: 1px;
    border-color: hsla(208.8118811881188, 82.11%, 51.76%, 1.00);
    border-radius: 4px;
    background-color: #1f88e9;
    text-align: center;
  }

  .button-primary:hover {
    border-color: #1b7bd1;
    background-color: #1b7bd1;
    text-decoration: none;
  }

  .button-secondary-small {
    padding: 8px 24px;
    border-style: solid;
    border-width: 1px;
    border-color: hsla(208.8118811881188, 82.11%, 51.76%, 1.00);
    border-radius: 4px;
    background-color: hsla(208.8118811881188, 0.00%, 100.00%, 1.00);
    color: hsla(208.8118811881188, 82.11%, 51.76%, 1.00);
    text-align: center;
  }

  .button-secondary-small:hover {
    border-color: #1b7bd1;
    background-color: #e6e6e6;
    text-decoration: none;
  }

  .page-actions-wrapper {
    display: -webkit-box;
    display: -webkit-flex;
    display: -ms-flexbox;
    display: flex;
    margin-top: 16px;
    -webkit-box-pack: center;
    -webkit-justify-content: center;
    -ms-flex-pack: center;
    justify-content: center;
    -webkit-box-align: center;
    -webkit-align-items: center;
    -ms-flex-align: center;
    align-items: center;
  }

  .text-block {
    color: #ff7575;
  }

  .jasons-link {
    border: 1px none #000;
    text-decoration: underline;
  }

  .placeholder-box {
    display: -webkit-box;
    display: -webkit-flex;
    display: -ms-flexbox;
    display: flex;
    height: 100px;
    -webkit-box-pack: center;
    -webkit-justify-content: center;
    -ms-flex-pack: center;
    justify-content: center;
    -webkit-box-align: center;
    -webkit-align-items: center;
    -ms-flex-align: center;
    align-items: center;
    background-color: #f1f1f1;
  }

  .photo {
    width: 120px;
    height: 120px;
    margin-right: 16px;
    border: 0px solid #000;
    border-radius: 50%;
  }

  .profile-photo-container {
    display: -webkit-box;
    display: -webkit-flex;
    display: -ms-flexbox;
    display: flex;
    width: 100%;
    margin-bottom: 16px;
    -webkit-box-align: center;
    -webkit-align-items: center;
    -ms-flex-align: center;
    align-items: center;
  }

  .emoji {
    width: 150px;
  }

  @media (max-width: 991px) {
    .body {
      padding-bottom: 77px;
    }
    .button-primary {
      height: auto;
    }
    .button-primary:hover {
      border-color: #1f88e9;
      background-color: #1f88e9;
    }
    .button-primary:active {
      background-color: #1b7bd1;
    }
    .button-secondary-small:hover {
      background-color: #fff;
    }
    .button-secondary-small:active {
      background-color: #e6e6e6;
    }
    .page-actions-wrapper {
      position: fixed;
      left: 0%;
      top: auto;
      right: 0%;
      bottom: 0%;
      padding: 16px;
      background-color: #fff;
      box-shadow: 0 -1px 2px 0 rgba(0, 0, 0, .08);
    }
    .photo {
      margin-right: 16px;
    }
    .modal-header {
      padding-right: 72px;
      padding-left: 72px;
    }
    .modal-p {
      width: 100%;
    }
    .modal-unordered-list {
      width: 100%;
    }
    .modal-intro-text {
      width: 100%;
    }
    .emoji {
      width: 100px;
    }
  }

  @media (max-width: 767px) {
    .body {
      padding-bottom: 50px;
    }
    .onb-error-text {
        margin-right: 24px;
      margin-left: 24px;
  }
    .heading-1 {
      margin-right: 24px;
      margin-left: 24px;
    }
    .card {
      padding: 24px;
      border-radius: 0px;
    }
    .button-primary {
      display: block;
      padding-top: 6px;
      padding-bottom: 7px;
      -webkit-align-self: center;
      -ms-flex-item-align: center;
      -ms-grid-row-align: center;
      align-self: center;
      -webkit-box-flex: 0;
      -webkit-flex: 0 auto;
      -ms-flex: 0 auto;
      flex: 0 auto;
    }
    .button-secondary-small {
      padding-top: 6px;
      padding-bottom: 7px;
    }
    .page-actions-wrapper {
      width: auto;
      min-width: 0px;
      padding-top: 8px;
      padding-bottom: 8px;
      -webkit-box-orient: horizontal;
      -webkit-box-direction: normal;
      -webkit-flex-direction: row;
      -ms-flex-direction: row;
      flex-direction: row;
      -webkit-box-pack: center;
      -webkit-justify-content: center;
      -ms-flex-pack: center;
      justify-content: center;
      -webkit-box-align: center;
      -webkit-align-items: center;
      -ms-flex-align: center;
      align-items: center;
    }
    .modal-container {
      padding: 16px;
    }
    .modal-header {
      padding-right: 64px;
      padding-left: 64px;
    }
    .modal-content {
      padding-right: 24px;
      padding-left: 24px;
    }
    .modal-close-button {
      width: 32px;
      height: 32px;
      margin-top: 17px;
      margin-left: 16px;
    }
    .modal-footer {
      padding-right: 24px;
      padding-left: 24px;
    }
  }

  @media (max-width: 479px) {
    .heading-1 {
      font-size: 34px;
      line-height: 44px;
    }
    .button-primary {
      width: 100%;
    }
    .photo {
      margin-right: 0px;
      margin-bottom: 16px;
    }
    .profile-photo-container {
      width: 100%;
      -webkit-box-orient: vertical;
      -webkit-box-direction: normal;
      -webkit-flex-direction: column;
      -ms-flex-direction: column;
      flex-direction: column;
      -webkit-box-pack: center;
      -webkit-justify-content: center;
      -ms-flex-pack: center;
      justify-content: center;
      -webkit-flex-wrap: wrap;
      -ms-flex-wrap: wrap;
      flex-wrap: wrap;
    }
    .modal-container {
      padding: 16px;
    }
    .modal-header {
      padding-right: 56px;
      padding-left: 56px;
    }
    .modal-title {
      text-align: center;
    }
    .modal-footer {
      padding-bottom: 16px;
      border-top: 1px solid rgba(0, 0, 0, .04);
    }
    .modal-unordered-list {
      list-style-type: disc;
      -webkit-column-span: none;
      column-span: none;
    }
  }

  .dropdown-container {
    text-align: center;
    font-size: 24px;
    padding: 0 0 16px 0;
  }

}

</style>
