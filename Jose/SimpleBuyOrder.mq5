//Create an instance of CTrade

#include<Trade\Trade.mqh>
CTrade trade;

void OnTick()
  {
  //Get the Ask price
  double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
  
  //We create an array for the prices
  MqlRates PriceInfo[];
  
  //We sort the price array from the current candle downwards
  ArraySetAsSeries(PriceInfo,true);
  
  //We fill the array with the price data
  int PriceData=CopyRates(_Symbol,_Period,0,3,PriceInfo);
  
  //buy when candle is bullish
  if(PriceInfo[1].close>PriceInfo[1].open)
  
  //if we have no open positions
   if(PositionsTotal()==0)
   {
   //buy
   trade.Buy(
      0.10,//how much
      NULL,//current symbol
      Ask,//buy price
      Ask-300*_Point,//Stop Losss
      Ask+150*_Point,//Take profit
      NULL//Comment 
      );
   
  }
  

   }
  
