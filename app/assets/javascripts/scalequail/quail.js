// pops a notification that the post is coming soon.
// takes the link it was clicked on.
function comingSoon( clicked ) {
  popWidth = $('.scaling-in-progress').width();
  popOffset = 190;
  $('.scaling-in-progress').css("margin-top",   (clicked[0].offsetTop - popOffset) + 'px');
  $('.scaling-in-progress').css("margin-left",  (window.innerWidth - popWidth) / 2 + 'px');
  $('.scaling-in-progress').css("margin-right", (window.innerWidth - popWidth) / 2 + 'px');
  $('.scaling-in-progress').fadeIn();
  window.setTimeout(function(){
    hideComingSoonBox();
  }, 2500);
}

function hideComingSoonBox() {
  $('.scaling-in-progress').fadeOut();
}

// modified from https://codepen.io/roborich/pen/wpAsm
var background_image_parallax = function($object){
  var multiplier = 1.5;
  multiplier = 1 - multiplier;
  var $doc = $(document);
  $object.css({"background-attatchment" : "fixed"});

  $(window).scroll(function(){
    var from_top = $doc.scrollTop(),
        bg_css = '-200px ' + ((multiplier * from_top) + 200) + 'px';
    $object.css({"background-position" : bg_css });
  });
};
