///// MAIN GAME VARIABLES & BASE ENGINE

var Game = {};
Game.fps = 1;

var gameDate = new Date();
var gameHour = 0;
const HOURS_IN_DAY = 8;

var allStocks = {}; // accessed by symbol

var nCandleLimit = 50;

var sectors = [];
var traders = [];

// player data
var myPortfolio = {
  cash: 1000000,
  stocks: []
}
var currentStock;

Game.run = function() {
  Game.update();
  Game.draw();
};

// logic for every tick of the game loop, ie. 1 'hour'
Game.update = function() {
  let symbolsInPlay = [currentStock]; // TODO expand later

  // Update all symbols in play
  for (var i = 0; i < symbolsInPlay.length; i++) {
    // either update the last candle or make a new candle off the last one
    let lastCandle = getLastCandleOf( symbolsInPlay[i] );
    let newCandle;

    // make new candle if new day
    if (gameHour === 0 ) {
      newCandle = makeNewCandleFrom( lastCandle );
      addCandleToSymbol( newCandle, symbolsInPlay[i] );
      lastCandle = newCandle;
    }

    // update the price of the candle based on factors
    // TODO expand factors
    updateLastCandlePriceOf( symbolsInPlay[i],
                             getRandomStockMove( getCurrentPriceOf( symbolsInPlay[i] ),
                                                 symbolsInPlay[i].volatilityIndex ) );
  }

  incrementTime();
};

Game.draw = function() {
  drawStockInfo();
  drawChart();
  drawPlayerInfo();
  drawEnvironmentInfo();
};

// generate symbols, traders
function initializeAndStartGame() {
  initializeGame();
  startGame();
}

function initializeGame() {

  let newStock = generateStock();
  allStocks[ newStock.symbol ] = newStock;

  // generate a sector with stocks
  generateSectors();

  currentStock = allStocks[ newStock.symbol ];   // first stock

  gameDate.setTime( getLastCandleOf( currentStock ).date.getTime() ) ;

  // generate an initial AI trader
  traders.push( generateTrader() );
}

function startGame() {
  window.onEachFrame( Game.run );
}

function incrementTime() {
  gameHour += 1;
  if (gameHour === HOURS_IN_DAY) {
    gameHour = 0;
    gameDate.setTime( gameDate.getTime() + 86400000 );
  }
}

//// PRINTING FUNCTIONS //////

// show the interface around the chart
function drawStockInfo() {
  $('#stock-symbol').text( currentStock.symbol );
  $('#stock-name').text( currentStock.companyName );
  //$('#stock-description').text( currentStock.description );
  // $('#stock-sector').text( currentStock.sector );
  $('#stock-price').text( "$" + getCurrentPriceOf(currentStock) );
}

// Draw the chart for the current symbol
function drawChart() {
  let theStockData = currentStock.stockData;
  //console.log(theStockData);

  // set the Y axis based on high and low of data
  var yExtent = fc.extentLinear()
    .accessors([
      function(d) { return d.high; },
      function(d) { return d.low; }
    ]);

  // set the X axis as the date
  var xExtent = fc.extentDate()
    .accessors([function(d) { return d.date; }]);

  var gridlines = fc.annotationSvgGridline();
  var candlestick = fc.seriesSvgCandlestick();

  var multi = fc.seriesSvgMulti()
      .series([gridlines, candlestick]);

  var chart = fc.chartSvgCartesian(
      fc.scaleDiscontinuous(d3.scaleTime()),
      d3.scaleLinear()
    )
    .yDomain(yExtent( theStockData ))
    .xDomain(xExtent( theStockData ))
    .plotArea(multi);

  d3.select('#stock-chart')
    .datum( theStockData )
    .call(chart);

  $('.y-axis').css('margin-left', '10px');
  // TODO fix the gap
  //$('.gridline-x').attr('x2', '530');
  //$('.plot-area').width(560);
  //$('.plot-area').children('svg').eq(0).attr('width', 560);
}

function drawPlayerInfo() {
  let portfolioText = "";
  let mySymbols = Object.keys( myPortfolio.stocks );

  $('#player-cash').text( "$" + numberWithCommas( round( myPortfolio.cash, 0) ) );

  // draw the player's portfolio + value
  for (var i = 0; i < mySymbols.length; i++) {
    if ( myPortfolio.stocks[ mySymbols[i] ] ) {
      portfolioText += mySymbols[i] + " x " + numberWithCommas( myPortfolio.stocks[ mySymbols[i] ] ) +
                                      " : $" + numberWithCommas ( round ( currentShareValue( getStockBySymbol(mySymbols[i]),
                                                                                             myPortfolio.stocks[ mySymbols[i] ] ), 0));
    }
  }
  $('#player-portfolio').text( portfolioText );

  // draw players's net worth
  $('#player-networth').text( "$" + numberWithCommas( round( playerNetWorth(), 0) ) );
}

function drawEnvironmentInfo() {
  $('#date-display').text( gameDate.toDateString() );
}

//////////// GENERATORS ////////////

function generateSectors() {
  let newSector = {};

  newSector.name = "Mining";
  newSector.symbols = ["FLR"];

  sectors.push( newSector );
}

function generateStock() {
  let stock = {};

  stock.companyName = "Flarn Industries"; // TODO make a randomizer
  stock.symbol = "FLR"; // TODO make another randomizer
  stock.description = "Makers of quality mine-drills.";
  stock.stockData = fc.randomFinancial()( nCandleLimit );
  stock.bids = [];
  stock.offers = [];
  stock.volatilityIndex = 1;

  //console.log(stock.stockData);
  return stock;
}

function generateTrader() {
  let trader = {};
  trader.name = "TRADEBOT 4000";
  trader.cash = 5000000; // 5 mil
  trader.stocks
  return trader;
}

///// STOCK HELPERS

function getStockBySymbol( symbol ) {
  return allStocks[ symbol ];
}

function getLastCandleOf( symbol ) {
  return symbol.stockData[ symbol.stockData.length - 1 ];
}

function makeNewCandleFrom( lastCandle ) {
  let newCandle = {};
  let lastDate = lastCandle.date;

  newCandle.date = new Date();
  newCandle.date.setTime( lastDate.getTime() + 86400000 );    // one day later

  newCandle.open = lastCandle.close;
  newCandle.close = lastCandle.close;
  newCandle.high = lastCandle.close;
  newCandle.low = lastCandle.close;
  newCandle.volume = 0;

  return newCandle;
}

function updateLastCandlePriceOf( symbol, newPrice ) {
  let lastCandle = getLastCandleOf( symbol );

  // update price
  lastCandle.close = newPrice;

  // update highs and lows
  if (newPrice > lastCandle.high) {
    lastCandle.high = newPrice;
  }
  if (newPrice < lastCandle.low) {
    lastCandle.low = newPrice;
  }
}

function addCandleToSymbol( candle, symbol ) {
  symbol.stockData.push( candle );
  symbol.stockData.shift();
}

// returns a new price based on old price, optional volatilityIndex & optional direction
function getRandomStockMove( originalPrice, volatilityIndex, dir = null) {
  let magnitude;
  let direction;
  let volatility;

  // calculate direction if necessary
  if (dir === null) {
    direction = Math.floor(Math.random() * 2); // 0 or 1
  } else {
    direction = dir;
  }

  // a random magnitude
  magnitude = Math.random() * volatilityIndex;

  return !direction ? ( originalPrice - magnitude ) : ( originalPrice + magnitude );
}

////// BUYERS AND SELLERS /////

function buyStockWithPortfolio( stock, portfolio, amt ) {
  let stockCost = currentShareValue( stock, amt );
  if ( stockCost <= portfolio.cash ) {
    portfolio.cash -= stockCost;
    if ( !portfolio.stocks[ stock.symbol ] ) {
      portfolio.stocks[ stock.symbol ] = amt;
    } else {
      portfolio.stocks[ stock.symbol ] += amt;
    }
    Game.draw();
    return true;
  } else {
    return false;
  }
}

function sellStockWithPortfolio( stock, portfolio, amt ) {
  let stockValue = currentShareValue( stock, amt );

  if ( portfolio.stocks[ stock.symbol ] >= amt ) {
    portfolio.stocks[ stock.symbol ] -= amt;
    portfolio.cash += stockValue;
    Game.draw();
    return true;
  } else {
    return false;
  }
}

//////// CALCULATORS /////////

function getCurrentPriceOf( symbol ) {
  return round( getLastCandleOf( symbol ).close , 2) ;
}

function currentShareValue( stock, lots ) {
  return ( getCurrentPriceOf( stock ) * lots );
}

function playerNetWorth() {
  let shareValue = 0;

  // calculate share value
  let symbols = Object.keys( myPortfolio.stocks );
  for (var i = 0; i < symbols.length; i++) {
    shareValue += currentShareValue( getStockBySymbol( symbols[i] ), myPortfolio.stocks[ symbols[i] ] );
  }

  return myPortfolio.cash + shareValue;
}

///////  GENERAL HELPERS

function round(value, decimals) {
  return Number(Math.round(value+'e'+decimals)+'e-'+decimals);
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

//////////////////

(function() {
  var onEachFrame;
  // if (window.webkitRequestAnimationFrame) {
  //   onEachFrame = function(cb) {
  //     var _cb = function() { cb(); webkitRequestAnimationFrame(_cb); }
  //     _cb();
  //     console.log(1);
  //   };
  // } else if (window.mozRequestAnimationFrame) {
  //   onEachFrame = function(cb) {
  //     var _cb = function() { cb(); mozRequestAnimationFrame(_cb); }
  //     _cb();
  //     console.log(2);
  //   };
  // } else {
    onEachFrame = function(cb) {
      setInterval(cb, Game.fps * 1000 );
    }
  // }
  window.onEachFrame = onEachFrame;
})();
