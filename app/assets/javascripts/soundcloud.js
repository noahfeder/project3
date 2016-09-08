var iframeElement   = document.querySelector('soundcloud');
var iframeElementID = iframeElement.id;
var widget1         = SC.Widget(iframeElement);
var widget2         = SC.Widget(iframeElementID);

SC.stream('/tracks/293').then(function(player){
  player.play();
});
