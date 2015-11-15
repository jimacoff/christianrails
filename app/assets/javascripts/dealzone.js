var cart = {}

function showDealzone() { $('#dealzone').fadeIn();  }
function hideDealzone() { $('#dealzone').fadeOut(); }
function possiblyHideDealzone() { if(Object.keys(cart).length === 0) { hideDealzone(); } }
function showAddToCartButton(product_id) { $('#add_to_cart_' + product_id).prop("disabled", false); }
function hideAddToCartButton(product_id) { $('#add_to_cart_' + product_id).prop("disabled", true); }

function writeProductInfoToDealzone(product_id) {
  $("<p id=\"dealzone_title_" + product_id + "\">" + $('#'+ product_id + "_title").html() + "</p>").insertBefore($('#check_out'));
  $("<p id=\"dealzone_price_" + product_id + "\">" + $('#'+ product_id + "_price").html() + "</p>").insertBefore($('#check_out'));
  $("<button id=\"dealzone_remove_" + product_id + "\" class=\"store-button\" onclick=\"removeFromCart(" + product_id + ")\">Remove</button>").insertBefore($('#check_out'));
}

function eraseProductInfoFromDealzone(product_id) {
  $("#dealzone_title_"  + product_id).remove();
  $("#dealzone_price_"  + product_id).remove();
  $("#dealzone_remove_" + product_id).remove();
}

function addToCart(product_id) {
  showDealzone();
  hideAddToCartButton(product_id);
  writeProductInfoToDealzone(product_id);
  createStagedPurchase(product_id);
  updatePrices();
}

function removeFromCart(product_id) {
  showAddToCartButton(product_id);
  eraseProductInfoFromDealzone(product_id);
  removeStagedPurchase(product_id);
  updatePrices();
}

function updatePrices() {
  //update the dealzone price
  var dealzoneSum = $("[id^='dealzone_price_']"),
      total = 0;

  dealzoneSum.each(function( i ) {
    total += Number(this.innerHTML.replace(/[^0-9\.]+/g,""));
  });

  $('#total_price').text("$" + total.toFixed(2));

  //update prices on the main panel

  //TODO hide selected prices


  //TODO update price_combo prices


}

function createStagedPurchase(product_id) {
  request = void 0;
  request = $.ajax({
      type: 'POST',
      url: '/staged_purchases.json',
      dataType: 'json',
      data: { 'staged_purchase': { 'product_id' : product_id } } 
    });

  request.done(function(data, textStatus, jqXHR) {
    cart[data['product_id']] = data['id'];
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log(textStatus);
  });
}

function removeStagedPurchase(product_id) {
  request = void 0;
  request = $.ajax({
      type: 'DELETE',
      url: '/staged_purchases/' + cart[product_id] + '.json',
      dataType: 'json'
    });

  request.done(function(data, textStatus, jqXHR) {
    delete cart[data['product_id']];
    possiblyHideDealzone();
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log(textStatus);
  });
}