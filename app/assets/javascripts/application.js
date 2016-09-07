// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .


$(function(){
  $("form").submit(function(e){
    e.preventDefault();

    var action = $(this).attr('action');
    var method = $(this).attr('method');

    var item = $(this).find('#todo_item').val();
    // var data = $(this).serializeArray();

      $.ajax({
      "method" : "method",
      "url" : "action",
      "data" : "data",
      "datatype" : "json"
    });
  });
});

// POTENTIAL SAMPLE AJAX CALL
// function createTodo() {
//   e.preventDefault();

//   data = {
//     "item" : $(whatever).val(),
//     "completed" : $(whatever).val(),
//     "user_id" : $(whatever).val()
//   }

//   $.ajax({
//     "method" : "POST",
//     "url"    : "APP_URL/todos/create",
//     "data"   : data,
//     "datatype" : "json"
//   }).always(function() {
//     $(div).append()
//   })
// }

