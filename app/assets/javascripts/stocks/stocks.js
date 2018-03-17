var Game = {};
Game.fps = 1;

Game.run = function() {
  console.log('tick');
  Game.update();
  Game.draw();
};

// logic for every tick of the game loop
Game.update = function() {
  // TODO
};

Game.draw = function() {
  drawSymbolInfo();
  drawChart();
};

var nCandleLimit = 50;

// RANDOM STOCK DATA FOR NOW
var stockData = fc.randomFinancial()( nCandleLimit );
console.log(stockData);

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

  // TODO generate traders

}

// { date: Fri Mar 16 2018 22:14:29 GMT-0300 (ADT),  open: 100, high: 101.02719683753726,
//   low: 99.89721696584655, close: 100.70829305278824, volume: 545.33232323 }

// show the interface around the chart
function drawSymbolInfo() {
  // TODO
}

function drawChart() {
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
    .yDomain(yExtent( stockData ))
    .xDomain(xExtent( stockData ))
    .plotArea(multi);

  d3.select('#stock-chart')
    .datum( stockData )
    .call(chart);
}

function drawPlayerInfo() {
  // TODO player interface
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
  stock.stockData = [];
  stock.bids = [];
  stock.offers = [];

  return stock;
}

function generateTrader() {
  let trader = {};
  trader.name = "TRADEBOT 4000";
  trader.cash = 5000000; // 5 mil
  trader.stocks
  return trader;
}


function makeNewCandleFrom( lastCandle ) {
  let newCandle = {};

  return newCandle;
}

function updateLastCandle( lastCandle ) {

  return lastCandle;
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
