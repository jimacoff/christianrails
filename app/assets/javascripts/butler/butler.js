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
    description:"Novella series",
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
    pageName:"Archives",
    theme:"classic",
    code:"archives"
  },
  {
    pageName:"Thanks for ordering!",
    theme:"reserve",
    code:"ghost-thanks"
  }
];

function makeNavButton(product) {
  $("nav").append("<table class=\"product-icon swell\"><tbody><tr><th><a href=\"" +
      product.code + "\"><img src=\"assets/butler/buttons/" +
      product.icon + "\" width=\"" +
      product.iconW + "px\" height=\"" +
      product.iconH + "\"></a></th></tr> <tr><th><a class=\"product-link Courier\" href=\"" +
      product.code + "\">" +
      product.productName + "</a></th></tr> <tr><th class=\"product-description Courier diminutive\">" +
      product.description + "</th></tr></tbody></table>");
};

function makeNavMobileButton(product) {
  $("nav-mobile").append("<table class=\"product-icon swell flow\"><tbody><tr><th><a href=\"" +
      product.code + "\"><img src=\"assets/butler/buttons/" +
      product.icon + "\" width=\"" +
      product.iconW + "px\" height=\"" +
      product.iconH + "\"></a></th></tr> <tr><th><a class=\"product-link Courier\" href=\"" +
      product.code + "\">" +
      product.productName + "</a></th></tr> <tr><th class=\"product-description Courier diminutive\">" +
      product.description + "</th></tr></tbody></table>");
};

function loadProductFromHash() {
  var hash = getHashOfWindow();
  product = (hash !== '') ? findProductByCode(hash) : findProductByCode('blog');
  showProduct(product);
};

function switchPage(context) {
  var codeOfClicked = $(context).attr('href');
  var product = findProductByCode(codeOfClicked);

  //don't switch if already on this product
  hash = getHashOfWindow();
  if(hash !== codeOfClicked) {
    // Fill #content with target page contents
    window.location.hash = product.code;
    hideThenShowNewProduct(product);
  }
  scrollToContent(product);
};

function loadStyleSheet() {
  var hash = getHashOfWindow();
  if(hash.length > 0) {
    switchStyle(findProductByCode(hash));
  }
};

function hideThenShowNewProduct(product) {
  $('#content').fadeOut('fast', function() { showProduct(product) } );
  switchStyle(product);
};

function switchStyle(product){
  var currentStyle = $('#flavourstyle').attr('href');
  if( currentStyle.indexOf(product.theme) == -1) {
    $("#fadeWrapper").hide( 0, function() {
      $('#flavourstyle').attr('href', "assets/butler/" + product.theme + ".css");
      swapHeaderIcon(product);
      $("#fadeWrapper").fadeIn('fast');
    } );
  }
};

function swapHeaderIcon(product) {
  if(product.theme === 'reserve') {
    $("#title-img").addClass('hidden');
    $("#ink-title-img").addClass('hidden');
    $("#reserve-title-img").removeClass('hidden');
  } else if(product.theme === 'blackink') {
    $("#title-img").addClass('hidden');
    $("#ink-title-img").removeClass('hidden');
    $("#reserve-title-img").addClass('hidden');
  } else {
    $("#title-img").removeClass('hidden');
    $("#ink-title-img").addClass('hidden');
    $("#reserve-title-img").addClass('hidden');
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
  hideAllPartials();
  $('#' + product.code).removeClass('hidden');

  showNewContent(product);
};

function hideAllPartials() {
  $('#about').addClass('hidden');
  $('#archives').addClass('hidden');
  $('#blackink').addClass('hidden');
  $('#blog').addClass('hidden');
  $('#diamondfind').addClass('hidden');
  $('#ghostcrime').addClass('hidden');
  $('#gray').addClass('hidden');
  $('#reserve').addClass('hidden');
  $('#silverstock').addClass('hidden');
  $('#snapback').addClass('hidden');
  $('#thisbadger').addClass('hidden');
}


function showNewContent(product) {
  $('#content').fadeIn('slow', function() {
    timedPadNav(5);
  });
  //initializeBook(product);
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
