#include<Trade\Trade.mqh>

CTrade trade;

void OnTick()
  {
  string entry="";
  double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
  double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
  //Create an array for the prices
  MqlRates PriceInfo[];
  //We sort the array from the current candle downwards
  ArraySetAsSeries(PriceInfo,true);
  //Fill the array with the price data
 int PriceData=CopyRates(Symbol(),Period(),0,3,PriceInfo);
 //Create an array for several prices
 double UpperBandArray[];
 double LowerBandArray[];
 //Sort the price array from the current candle downwards
 ArraySetAsSeries(UpperBandArray,true);
 ArraySetAsSeries(LowerBandArray,true);
 
 //Define the Bollinger bands
 int BollingeBandsDefinition=iBands(_Symbol,_Period,10,0,2,PRICE_CLOSE);
 
 //Copy the price EA definition into the array for the lower and upper bands
 CopyBuffer(BollingeBandsDefinition,1,0,3,UpperBandArray);
 CopyBuffer(BollingeBandsDefinition,1,0,3,LowerBandArray);
 
 //Calculate the EA for the current candle
 double myUpperBandValue=UpperBandArray[0];
 double myLowerBandValue=LowerBandArray[0];
 
 //Calculate the EA for the candle before the current
 double myLastUpperBandValue=UpperBandArray[1];
 double myLastLowerBandValue=LowerBandArray[1];
 
 //Calculate the Entry levels of the EA
 if(//check if we have a rentry from below
 (PriceInfo[0].close>myLowerBandValue)&&(PriceInfo[1].close<myLastLowerBandValue)
 )
 {entry="buy";}
 if(//Check if we have a rentry from above
 (PriceInfo[0].close<myUpperBandValue)&&(PriceInfo[1].close>myLastUpperBandValue)
 )
 {entry="sell";}
   
   
   //sell 10 microlot 
   if(entry=="sell" && PositionsTotal()<1)
   trade.Sell(0.10,NULL,Bid,0,(Bid-20*_Point),NULL);
   
   //buy 10 microlot
   if(entry=="buy" && PositionsTotal()<1)
   trade.Buy(0.10,NULL,Ask,0,(Ask+20*_Point),NULL);
   
   //Chart output
   Comment("Entry signal is ",entry); 
  }
