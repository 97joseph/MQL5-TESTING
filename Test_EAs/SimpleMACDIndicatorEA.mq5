#include<Trade\Trade.mqh>

CTrade trade;

void OnTick()
  {
 string signal="";
 
 //Compute the Bid and Ask
 double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
 double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
 
 //Create an array for the price data
 double PriceArray[];
 //Sort the array from the current candle downwards
 ArraySetAsSeries(PriceArray,true);
 
 //Define the properties for the MACD EA
 int MacDDefinition=iMACD(_Symbol,_Period,12,26,9,PRICE_CLOSE);
 
 //Defined EA,buffer 0,current candle,for 3 candles ,store in array
 CopyBuffer(MacDDefinition,0,0,3,PriceArray);
 
 //Calculate the EA for the current candle and the candle before
 float MacDValue=PriceArray[0];
 float LastMacDValue=PriceArray[1];
 
 //Calculate the Buy and Sell conditions
 //Buy Condtion
 if(MacDValue>0 && LastMacDValue<0)
 signal="buy";
 
 //Sell condition
 if(MacDValue<0 && LastMacDValue>0)
 signal="sell";
 
 //Buy and Sell Functions
 if(signal=="buy" && PositionsTotal()<1)
 trade.Buy(0.10,NULL,Ask,0,(Ask+150*_Point),NULL);
 
 if(signal=="sell" && PositionsTotal()<1)
 trade.Sell(0.10,NULL,Bid,0,(Bid-150*_Point),NULL);
 
 
 
 
   
  }
