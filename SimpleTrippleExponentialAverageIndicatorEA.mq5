#include<Trade\Trade.mqh>

CTrade trade;

void OnTick()
  {
  //Calculate the Ask price and the Bid price
  double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
  double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
 
 //Create an array for the prices
 MqlRates PriceInfo[];
 
 //Sort the price array from the current candle downwards
 ArraySetAsSeries(PriceInfo,true);
 
 //We fill the array with the price data
 int PriceData=CopyRates(Symbol(),Period(),0,3,PriceInfo);
 
 //Signal variable
 string signal="";
 
 //Create an Array for several prices
 double myPriceArray[];
 
 //Define the properties of the ITriX(Tripple Exponential Average Indicator)
 int iTriXDefinition=iTriX(_Symbol,_Period,14,PRICE_CLOSE);
 
 //sort the price array from the current candle downwards
 ArraySetAsSeries(myPriceArray,true);
 
//Defined MA1,one line ,current candle,3 candles,store result
 CopyBuffer(iTriXDefinition,0,0,3,myPriceArray);
 
 //get the value of the current candle
 float iTrixValue=myPriceArray[0];
 
 if(iTrixValue>0)
 signal="buy";
 
 if(iTrixValue<0)
 signal="sell"; 
 
 //Sell and Buy condition
 if(signal=="sell" && PositionsTotal()<1)
 trade.Sell(0.10,NULL,Bid,0,(Bid-150*_Point),NULL);
 
 if(signal=="buy" && PositionsTotal()<1)
 trade.Buy(0.10,NULL,Ask,0,(Ask+150*_Point),NULL);

  }
