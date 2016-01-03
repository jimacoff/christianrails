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

function togglePhysical(product_id) {

  if( $('#physical_order_' + product_id ).hasClass('hidden')) {
    $('#physical_order_'   + product_id ).removeClass('hidden');
    $('#digital_download_' + product_id ).addClass('hidden');
    $('#toggle_physical_'  + product_id ).html('Download a digital copy');
    $('#toggle_physical_'  + product_id ).removeClass('physical-button');
    $('#toggle_physical_'  + product_id ).addClass('digital-button');
  } else {
    $('#physical_order_'   + product_id ).addClass('hidden');
    $('#digital_download_' + product_id ).removeClass('hidden');
    $('#toggle_physical_'  + product_id ).html('Order a physical copy');
    $('#toggle_physical_'  + product_id ).addClass('physical-button');
    $('#toggle_physical_'  + product_id ).removeClass('digital-button');
  }

}
