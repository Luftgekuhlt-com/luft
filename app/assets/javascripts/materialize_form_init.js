window.materializeForm = {
  init: function() {
    this.initSelect();
    this.initCheckbox();
    this.initDate();
  },
  initSelect: function() {
    $('select[multiple="multiple"] option[value=""]').attr('disabled', true);
    $('select').formSelect();
  },
  initCheckbox: function() {
    $('input[type=checkbox]').addClass('filled-in')
  },
  initDate: function() {
    $('.datepicker, .date').datepicker({autoClose: true});
  }
}

$(document).ready(function() {
  window.materializeForm.init()
});

$(document).ajaxSuccess(function() {
  //window.materializeForm.init()
});
