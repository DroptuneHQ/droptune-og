// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require jqcloud
//= require_tree .

$(document).on("turbolinks:load", function() {
  // Mobile Menu
  $("#mobile-menu").on("click", function(e) {
    e.preventDefault();
    $("nav").toggleClass("show");
  });
  $(window).resize(function() {
    if ($("body").width() > 910) {
      $("nav").removeClass("show");
    }
  });

  $(".dropdown .current").on("click", function(e) {
    e.preventDefault();
    var target = $(this).attr("data-target");
    $(".dropdown [data-dropdown='" + target + "']").toggleClass("show");
  });

  // Search bar
  $(".search-button").on("click", function(e) {
    e.preventDefault();
    $(".search-form").toggleClass("show");
  });
});

// Follow/unfollow
$(document).on("ajax:success", ".follow a", function(event) {
  const [data, status, xhr] = Array.from(event.detail);
  $(".follow").html(data.artist);
});
