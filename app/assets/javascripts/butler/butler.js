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
    window.location = '/butler#' + product.code;
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
  var stylz = ['classic', 'reserve', 'blackink'];

  for (var i = 0; i < stylz.length; i++) {
    if( !$('#' + stylz[i] + '-style').prop("disabled")) {
      var currentStyle = stylz[i];
    }
  }

  if( currentStyle.indexOf(product.theme) == -1) {
    $("#fadeWrapper").hide( 0, function() {
      for (var i = 0; i < stylz.length; i++) {
        $('#' + stylz[i] + '-style').prop("disabled", true);
      }
      $('#' + product.theme + '-style').prop("disabled", false);

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
    timedPadNav(10);
  });
  //initializeBook(product);
};

function timedPadNav(times) {
  for (var i = times; i >= 0; i--) {
    window.setTimeout(function(){
      padNav();
    }, 50);
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
