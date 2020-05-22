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
  
  
  //I am trying to calculate the maximum allowed position size before opening a trade.
  /*
    // For now, let's go with 2%
      input double MAX_RISK_PERCENT_OF_TRADE = 2.0;

      // Capital at risk, in dollars
      double capitalAtRisk = AccountEquity() * ( MAX_RISK_PERCENT_OF_TRADE / 100 );
    
      // Deduct brokerage on the buy and sell
      // OANDA is purely spread, no fixed fee
      double maximumPermissibleRisk = capitalAtRisk - spreadCost;

      double lotSize = maximumPermissibleRisk / valuePerPip / stopLossPips;
  */
  
  string Trend="";
  string signal="";
  
  double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
  double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
  double Spread = MarketInfo(_Symbol , MODE_SPREAD);
  
  
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
 if(signal=="sell" && PositionsTotal()<MaximumPostions)
 trade.Sell(0.10,NULL,Bid,(Bid+TakeProfitPips*_Point),(Bid-StopLossPips*_Point),NULL);
 
 if(signal=="buy" && PositionsTotal()<MaximumPostions)
  trade.Buy(0.10,NULL,Ask,(Ask+TakeProfitPips*_Point),(Ask-StopLossPips*_Point),NULL);
     
  }
