#include<Trade\Trade.mqh>

//Create an instance of CTrade
CTrade trade;

void OnTick()
  {
  //Calculate the Ask price
  double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
  //Calculate the Bid price
  double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
  //Create a string for the signal
  string signal="";
  
  //We create an array for the EA
  double myPriceArray[];
  //We define the EA
  int ForceIndexDefinition=iForce(_Symbol,_Period,13,MODE_SMA,VOLUME_TICK);
  //We sort the array from the current candle downwards
  ArraySetAsSeries(myPriceArray,true);
  //Defined EA,buffer 0,from current candle for 3 candles,save in array
  CopyBuffer(ForceIndexDefinition,0,0,3,myPriceArray);
  //Calculate the value for the current candle
  double ForceIndexValue=(NormalizeDouble(myPriceArray[0],6));
  
  //Calculate the value for the second candle set
  double LastForceIndexValue=(NormalizeDouble(myPriceArray[1],6));
  
  //Generate the trade signals relative to the 0 index
  //Buy{ForceIndexValue<0 and LastForceIndexValue>0
  
  
  
  //Buy signal
  if(ForceIndexValue<0 && LastForceIndexValue>0)
  signal="buy";
  //Sell signal
  if(ForceIndexValue>0 && LastForceIndexValue<0)
  signal="sell";
  
  //Sell 10 microlots
  if(signal=="sell" && PositionsTotal()<1)
   trade.Sell(0.10,NULL,Bid,(Bid+500*_Point),NULL);
   
   //Buy 10 microlot
  if(signal=="buy" && PositionsTotal()<1)
    trade.Buy(0.10,NULL,Ask,(Ask-500*_Point),(Ask+250*_Point),NULL);
    
    //Chart output
    Comment("The current signal is: ",signal);
  

  
   
  }
