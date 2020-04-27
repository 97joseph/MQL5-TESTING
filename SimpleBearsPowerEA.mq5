#include <Trade\Trade.mqh>


CTrade trade;

void OnTick()
  {
  double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
  double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
  string signal="";
  MqlRates PriceInformation[];
   //Sort the array fom the current candle downwards
 ArraySetAsSeries(PriceInformation,true);
   //Copy the price data into the array
  int Data=CopyRates(Symbol(),Period(),0,3,PriceInformation);
   //Create an array for the EA data
  double myPriceArray[];
   //Sort the array from the current candle downwards
  ArraySetAsSeries(myPriceArray,true);
   //Define the Bears power EA
  int BearsPowerDefinition=iBearsPower(Symbol(),Period(),13);
   //Fill the array with data
 CopyBuffer(BearsPowerDefinition,0,0,3,myPriceArray);
   //Calculate the array value
 float BearsPowerValue=(myPriceArray[0]);
   //if the Bears power value is above 0
  if(BearsPowerValue>0)
   signal="buy";
   //if Bears power value is below 0
   if(BearsPowerValue<0)
   signal="sell";
   //Sell 10 microlot
   if(signal=="sell" && PositionsTotal()<1)
   trade.Sell(0.10,NULL,Bid,0,(Bid-150*_Point),NULL);
   
   //Buy 10 microlot
   if(signal=="buy" && PositionsTotal()<1)
   trade.Buy(0.10,NULL,Ask,0,(Ask+150*_Point),NULL);
   
   Comment("The current signal is: ",signal);
     
  }

