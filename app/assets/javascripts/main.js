function showScreen(screenToShow) {
  var screens = ['products', 'about', 'store', 'library'];

  screenToShow = screenToShow.toLowerCase();

  screens.splice(screens.indexOf(screenToShow), 1);

  $('#' + screenToShow).removeClass('hidden');
  $('#' + screenToShow + '-link').addClass('link-selected');

  for(var i in screens) {
    $('#' + screens[i]).addClass('hidden');
    $('#' + screens[i] + '-link').removeClass('link-selected');
  }
}
