#include<Trade\Trade.mqh>

CTrade trade;

//Declaration of the input conditions

input int DirectionalPips=10;
input int TakeProfitPips=20;
input int StopLossPips=20;
input int SpreadCondition=20;
input int MaximumPostions=10;
input int PositionsToHold=10;

void OnTick()
  {
  
  string Trend="";
  string signal="";
  
  double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
  double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
  double Spread=Ask-Bid;
  
  //empty array for the prices
  MqlRates PriceInfo[];
  
  ArraySetAsSeries(PriceInfo,true);
  
  int PriceData=CopyRates(_Symbol,_Period,0,10,PriceInfo);
  
  //Declaration of end candle and startcandle
  //Status of the current to gauge the direction
  
   double Difference= PriceInfo[10].close- PriceInfo[1].close;


  //Trend direction According to the zero reference point
  if(Difference>0)
  Trend="Uptrend";
  if(Difference<0)
  Trend="Downtrend";
  
  if(Trend=="Uptrend" && Difference>=DirectionalPips*_Point)
  signal="buy";
  if(Trend=="Downtrend" && Difference<=DirectionalPips*_Point)
  signal="sell";
  
  
   //Sell and buy conditions met
 if(signal=="sell" && PositionsTotal()<1)
 trade.Sell(0.10,NULL,Bid,(Bid+TakeProfitPips*_Point),(Bid-StopLossPips*_Point),NULL);
 
 if(signal=="buy" && PositionsTotal()<1)
  trade.Buy(0.10,NULL,Ask,(Ask+TakeProfitPips*_Point),(Ask-StopLossPips*_Point),NULL);
     
  }
