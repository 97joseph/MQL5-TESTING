#include<Trade\Trade.mqh>

CTrade trade;

void OnTick()
  {
 //Calculate the Ask price and the Bid price
 double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
 double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
 
 //Create a string for the signal
 string signal="";
 
 //Create an array for the prices
 MqlRates PriceInfo[];
 
 //Sort the array from the current candle downwards
 ArraySetAsSeries(PriceInfo,true);
 
 //Copy price data into the array
 int Data=CopyRates(_Symbol,_Period,0,3,PriceInfo);
 
 //Create an array for the EA data
 double UpperBandArray[];
 double LowerBandArray[];
 
 //Sort the array from the current candle downwards
 ArraySetAsSeries(UpperBandArray,true);
 ArraySetAsSeries(LowerBandArray,true);
 
 //Define the Envelope EA
 int EnvelopeDefinition=iEnvelopes(_Symbol,_Period,14,0,MODE_SMA,PRICE_CLOSE,0.100);
 
 //fill the Array with data
 CopyBuffer(EnvelopeDefinition,0,0,3,UpperBandArray);
 CopyBuffer(EnvelopeDefinition,1,0,3,LowerBandArray);
 
 //Calculate the Array values
 double UpperBandValue=NormalizeDouble(UpperBandArray[0],6);
 double LowerBandValue=NormalizeDouble(LowerBandArray[0],6);
 
 //Calculate the Buy and Sell conditions
 if(PriceInfo[1].close<LowerBandValue)
 signal="buy";
 if(PriceInfo[1].close>UpperBandValue)
 signal="sell";
 
 //Buy and sell signals received
 if(signal=="sell" && PositionsTotal()<1)
 trade.Sell(0.10,NULL,Bid,0,(Bid-150*_Point),NULL);
 
 if(signal=="buy" && PositionsTotal()<1)
 trade.Buy(0.10,NULL,Ask,0,(Ask+150*_Point),NULL);
 
 //Chart output
 Comment("The current signal is: ",signal);
  
   
  }
