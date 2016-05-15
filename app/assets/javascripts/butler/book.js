function initializeBook(product) {
  // set book to first page
  if( product.pages ) {
    setPage(product, product.currentPage);
    updateControls(product);
    precacheBookImages(product);
  }
};

$(document).on("click", '#left-control', function(event) {
  product = findProductByCode(getHashOfWindow());
  prevPage(product);
});
$(document).on("click", '#right-control', function(event) {
  product = findProductByCode(getHashOfWindow());
  nextPage(product);
});

function setPage(product, page) {
  var code = product.code;

  //TODO possibly quick fade out/in
  $("#comic").attr("src", "img-" + code + "/" + code + "-" + page + ".jpg");
  $("#comic").attr("height", product.pageH + "px");
  $("#comic").attr("width", product.pageW + "px");
};

function nextPage(product) {
  if( !product.pages ) {
    return false;
  } else {
    if (product.currentPage == product.pages - 1) {
      // return to start of book
      product.currentPage == 0;
    } else {
      // actally increment page
      product.currentPage++;
    }
    setPage(product, product.currentPage);
    updateControls(product);
  }
  return true;
};

function prevPage(product) {
  if( !product.pages ) {
    return false;
  } else {
    if (product.currentPage == 0) {
      // return to start of book
      product.currentPage == 0;
    } else {
      // actally decrement page
      product.currentPage--;
    }
    setPage(product, product.currentPage);
    updateControls(product);
  }
  return true;
};

function updateControls(product) {
  if( product.currentPage == 0) {
    hidePrevButton(product);
    showNextButton(product);
  } else if ( product.currentPage == product.pages - 1) {
    hideNextButton(product);
    showPrevButton(product);
  } else {
    showNextButton(product);
    showPrevButton(product);
  }
};

function showPrevButton(product) {
  $("#left-control").attr("src", "img-" + product.code + "/" + product.code + "-" + "prev.png");
};
function hidePrevButton(product) {
  $("#left-control").attr("src", "img-" + product.code + "/" + product.code + "-" + "aligner.png");
};
function showNextButton(product) {
  $("#right-control").attr("src", "img-" + product.code + "/" + product.code + "-" + "next.png");
};
function hideNextButton(product) {
  $("#right-control").attr("src", "img-" + product.code + "/" + product.code + "-" + "aligner.png");
};

function precacheBookImages(product) {
  var preloads = [];
  var tempImg = [];
  for(var i = 0; i < product.pages; i++) {
    // add each imagename to array
    preloads.push("img-" + product.code + "/" + product.code + "-" + i + ".jpg");
  }
  for(var x = 0; x < preloads.length; x++) {
    tempImg[x] = new Image();
    tempImg[x].src = preloads[x];
  }
};
