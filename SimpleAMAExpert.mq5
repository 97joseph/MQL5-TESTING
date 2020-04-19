#include <Trade\Trade.mqh>

//Create an instance of CTrade\
CTrade trade;

void OnTick()
  {
//Calculate the Ask price
double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);

//Calculate the Bid Price
double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

//We create an array for the prices
MqlRates PriceInfo[];

//We sort the price array from the current candle downward
ArraySetAsSeries(PriceInfo,true);

//We fill the array with the price data
int PriceData=CopyRates(Symbol(),Period(),0,3,PriceInfo);

//create a string variable for the signal
string signal="";

//create an Array for several prices that will contain the indicator value
double myPriceArray[];

//define the properties of the AdaptiveMovingAverageValueEA,10 pips trend incicator
int AdaptiveMovingAverage=iAMA(_Symbol,_Period,10,2,30,0,PRICE_CLOSE);
   
//sort the price array from the current candle downwards
ArraySetAsSeries(myPriceArray,true);

//Defined MA1,one line,current candle,3 candles,store result
CopyBuffer(AdaptiveMovingAverage,0,0,3,myPriceArray);

//Get the value of the current candle
double AdaptiveMovingAverageValue=NormalizeDouble(myPriceArray[0],6);

//sell signal
if(AdaptiveMovingAverageValue > PriceInfo[0].close)
signal="sell";

//buy signal
if (AdaptiveMovingAverageValue< PriceInfo[0].close)
signal = "buy";

//Buy 10 microlots according to the signal value
if(signal == "buy" && PositionsTotal()<1)
trade.Buy(0.10,NULL,Ask,0,(Ask+20*_Point),NULL);

//Sell 10 microlots according to the signal value
if(signal == "sell" && PositionsTotal()<1)
trade.Sell(0.10,NULL,Bid,0,(Bid-150*_Point),NULL);

//Create a chart output
Comment("The current signal is: ",signal);

  

  }