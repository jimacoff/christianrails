function showDealzone() { $('#dealzone').fadeIn();  }
function hideDealzone() { $('#dealzone').fadeOut(); }
function showAddToCartButton(product_id) { $('#add_to_cart_' + product_id).fadeIn(); }
function hideAddToCartButton(product_id) { $('#add_to_cart_' + product_id).fadeOut(); }

function addToCart(product_id) {
  addProductToDealzone(product_id);
  updatePrices();
  console.log("Product id#" + product_id + " added to cart!")
}


function addProductToDealzone(product_id) {
  showDealzone();
  hideAddToCartButton(product_id);
  $("<p>" + product_id + "</p>").insertBefore($('#check_out'));
}

function updatePrices() {

}