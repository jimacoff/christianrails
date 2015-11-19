var cart = {}

function showDealzone() { $('#dealzone').fadeIn();  }
function hideDealzone() { $('#dealzone').fadeOut(); }
function possiblyHideDealzone() { if(Object.keys(cart).length === 0) { hideDealzone(); } }
function enableAddToCartButton(product_id)  { $('#add_to_cart_' + product_id).prop("disabled", false); $('#add_to_cart_' + product_id).text("Add to basket"); }
function disableAddToCartButton(product_id) { $('#add_to_cart_' + product_id).prop("disabled", true);  $('#add_to_cart_' + product_id).text("Added to basket"); }
function showPriceOfProduct(product_id)  { $("#" + product_id + "_price").fadeIn();  }
function hidePriceOfProduct(product_id)  { $("#" + product_id + "_price").fadeOut(); }
function showProductInDealzone(product_id) { $("#dealzone_item_"  + product_id).fadeIn().addClass('totalable'); }
function hideProductInDealzone(product_id) { $("#dealzone_item_"  + product_id).fadeOut().removeClass('totalable'); }

function addToCart(product_id) {
  showDealzone();
  disableAddToCartButton(product_id);
  hidePriceOfProduct(product_id);
  showProductInDealzone(product_id);
  createStagedPurchase(product_id);
}

function removeFromCart(product_id) {
  enableAddToCartButton(product_id);
  showPriceOfProduct(product_id);
  hideProductInDealzone(product_id);
  removeStagedPurchase(product_id);
}

function updatePrices() {

  // maybe do all this down in the callback
  var dealzoneSum = $("[id^='dealzone_price_']"),
      total = 0;

  dealzoneSum.each(function( i ) {
    if($($(this).parents()[4]).hasClass("totalable")){
      total += Number(this.innerHTML.replace(/[^0-9\.]+/g,""));
    }
  });

  $('#total_price').text("Total: $" + total.toFixed(2));

  //TODO update price_combo prices
  request = void 0;
  request = $.ajax({
      type: 'GET',
      url: '/store/updated_prices.json',
      dataType: 'json'
    });

  request.done(function(data, textStatus, jqXHR) {
    // TODO
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    // TODO
    console.log(textStatus);
  });

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
    updatePrices();
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
    updatePrices();
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log(textStatus);
  });
}