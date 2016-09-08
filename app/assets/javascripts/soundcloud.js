

(function(){
    var widgetIframe = document.getElementById('sc-widget'),
        widget       = SC.Widget(widgetIframe),
        newSoundUrl = 'http://api.soundcloud.com/tracks/13692671';

    widget.bind(SC.Widget.Events.READY, function() {
      // load new widget
      widget.bind(SC.Widget.Events.FINISH, function() {
        widget.load(newSoundUrl, {
          show_artwork: false
        });
      });
    });
}());
