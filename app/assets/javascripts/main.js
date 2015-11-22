function showServices() {
  $('#products').addClass('hidden');
  $('#services').removeClass('hidden');
  $('#store').addClass('hidden');

  $('#store-link').removeClass('link-selected')
  $('#explore-link').removeClass('link-selected')
  $('#services-link').addClass('link-selected')
}

function showProducts() {
  $('#services').addClass('hidden');
  $('#products').removeClass('hidden');
  $('#store').addClass('hidden');

  $('#store-link').removeClass('link-selected')
  $('#explore-link').addClass('link-selected')
  $('#services-link').removeClass('link-selected')
}

function showStore() {
  $('#services').addClass('hidden');
  $('#products').addClass('hidden');
  $('#store').removeClass('hidden');

  $('#store-link').addClass('link-selected')
  $('#explore-link').removeClass('link-selected')
  $('#services-link').removeClass('link-selected')
}