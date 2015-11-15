cart = {}

function showDealzone() { $('#dealzone').fadeIn();  }
function hideDealzone() { $('#dealzone').fadeOut(); }
function showAddToCartButton(product_id) { $('#add_to_cart_' + product_id).fadeIn(); }
function hideAddToCartButton(product_id) { $('#add_to_cart_' + product_id).fadeOut(); }

function addToCart(product_id) {
  addProductToDealzone(product_id);
  updatePrices();
}

function addProductToDealzone(product_id) {
  showDealzone();
  hideAddToCartButton(product_id);
  writeProductInfoToDealzone(product_id);
  createStagedPurchase(product_id);
}

function removeProductFromDealzone(product_id) {
  showAddToCartButton(product_id);
  eraseProductInfoFromDealzone(product_id);
  removeStagedPurchase(product_id);
}

function possiblyHideDealzone() {
  if(Object.keys(cart).length === 0) {
    hideDealzone();
  }
}

function writeProductInfoToDealzone(product_id) {
  $("<p id=\"" + product_id + "_name\">" + product_id + "</p>").insertBefore($('#check_out'));
  $("<button id=\"" + product_id + "_remove\" onclick=\"removeProductFromDealzone(" + product_id + ")\">Remove</button>").insertBefore($('#check_out'));
}

function eraseProductInfoFromDealzone(product_id) {
  $("#" + product_id + "_name").remove();
  $("#" + product_id + "_remove").remove();
}

function updatePrices() {

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