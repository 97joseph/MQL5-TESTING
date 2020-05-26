#include<Trade\Trade.mqh>

CTrade trade;

void OnTick()
  {
 double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
 double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
 //Price array
 MqlRates PriceInfo[];
 //fill the array with price data
 int PriceData=CopyRates(Symbol(),Period(),0,3,PriceInfo);
 
 //create a string for the signal
 string signal="";
 
 //create an array for several prices
 double MovingAverageArray[];
 
 //moving average properties definition
 int MovingAverageDefinition=iMA(_Symbol,_Period,20,0,MODE_SMA,PRICE_CLOSE);
 
 //Defined EA,one line,current candle,3 candles, store result 
 CopyBuffer(MovingAverageDefinition,0,0,3,MovingAverageArray);
 
 //if the price is above the SMA
 if(PriceInfo[1].close>MovingAverageArray[1])
 
 //and was below the SMA before
 if(PriceInfo[2].close<MovingAverageArray[2])
 {
 signal="buy";
 }
 
 //if the price is below the SMA
 if(PriceInfo[1].close < MovingAverageArray[1])
 
 //and was above the SMA before
 if(PriceInfo[2].close > MovingAverageArray[2])
 {
 signal="sell";
 } 
 
 //sell 10 microlot
 if(signal=="sell" && PositionsTotal()<1)
  trade.Sell(0.10,NULL,Bid,0,(Bid-150*_Point),NULL);
  
 if(signal=="buy" && PositionsTotal()<1)
  trade.Buy(0.10,NULL,Ask,0,(Ask-150*_Point),NULL);
  
 
 
   
  }
