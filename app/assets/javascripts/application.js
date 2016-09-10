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


// TODO move this into a users.js file
// (if we add other features loaded out of this order)
$(document).ready(function() {

  var build = function(tag,href,text,className,where) {
    var $tag = $('<' + tag + '>');
    $tag.addClass(className)
        .html('<a target="_blank" href="' + href + '">' + text + '</a>')
        .appendTo(where);
  }

  function appendTweets(data) {
    data.local.forEach(function(el,index) {
      if (index < 10) {
        build('div',el.url,el.name,'tweet','.tweetset.local');
      }
    });
    data.global.forEach(function(el,index) {
      if (index < 10) {
        build('div',el.url,el.name,'tweet','.tweetset.global');
      }
    })
  }

  function appendWeather(data) {
    $('.weather').html(Math.round(data.main.temp) + '&#8457;');
    $('.location').html(data.name);
  }

  function appendSound(data) {
    var $sc = $('.soundcloud');
    var $div = $('<div class="song_title">');
    $div.text(data.song_title)
    $sc.html(data.scembed)
      .append($div);
  }

  function appendArticles(data) {
    data.forEach(function(el) {
      build('p', el.webUrl, el.webTitle, 'headline', '.headlines')
    })
  }

  // rotate to show other side of tweetset "card"
  $('.tweets').click(function() {
    $(this).toggleClass('rotate');
  });

  $('.content > div > .top').click(function() {
    $(this).parent().toggleClass('expand');
  });

  $('a').click(function(e) {
    e.stopPropagation();
  });

  // create a new todo
  var clearFormAfterSubmit = function(){
    $('#todo_item').val('');
  };

  $(".submit_item").click(function() {
    submitForm();
    clearFormAfterSubmit();
  });
  // prevent form from actually submitting
  $("#new_todo").submit(function(e){
    e.preventDefault();
  });
  // delete a todo
  $(".delete_todo").click(function() {
    deleteTodo(this);
  });
  // update a todo.completed
  $("input[type='checkbox']").change(function() {
    updateTodo(this);
  });

  var submitForm = function(){
    // data sent via AJAX
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



  // build new li with TODO information
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
    // sets id as item_1, item_10, item_100, for data retrieval later
    $li.attr('id','item_' + data.id)
    $li.append($checkbox).append($span).append($button).addClass('todo');
    $items.append($li);
    $button.click(function() {
      deleteTodo(this);
    });
  };//end of appendItem

  // remove a todo
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

  // update current status of todo via checkbox's checked
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
    });
  }; // end of updateTodo


  function appendTodos(data) {
    data.forEach(appendItem);
  };
  //TODO NEED TO PASS USER ID FROM CLIENT INSTEAD OF VIA SERVER
  // But it works for now!!!
  $.getJSON('/tweets').done(appendTweets);
  $.getJSON('/articles').done(appendArticles);
  $.getJSON('/todos').done(appendTodos);
  $.getJSON('/sound').done(appendSound);
  $.getJSON('/weather').done(appendWeather);

}); // end of $(document).ready
