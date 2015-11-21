function showServices() {
  $('#products').addClass('hidden');
  $('#services').removeClass('hidden');
  $('#store').addClass('hidden');
}

function showProducts() {
  $('#services').addClass('hidden');
  $('#products').removeClass('hidden');
  $('#store').addClass('hidden');
}

function showStore() {
  $('#services').addClass('hidden');
  $('#products').addClass('hidden');
  $('#store').removeClass('hidden');
}