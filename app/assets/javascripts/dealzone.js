var cart = {}

function showDealzone() { $('#dealzone').fadeIn();  }
function hideDealzone() { $('#dealzone').fadeOut(); }
function possiblyHideDealzone() { if(Object.keys(cart).length === 0) { hideDealzone(); } }
function enableAddToCartButton(product_id)  { $('#add_to_cart_' + product_id).prop("disabled", false); $('#add_to_cart_' + product_id).text("Add to basket"); }
function disableAddToCartButton(product_id) { $('#add_to_cart_' + product_id).prop("disabled", true);  $('#add_to_cart_' + product_id).text("Added to basket"); }
function showPriceOfProduct(product_id)  { $("#" + product_id + "_price").fadeIn();  $("#" + product_id + "_new_price").fadeIn(); }
function hidePriceOfProduct(product_id)  { $("#" + product_id + "_price").fadeOut(); $("#" + product_id + "_new_price").fadeOut(); }
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
  request = void 0;
  request = $.ajax({
      type: 'GET',
      url: '/store/updated_prices.json',
      dataType: 'json'
    });

  request.done(function(data, textStatus, jqXHR) {
    drawNewPrices(data);
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log(textStatus);
  });
}

function drawNewPrices(price_data) {
  // the discount
  if(price_data.total_discount !== 0) {
    $('#discount_price').html("$" + price_data.total_discount.toFixed(2));
  } else {
    $('#discount_price').html('');
  }

  // the checkout total
  var dealzoneItems = $("[id^='dealzone_price_']"),
      total = 0;

  dealzoneItems.each(function( i ) {
    if($($(this).parents()[4]).hasClass("totalable")){
      total += Number(this.innerHTML.replace(/[^0-9\.]+/g,""));
    }
  });

  if(price_data.total_discount > 0) {
    total -= price_data.total_discount;
    $('#total_price').addClass('discount');
    $('#discount_label').html('Save:');
  } else {
    $('#total_price').removeClass('discount');
    $('#discount_label').html('');
  }
  
  $('#total_price').text("$" + total.toFixed(2));

  // update the satisfiable discounts
  $.each(price_data, function(k, v) {
    if(k !== 'discount_price'){
      if( v[1] > 0 ) {
        $('#' + k + '_price').addClass('strikethrough');
        $('#' + k + '_new_price').html( '$' + (v[0]-v[1]).toFixed(2) );
      } else {
        $('#' + k + '_price').removeClass('strikethrough');
        $('#' + k + '_new_price').html('');
      }
    }
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