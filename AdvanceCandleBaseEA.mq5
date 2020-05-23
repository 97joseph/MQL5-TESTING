#include<Trade\Trade.mqh>

CTrade trade;

//Declaration of the input conditions

input int DirectionalPips=10;
input int TakeProfitPips=20;
input int StopLossPips=20;
input int SpreadCondition=20;
input int MaximumPostions=10;
input int PositionsToHold=10;
input int MaxBuyPositions=10;
input int MaxSellPositions=10;

void OnTick()
  {
  
  
  
  
  string Trend="";
  string signal="";
  
  double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
  double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
  double Spread = MarketInfo(Symbol(),MODE_SPREAD);
  
  
  //empty array for the prices
  MqlRates PriceInfo[];
  
  ArraySetAsSeries(PriceInfo,true);
  
  CopyRates(_Symbol,_Period,0,10,PriceInfo);
  
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
 if(PositionsTotal()<PositionsToHold)
 if(signal=="sell" && PositionsTotal()<MaxSellPositions)
 trade.Sell(0.10,NULL,Bid,(Bid+TakeProfitPips*_Point),(Bid-StopLossPips*_Point),NULL);
 
 if(PositionsTotal()<PositionsToHold)
 if(signal=="buy" && PositionsTotal()<MaxBuyPositions)
  trade.Buy(0.10,NULL,Ask,(Ask+TakeProfitPips*_Point),(Ask-StopLossPips*_Point),NULL);
     
  }
