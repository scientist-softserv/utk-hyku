$(document).on('turbolinks:load', function() {
  $('.js-per-page__submit').hide();
  $('.js-per-page__select').on('change', function() {
    $(this).parents('.js-per-page').submit();
  });
});
