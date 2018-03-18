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
  // either update the last candle or make a new candle off the last one
  let lastCandle = getLastCandle();
  let newCandle;

  // make new candle if new day
  if (gameHour === 0 ) {
    newCandle = makeNewCandleFrom( lastCandle );
    addCandleToSymbol( newCandle );
    lastCandle = newCandle;
  }

  // the events of the hour
  updateLastCandlePrice( getRandomStockMove( getCurrentPrice() ) );

  incrementTime();
};

Game.draw = function() {
  drawSymbolInfo();
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
var currentSymbol;

// generate symbols, traders
function initializeGame() {


  // generate a sector with stocks
  generateSectors();

  currentSymbol = sectors[0].stocks[0]; // first sector, first stock

  gameDate = getLastCandle().date;

  // generate an initial AI trader
  traders.push( generateTrader() );
}

// { date: Fri Mar 16 2018 22:14:29 GMT-0300 (ADT),  open: 100, high: 101.02719683753726,
//   low: 99.89721696584655, close: 100.70829305278824, volume: 545.33232323 }

// show the interface around the chart
function drawSymbolInfo() {
  $('#stock-symbol').text( currentSymbol.symbol );
}

function drawChart() {
  let theStockData = currentSymbol.stockData;
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
}

function drawPlayerInfo() {
  $('#player-cash').text( "$" + myPortfolio.cash );
}

function startGame() {
  window.onEachFrame(Game.run);
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

  console.log(stock.stockData);

  return stock;
}

function generateTrader() {
  let trader = {};
  trader.name = "TRADEBOT 4000";
  trader.cash = 5000000; // 5 mil
  trader.stocks
  return trader;
}

function getLastCandle() {
  return currentSymbol.stockData[ currentSymbol.stockData.length - 1 ];
}

function getCurrentPrice() {
  return getLastCandle().close;
}

function makeNewCandleFrom( lastCandle ) {
  let newCandle = {};

  // one day later
  let lastDate = lastCandle.date;
  newCandle.date = new Date();
  newCandle.date.setTime(lastDate.getTime() + 86400000);

  newCandle.open = lastCandle.close;
  newCandle.close = lastCandle.close;
  newCandle.high = lastCandle.close;
  newCandle.low = lastCandle.close;
  newCandle.volume = 0;

  return newCandle;
}

function updateLastCandlePrice( newPrice ) {
  let lastCandle = getLastCandle();

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

function makeNewCandle(date, open, high, low, close, volume) {
  let newCandle = {};

  newCandle.date = date;
  newCandle.open = open;
  newCandle.high = high;
  newCandle.low  = low;
  newCandle.close = close;
  newCandle.volume = volume;

  return newCandle;
}

function addCandleToSymbol( candle ) {
  currentSymbol.stockData.push( candle );
  currentSymbol.stockData.shift();
}

function incrementTime() {
  gameHour += 1;
  if (gameHour === HOURS_IN_DAY) {
    gameHour = 0;
  }
}

// returns a new price based on old price, optional volatilityIndex & optional direction
function getRandomStockMove( originalPrice, volatilityIndex = null, dir = null) {
  let magnitude;
  let direction;
  let volatility;

  // calculate direction if necessary
  if (dir === null) {
    direction = Math.floor(Math.random() * 2); // 0 or 1
  } else {
    direction = dir;
  }

  // calculate volatility if necessary
  if ( !volatilityIndex ) {
    volatilityIndex = currentSymbol.volatilityIndex;  // use the symbol's by default
  } else {
    volatility = volatilityIndex;
  }

  // a random magnitude
  magnitude = Math.random() * volatilityIndex; // TODO figure out this formula

  return !direction ? ( originalPrice - magnitude ) : ( originalPrice + magnitude );
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
