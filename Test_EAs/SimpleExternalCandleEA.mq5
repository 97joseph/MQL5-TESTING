#include<Trade\Trade.mqh>

//Create an instance of CTrade

CTrade trade;

//user input
input int NumberOfCandles=1;

void OnTick()
  {
double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

//array to handle the data
MqlRates PriceInfo[];
ArraySetAsSeries(PriceInfo,true);

//Fill the array with the price data
int PriceData=CopyRates(_Symbol,_Period,0,3,PriceInfo);

//create a string for the signal
string signal="";

//Create an array for several prices
double MovingAverageArray[];

//Define the properties of the Moving Average
int MovingAverageDefinition=iMA(_Symbol,_Period,NumberOfCandles,0,MODE_SMA,PRICE_CLOSE);

//Sort the array from the current candle downwards
ArraySetAsSeries(MovingAverageArray,true);

//Defined EA ,one line,current candle,3 candles ,store result
CopyBuffer(MovingAverageDefinition,0,0,3,MovingAverageArray);

//if the price is above the SMA and was below the SMA before
if(PriceInfo[1].close>MovingAverageArray[1])
if(PriceInfo[2].close<MovingAverageArray[2])
{
 signal="buy";
 }
//if the price is below the SMA and was above the SMA before
if(PriceInfo[1].close<MovingAverageArray[1])
if(PriceInfo[2].close>MovingAverageArray[20])
{
 signal="sell";
 }
 
 //Sell and buy conditions met
 if(signal=="sell" && PositionsTotal()<1)
 trade.Sell(0.10,NULL,Bid,(Bid+200*_Point),(Bid-150*_Point),NULL);
 
 if(signal=="buy" && PositionsTotal()<1)
  trade.Buy(0.10,NULL,Ask,(Ask+200*_Point),(Ask-150*_Point),NULL);
 


   
  }
//+------------------------------------------------------------------+
