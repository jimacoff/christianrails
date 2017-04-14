// JS for store

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

function goToSignUp() {
  window.location = "/users/sign_up";
}
