// Product objects
var entities = [
  {
    productName:"Ghostcrime",
    description:"Spooky robot novel",
    icon:"ghostcrime-icon.png",
    code:"ghostcrime",
    theme:"reserve",
    iconH:"200",
    iconW:"150"
  },
  {
    productName:"Diamond Find",
    description:"Story Choice Adventure",
    icon:"diamondfind-icon.png",
    code:"diamondfind",
    theme:"classic",
    iconH:"150",
    iconW:"150"
  },
  {
    productName:"I Found This Badger",
    description:"A cautionary blog",
    icon:"thisbadger-icon.png",
    code:"thisbadger",
    theme:"blackink",
    iconH:"125",
    iconW:"125"
  },
  {
    productName:"Black Ink",
    description:"21 dark comics",
    icon:"blackink-icon.jpg",
    code:"blackink",
    theme:"blackink",
    iconH:"150",
    iconW:"150",
    pages:23,
    currentPage:0,
    pageH:700,
    pageW:700,
    controlH:50,
    controlW:200
  },
  {
    productName:"Gray",
    description:"Official novel",
    icon:"gray-icon.png",
    code:"gray",
    theme:"blackink",
    iconH:"200",
    iconW:"130"
  },
  {
    productName:"Snapback",
    description:"Read a sample",
    icon:"snapback-icon.jpg",
    code:"snapback",
    theme:"classic",
    iconH:"150",
    iconW:"225"
  },
  {
    productName:"Silver Stock",
    description:"16 shiny comics",
    icon:"silverstock-icon.jpg",
    code:"silverstock",
    theme:"reserve",
    iconH:"125",
    iconW:"200",
    pages:21,
    currentPage:0,
    pageH:511,
    pageW:715,
    controlH:100,
    controlW:100
  },
  {
    pageName:"Reserve",
    theme:"reserve",
    code:"reserve"
  },
  {
    pageName:"Blog",
    theme:"classic",
    code:"blog"
  },
  {
    pageName:"About",
    theme:"classic",
    code:"about"
  },
  {
    pageName:"Thanks for ordering!",
    theme:"reserve",
    code:"ghost-thanks"
  }
];

  function makeNavButton(product) {
    $("nav").append("<table class=\"product-icon swell\"><tbody><tr><th><a href=\"" +
        product.code + ".php\"><img src=\"buttons/" +
        product.icon + "\" width=\"" +
        product.iconW + "px\" height=\"" +
        product.iconH + "\"></a></th></tr> <tr><th><a class=\"product-link Courier\" href=\"" +
        product.code + ".php\">" +
        product.productName + "</a></th></tr> <tr><th class=\"product-description Courier diminutive\">" +
        product.description + "</th></tr></tbody></table>");
  };

  function makeNavMobileButton(product) {
    $("nav-mobile").append("<table class=\"product-icon swell flow\"><tbody><tr><th><a href=\"" +
        product.code + ".php\"><img src=\"buttons/" +
        product.icon + "\" width=\"" +
        product.iconW + "px\" height=\"" +
        product.iconH + "\"></a></th></tr> <tr><th><a class=\"product-link Courier\" href=\"" +
        product.code + ".php\">" +
        product.productName + "</a></th></tr> <tr><th class=\"product-description Courier diminutive\">" +
        product.description + "</th></tr></tbody></table>");
  };

  function loadProductFromHash() {
    // Check for hash value in URL
    var hash = getHashOfWindow();
    if(hash !== '') {
      product = findProductByCode(hash);
    } else {
      product = findProductByCode('blog');
    }
    showProduct(product);
  };

  loadProductFromHash();
  loadStyleSheet();

  // Navigation button clicks
  $('nav a').click(function(){
    switchPage(this);
    return false;
  });
  $('nav-mobile a').click(function(){
    switchPage(this);
    return false;
  });
  $('.link').click(function(){
    switchPage(this);
    return false;
  });


function switchPage(context) {
  var codeOfClicked = $(context).attr('href').substr(0,$(context).attr('href').length-4);
  var product = findProductByCode(codeOfClicked);

  //don't switch if already on this product
  hash = getHashOfWindow();
  if(hash !== codeOfClicked) {
    // Fill #content with target page contents
    navigateTo(product);
    switchStyle(product);
  }
  scrollToContent(product);
};

function navigateTo(productClicked) {
  window.location.hash = productClicked.code;
  hideThenShowNewProduct(productClicked);
};

function loadStyleSheet() {
  var hash = getHashOfWindow();
  if(hash.length > 0) {
    switchStyle(findProductByCode(hash));
  }
};

function hideThenShowNewProduct(product) {
  $('#content').hide({duration: 0, done: showProduct(product) } );
  switchStyle(product);
};

function switchStyle(product){
  var currentStyle = $('#flavourstyle').attr('href');
  if( currentStyle.indexOf(product.theme) == -1) {
    $("#fadeWrapper").hide( 0, function() {
      $('#flavourstyle').attr('href', "css/" + product.theme + ".css");
      swapHeaderIcon(product);
      $("#fadeWrapper").fadeIn('fast');
    } );
  }
};

function swapHeaderIcon(product) {
  var prefix = "img-butler/";
  if(product.theme === 'reserve') {
    $("#title-img").attr("src", prefix + "logo-reserve.jpg");
  } else if(product.theme === 'blackink') {
    $("#title-img").attr("src", prefix + "inklogo.png");
  } else if(product.theme === 'ghostcrime') {
    $("#title-img").attr("src", prefix + "title-comedyserver.jpg");
  } else {
    $("#title-img").attr("src", prefix + "title-comedyserver.jpg");
  }
};

function moveToTop() {
  $("html, body").animate({ scrollTop: 0 }, "slow");
};

function scrollToContent(product) {
  var position = window.scrollY,
      inkContent = 244,
      mainContent = 180;

  if(product.theme === 'blackink') {
    if(position > inkContent) {
      $("html, body").animate({ scrollTop: inkContent }, "slow");
    }
  } else {
    if(position > mainContent) {
      $("html, body").animate({ scrollTop: mainContent }, "slow");
    }
  }
};

function moveToProducts() {
  var littleExtra = 50;
  var navHeight = $('#content').outerHeight(true) + $('#top-bar').outerHeight(true) + littleExtra;
  $("html, body").animate({ scrollTop: navHeight }, "slow");
};

// Window hash functions
function getHashOfWindow() {
  return window.location.hash.substr(1);
}

function showProduct(product) {
  $('#content').load(product.code + ".php", function() {
    showNewContent(product);
  });
};

function showNewContent(product) {
  $('#content').fadeIn('slow', function() {
    timedPadNav(5);
  });
  initializeBook(product);
};

function timedPadNav(times) {
  for (var i = times; i >= 0; i--) {
    window.setTimeout(function(){
      padNav();
    }, 500);
  };
};

function padNav() {
  var AESTHETIC = 20,
      footerHeight = $('#footer-bar').outerHeight(),
      navHeight = $('nav').outerHeight(),
      contentHeight = $('#content').outerHeight(true),
      extraMargin = (contentHeight + footerHeight) - navHeight;

      $('nav').css('margin-bottom', 0);
      if(extraMargin > 0) {
        $('nav').css('margin-bottom', extraMargin + AESTHETIC);
      } else {
        $('nav').css('margin-bottom', AESTHETIC);
      }
};

function findProductByCode(productCode) {
  //takes codes and strings that contain codes
  for (var i = 0; i < entities.length; i++) {
    if( productCode.indexOf(entities[i].code) > -1) {
      return entities[i];
    }
  }
  return -1;
};

// Comic viewer controls

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
  // update the controls
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
