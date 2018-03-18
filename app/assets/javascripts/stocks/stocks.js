var Game = {};
Game.fps = 1;

var gameDate = new Date();
var gameHour = 0;
const HOURS_IN_DAY = 8;

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
};

var nCandleLimit = 50;

var sectors = [];
var traders = [];

// player data
var myPortfolio = {
  cash: 1000000,
  stocks: []
}
var currentStock;

// generate symbols, traders
function initializeGame() {

  // generate a sector with stocks
  generateSectors();

  currentStock = sectors[0].stocks[0]; // first sector, first stock

  gameDate.setTime( getLastCandleOf( currentStock ).date.getTime() ) ;

  // generate an initial AI trader
  traders.push( generateTrader() );
}

// show the interface around the chart
function drawStockInfo() {
  $('#stock-symbol').text( currentStock.symbol );
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
  $('#player-cash').text( "$" + myPortfolio.cash );
}

function startGame() {
  window.onEachFrame( Game.run );
}

function generateSectors() {
  let newSector = {};

  newSector.name = "Mining";
  newSector.stocks = [];
  newSector.stocks.push( generateStock() ); // do more times

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

function getLastCandleOf( symbol ) {
  return symbol.stockData[ symbol.stockData.length - 1 ];
}

function getCurrentPriceOf( symbol ) {
  return getLastCandleOf( symbol ).close;
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

function incrementTime() {
  gameHour += 1;
  if (gameHour === HOURS_IN_DAY) {
    gameHour = 0;
    gameDate.setTime( gameDate.getTime() + 86400000 );
  }
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

function buyStockWithPortfolio( stock, portfolio, amt ) {
  // if (  ) {

  // }
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
