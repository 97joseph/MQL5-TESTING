#include<Trade\Trade.mqh>
CTrade trade;

void OnTick()
  {
  //create an Array for several prices
  double myMovingAverageArray[];
  
  //define the properties of the Moving Average
  int movingAverageDefinition=imA (_Symbol,_Period,100,0,MODE_SMA,PRICE_CLOSE);
  
  //sort the price array from the current candle downwards
  ArraySetAsSeries(myMovingAverageArray,true);
  
  //Defined EA,on line,current candle,10 candles,store result
  CopyBuffer(movingAverageDefinition,0,0,10,myMovingAverageArray);
  
  //Get the Bid price
  double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
  
  //calculate the long term trend
  double Trend20=(myMovingAverageArray[0]-myMovingAverageArray[1]);
  
  //if Trend20 is falling
  if(Trend20<0)
     //if no open positions
     if(PositionsTotal()==0 && OrdersTotal()==0)
     
     {
     //sell stop ,1 lots,100 points below Bid,no SL
     //300 points TP,no expiration,no date,no comment
     trade.SellStop(1,Bid-100*_Point,_Symbol,0,Bid-300*_Point,ORDER_TIME_GTC,0,0)
   }
   Comment("Trend20:",Trend20);
   
   }

   
  }

