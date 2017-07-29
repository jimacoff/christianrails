var cart = {}

function goToSignUp() { window.location = "/users/sign_up"; }
function showCartWidget() { $('#cartwidget').fadeIn().css("display","inline-block");  $('#checkout').fadeIn(); }
function hideCartWidget() { $('#cartwidget').fadeOut(); $('#checkout').fadeOut(); }
function possiblyHideCartWidget() { if(Object.keys(cart).length === 0) { hideCartWidget(); } }
function enableAddToCartButton(product_id)  { $('.add_to_cart_' + product_id).prop("disabled", false); $('.add_to_cart_' + product_id).text("Add to cart"); }
function disableAddToCartButton(product_id) { $('.add_to_cart_' + product_id).prop("disabled", true);  $('.add_to_cart_' + product_id).text("Added to cart"); }
function showPriceOfProduct(product_id)  { $("." + product_id + "_price").fadeIn();  $("." + product_id + "_new_price").fadeIn(); }
function hidePriceOfProduct(product_id)  { $("." + product_id + "_price").fadeOut(); $("." + product_id + "_new_price").fadeOut(); }
function showProductInCartWidget(product_id) { $(".cartwidget_item_"  + product_id).fadeIn().css("display","inline-block").addClass('totalable'); }
function hideProductInCartWidget(product_id) { $(".cartwidget_item_"  + product_id).fadeOut().removeClass('totalable'); }

function addToCart(product_id) {
  showCartWidget();
  disableAddToCartButton(product_id);
  //hidePriceOfProduct(product_id);
  showProductInCartWidget(product_id);
  createStagedPurchase(product_id);
}

function removeFromCart(product_id) {
  enableAddToCartButton(product_id);
  //showPriceOfProduct(product_id);
  hideProductInCartWidget(product_id);
  removeStagedPurchase(product_id);
}

function updatePrices() {
  request = void 0;
  request = $.ajax({
      type: 'GET',
      url: '/store/dealzone/updated_prices.json',
      dataType: 'json'
    });

  request.done(function(data, textStatus, jqXHR) {
    drawNewPrices(data);
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log(textStatus);
  });
}

function updateUserbarCartLink() {
  if( Object.keys(cart).length > 0 ) {
    $('.cart-link-highlight').text("Cart (" + Object.keys(cart).length + ")");
    $('.cart-dot').show();
  } else {
    $('.cart-link-highlight').text("");
    $('.cart-dot').hide();
  }
}

function drawNewPrices(price_data) {
  // the discount
  if(price_data.total_discount !== 0) {
    $('.discount_price').html("$" + price_data.total_discount.toFixed(2));
  } else {
    $('.discount_price').html('');
  }

  // the checkout total
  var cartWidgetItems = $("[class^='cartwidget_price_']"),
      total = 0;

  cartWidgetItems.each(function( i ) {
    if($($(this).parents()[1]).hasClass("totalable")){
      total += Number(this.innerHTML.replace(/[^0-9\.]+/g,""));
    }
  });

  if(price_data.total_discount > 0) {
    total -= price_data.total_discount;
    $('.total_price').addClass('discount');
    $('.discount_label').html('Save:');
  } else {
    $('.total_price').removeClass('discount');
    $('.discount_label').html('');
  }

  $('.total_price').text("$" + total.toFixed(2));

  // update the satisfiable discounts
  $.each(price_data, function(k, v) {
    if(k !== 'discount_price'){
      if( v[1] > 0 ) {
        $('.' + k + '_price').addClass('strikethrough');
        $('.' + k + '_new_price').html( '$' + (v[0]-v[1]).toFixed(2) );
      } else {
        $('.' + k + '_price').removeClass('strikethrough');
        $('.' + k + '_new_price').html('');
      }
    }
  });
}

function createStagedPurchase(product_id) {
  request = void 0;
  request = $.ajax({
      type: 'POST',
      url: '/store/staged_purchases.json',
      dataType: 'json',
      data: { 'staged_purchase': { 'product_id' : product_id } }
    });

  request.done(function(data, textStatus, jqXHR) {
    cart[data['product_id']] = data['id'];
    updatePrices();
    updateUserbarCartLink();
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log(textStatus);
  });
}

function removeStagedPurchase(product_id) {
  request = void 0;
  request = $.ajax({
      type: 'DELETE',
      url: '/store/staged_purchases/' + cart[product_id] + '.json',
      dataType: 'json'
    });

  request.done(function(data, textStatus, jqXHR) {
    delete cart[data['product_id']];
    possiblyHideCartWidget();
    updatePrices();
    updateUserbarCartLink();
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    console.log(textStatus);
  });
}

function doCheckout() {
  request = void 0;
  request = $.ajax({
      type: 'POST',
      url: '/store/dealzone/check_out'
    });
  $('#check_out_button').addClass('hidden');
  $('#cartwidget-pricedetails').addClass('pricedetails-processing');
  $('#processing').removeClass('hidden');

  request.done(function(data, textStatus, jqXHR) {
    console.log("Checking out.");
  });

  request.error(function(jqXHR, textStatus, errorThrown) {
    $('#check_out_button').addClass('hidden');
    $('#cartwidget-pricedetails').removeClass('pricedetails-processing');
    $('#processing').removeClass('hidden');
    console.log("Error occured: " + textStatus);
  });

}
