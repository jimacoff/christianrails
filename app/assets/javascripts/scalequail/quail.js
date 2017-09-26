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
