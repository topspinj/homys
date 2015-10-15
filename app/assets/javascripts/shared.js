$(document).on('ready page:load', function() {
  $("#modal-1").on("change", function() {

    if ($(this).is(":checked")) {
      $("body").addClass("modal-open");
    } else {
      console.log('removeclass modal-open');
      $("body").removeClass("modal-open");
    }
  });

  $(".modal-fade-screen, .modal-close").on("click", function() {
    $(".modal-state:checked").prop("checked", false).change();
  });

  $(".modal-inner").on("click", function(e) {
    e.stopPropagation();
  });

  $(".modal form").on('ajax:success', function(){
    $(".modal-state:checked").prop("checked", false).change();
  });

});