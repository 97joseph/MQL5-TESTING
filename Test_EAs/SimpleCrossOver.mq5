#include<Trade\Trade.mqh>

//Create an instance of Ctrade
input int SmallMovingAverage=20;
input int BigMovingAverage=50;

void OnTick()
  {
  //Calculate the Ask price
  double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
 //We calculate the Bid price
 double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID,_Digits)

 //create a string for the signal
 string signal="";
 
 //Create an array for several prices
 double SmallMovingAverageArray[],BigMovingAverageArray[];
 
 //define the properties of the small moving Average
 int SmallMovingAverageDefinition=iMA(_Symbol,_Period,SmallMovingAverage,0,MODE_SMA,PRICE_CLOSE);
 
 //define the properties of the Big Moving Average
 int BigMovingAverageDefinition=iMA(_Symbol,_Period,BigMovingAverage,0,MODE_SMA,PRICE_CLOSE);
 
 //Defined EA,one line ,current candle,3 candles movement,store result
 CopyBuffer(SmallMovingAverageDefinition,0,0,10,SmallMovingAverageArray);

//Defined EA,one line,current candle,10  candles movement,store result
CopyBuffer(BigMovingAverageDefinition,0,0,10,BigMovingAverageArray)

//if BigMovingAverage>SmallMovingAverage
if(BigMovingAverageArray[1]>SmallMovingAverageArray[1])

//if BigMovingAverage<SmallMovingAverage before the former[1] then call in a buy
  if(BigMovingAverageArray[2]<SmallMovingAverageArray[2])
  {
   signal="buy"; 
  } 
  
//if BigMovingAverage<SmallMovingAverage
if(BigMovingAverageArray[1]<SmallMovingAverageArray[2])

//if BigMovingAverage>SmallMovingAverage before
if(BigMovingAverageArray[2]>SmallMovingAverageArray[2])
{
   signal="sell";
}

//Sell 1 lot
if(signal=="sell" && PositionsTotal()<1)
  trade.Sell(1,NULL,Bid,0,(Bid-20*_Point),NULL);
  
//Buy 1 Lot
if(signal=="buy" && PositionsTotal()<1)
   trade.Buy(1,NULL,Ask,0,(As+20_Point),NULL); 

//Chart output
Comment("The signal is now:",signal);
  }