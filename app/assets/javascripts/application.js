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

$(document).ready(function() {

  console.log("ready!");

  $('.tweets').on('click',function() {
    $(this).toggleClass('rotate');
  })

  $(".submit_item").click(function() {
    submitForm();
  });

  $("#new_todo").submit(function(e){
    e.preventDefault();
  });

  $(".delete_todo").click(function() {
    deleteTodo(this);
  })

  $("input[type='checkbox']").on('change',function() {
    updateTodo(this);
  })

  var submitForm = function(){
    var dataToSend = {
      "user_id" : $("#todo_user_id").val(),
      "item" : $('#todo_item').val(),
      "completed" : 0
    };

      $.ajax({
      "method" : "POST",
      "url" : "/todos",
      "data" : dataToSend,
      "datatype" : "json"
    }).always(function(data){
      appendItem(data);
    });
  };// end of submitForm

  var appendItem = function(data) {
    var $items = $(".items");
    var $li = $("<li>");
    var $span = $("<span>");
    var $checkbox = $('<input type="checkbox">');
    $checkbox.on('change', function() {
      updateTodo(this);
    })
    var $button = $('<button class="delete_todo">X</button>');
    $span.text(data.item);
    $li.attr('id','item_' + data.id)
    $li.append($checkbox).append($span).append($button).addClass('todo');
    $items.append($li);
  };//end of appendItem

  var deleteTodo = function(thing) {
    var parent = $(thing).parent()[0];
    var id = parent.id.split('_')[1];
    $.ajax({
      "method" : "delete",
      "url" : "/todos/" + id,
      "datatype" : "json"
    }).done(function(data) {
      parent.remove();
    });
  }; // end of deleteTodo

  var updateTodo = function(thing) {
    var completed = thing.checked;
    var parent = thing.parentElement;
    var id = parent.id.split('_')[1];
    var dataToSend = {
      completed: completed,
      id: id
    };
    $.ajax({
      "method" : "PATCH",
      "url" : "/todos/" + id,
      "datatype" : "json",
      "data" : dataToSend
    }).done(function(data) {
      $(parent).children('span').toggleClass('completed');
    })
  };
});
