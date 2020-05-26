#include<Trade\Trade.mqh>
//Create an instance of CTrade
CTrade trade;

void OnTick()
  {
  double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
  double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
  string signal="";
  //Create a price array
  MqlRates PriceArray[];
  //Sort the array from the current candle downwards
  ArraySetAsSeries(PriceArray,true);
  //Fill the array with data for 3 caandles
  int Data=CopyRates(_Symbol,_Period,0,3,PriceArray);
  //Create an Array for the EA data
  double EArray[];
  //Sort the array from the current candle downwards
  ArraySetAsSeries(EArray,true);
  //Define the IVIDyA EA
  int iVIDyADefinition=iVIDyA(_Symbol,_Period,9,12,0,PRICE_CLOSE);
  
  //Defined EA,first buffer,current candle,3 candles,save in array
  CopyBuffer(iVIDyADefinition,0,0,3,EArray);
  //find the current value
  float iVIDyAVALUE=EArray[0];
  //calculate the signal
  if(iVIDyAVALUE>PriceArray[1].close)
  signal="sell";
  if(iVIDyAVALUE<PriceArray[1].close)
  signal="buy";
  
  //Sell 10 microlot
  if(signal=="sell" && PositionsTotal()<1)
  trade.Sell(0.10,NULL,Bid,0,(Bid-150*_Point),NULL);
  
  //Buy 10 micrlot
  if(signal=="buy" && PositionsTotal()<1)
  trade.Buy(0.10,NULL,Ask,0,(Ask-150*_Point),NULL);
  
  //Create the chart output
  Comment("The current signal is: ",signal);
  

   
  }
