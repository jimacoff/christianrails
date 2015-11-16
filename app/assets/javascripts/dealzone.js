var cart = {}

function showDealzone() { $('#dealzone').fadeIn();  }
function hideDealzone() { $('#dealzone').fadeOut(); }
function possiblyHideDealzone() { if(Object.keys(cart).length === 0) { hideDealzone(); } }
function showAddToCartButton(product_id) { $('#add_to_cart_' + product_id).prop("disabled", false); $('#add_to_cart_' + product_id).text("Add to basket") }
function hideAddToCartButton(product_id) { $('#add_to_cart_' + product_id).prop("disabled", true); $('#add_to_cart_' + product_id).text("Added to basket")}
function showPriceOfProduct(product_id)  { $("#" + product_id + "_price").fadeIn();  }
function hidePriceOfProduct(product_id)  { $("#" + product_id + "_price").fadeOut(); }

function writeProductInfoToDealzone(product_id) {
  $("#dealzone_item_"  + product_id).fadeIn();
  $("#dealzone_item_"  + product_id).addClass('totalable');
}

function eraseProductInfoFromDealzone(product_id) {
  $("#dealzone_item_"  + product_id).fadeOut();
  $("#dealzone_item_"  + product_id).removeClass('totalable');
}

function addToCart(product_id) {
  showDealzone();
  hideAddToCartButton(product_id);
  hidePriceOfProduct(product_id);
  writeProductInfoToDealzone(product_id);
  createStagedPurchase(product_id);
  updatePrices();
}

function removeFromCart(product_id) {
  showAddToCartButton(product_id);
  showPriceOfProduct(product_id);
  eraseProductInfoFromDealzone(product_id);
  removeStagedPurchase(product_id);
  updatePrices();
}

function updatePrices() {
  //update the dealzone price
  var dealzoneSum = $("[id^='dealzone_price_']"),
      total = 0;

  dealzoneSum.each(function( i ) {
    if($($(this).parents()[4]).hasClass("totalable")){
      total += Number(this.innerHTML.replace(/[^0-9\.]+/g,""));
    }
  });

  $('#total_price').text("Total: $" + total.toFixed(2));

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