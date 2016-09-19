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

  function build(tag,href,text,className,where) {
    var $tag = $('<' + tag + '>');
    $tag.addClass(className)
        .html('<a target="_blank" href="' + href + '">' + text + '</a>')
        .appendTo(where);
  };// end of build function

  function appendTweets(data) {
    if (data && data.local && data.global) {
      data.local.forEach(function(el,index) {
      if (index < 10) {
        build('div',el.url,el.name,'tweet','.tweetset.local .trendlist');
      }
      });
      data.global.forEach(function(el,index) {
        if (index < 10) {
          build('div',el.url,el.name,'tweet','.tweetset.global .trendlist');
        }
      })
    }
  };// end of appendTweets function

  function appendWeather(data) {
    if (data && data.main && data.name) {
      $('.weather').html(Math.round(data.main.temp) + '&#8457;');
      $('.location').html(data.name);
    }
  }// end of appendWeather function

  function appendSound(data) {
    if (data && data.uri && data.song_title && data.scembed) {
      var $sc = $('.soundcloud');
      var $wrapper = $('<div class="title_wrapper">');
      var $div = $('<div class="song_title">');
      var $link = $('<a target="_blank" href="' + data.uri + '">' + data.song_title + '</a>')
      $link.appendTo($div);
      $div.appendTo($wrapper);
      $sc.html(data.scembed)
        .append($wrapper);
    }
  }// end of appendSound function

  function appendArticles(data) {
    if (data) {
      data.forEach(function(el) {
        build('p', el.webUrl, el.webTitle, 'headline', '.headlines');
      })
    }
  };// end of appendArticles function

    // build new li with TODO information
  function appendItem(data) {
    var $items = $(".items");
    var $li = $("<li>");
    var $span = $("<span>");
    var $checkbox = $('<input type="checkbox">');
    if (data.completed) {
      $checkbox.attr('checked', 'true');
      $span.addClass('completed')
    }
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
  };//end of appendItem function

  function appendTodos(data) {
    if (data) {
      data.forEach(appendItem);
    }
  };// end of appendTodos function

  function appendForm(id) {
    $('.edit_user').attr({
      id: 'edit_user_' + id,
      action: '/users/' + id
    });
    $('#todo_user_id').val(id);
  };// end of appendForm function

  function appendName(name) {
    $('.welcome div').text("Welcome, ")
    updateInput(name);
  };// end of appendName function

  function appendPics (pics){
    if (pics.urls && pics.links) {
      $('body').css('background-image', 'url('+ pics.urls.raw + ')');
      $('.unsplash').attr({
        href: pics.links.html
      });
    }
  };

  function appendData(data) {
    if ($('.header')[0]) {
      appendTweets(data.twitter);
      appendArticles(data.articles);
      appendSound(data.sound);
      appendWeather(data.weather);
      appendTodos(data.todos);
      appendName(data.name);
      appendForm(data.id);
    }
    appendPics(data.pics);
  };

  // create a new todo
  function clearFormAfterSubmit(){
    $('#todo_item').val('');
  };

  function submitForm() {
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
    clearFormAfterSubmit();
  };// end of submitForm


  // remove a todo
  function deleteTodo(thing) {
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
  function updateTodo(thing) {
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



  function updateInput(name) {
    var $input = $('#edit_name')
    $input.val(name);
    var $span = $('<span class="temp">');
    $span.text(name).appendTo('body');
    var w = document.querySelector('.temp').getBoundingClientRect().width;
    $span.remove();
    $input[0].style.maxWidth = String(w * 1.1) + 'px';
    $input[0].width = String(w * 1.1) + 'px';
  };

  // add all the event listeners!
  function listenToMe () {
    $(".submit_item").click(submitForm);
    $("#todo_item").keypress(function(e) {
      if (e.which === 13) {
        submitForm();
      }
    });

    // prevent form from actually submitting
    $("#new_todo").submit(function(e){
      e.preventDefault();
    });
    // delete a todo
    $(".delete_todo").click(deleteTodo);
    // update a todo.completed
    $("input[type='checkbox']").change(updateTodo);

    // rotate to show other side of tweetset "card"
    $('.tweets').click(function() {
      $(this).toggleClass('rotate');
    });

    $('.content > div > .top').click(function() {
      if (document.body.getBoundingClientRect().width < 550) {
        if ($(this).parent().hasClass('expand')) {
          $('.expand').removeClass('expand');
        } else {
          $('.expand').removeClass('expand');
          window.setTimeout(function(that) {
            $(that).parent().addClass('expand');
          },10,this)
        }
      } else {
        $(this).parent().toggleClass('expand');
      }
    });

    $('a').click(function(e) {
      e.stopPropagation();
    });

    $('.settings_button').click(function() {
      $('.settings').toggleClass('flipup');
    });

    $('#edit_name').keyup(function(e) {
       var name = $(this).val();
       var user_id = $('#todo_user_id').val();
       var that = this;
       if (e.which === 13) {
         $.ajax({
           'method' : 'PATCH',
           'url' : '/users/' + user_id,
           'data' : {id: user_id, fname: name}
         }).done(function() {
            that.blur();
         });
       } else if ((e.which >= 48 && e.which <= 57) || (e.which >= 65 && e.which <= 90) || e.which === 8) {
         updateInput(name);
       }
     });

    $('.footer .logo').click(function(event) {
        $('.soc').toggleClass('showSoc');
    });
  }

  //TODO NEED TO PASS USER ID FROM CLIENT INSTEAD OF VIA SERVER
  // But it works for now!!!
  $.getJSON('/startup').done(function(data) {
    appendData(data);
    listenToMe();
  });

}); // end of $(document).ready


