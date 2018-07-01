function moveToTop() {
  $("html, body").animate({ scrollTop: 0 }, "slow");
};

function scrollToContent(product) {
  var position = window.scrollY,
      inkContent = 0, //244,
      mainContent = 0; //180;

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
  var navHeight = $('#swappable-content').outerHeight(true) + $('#top-bar').outerHeight(true) + littleExtra;
  $("html, body").animate({ scrollTop: navHeight }, "slow");
};
