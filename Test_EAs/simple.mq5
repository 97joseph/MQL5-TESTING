//Condtions of the EA
//The idea is to buy 0.01 lots at the current price
//Once the price increases by say 46 points the deal is crossed with a profit
//The repeat etc
//But if the price goes in the wrong direction say 31 points the deal is closed (but with a loss) and a sell deal is opened
//After the price makes 46 points down ,close with a profit or if it goes 31 up ,close with a negative result

#include <Trade\Trade.mqh>
//--- input parameters
input double   Lot=0.1; // Lots
input int      TP=46;   // Take Profit
input int      SL=31;   // Stop Loss

CTrade trade;
bool   bs=true; //true-buy  false-sell
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   double pr=0;
   if(!PositionSelect(_Symbol)) //no position
     {
      if(bs) trade.Buy(Lot);
      else   trade.Sell(Lot);
     }
   else // there is a position
     {
      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
        {
         pr=(SymbolInfoDouble(_Symbol,SYMBOL_BID)-PositionGetDouble(POSITION_PRICE_OPEN))/_Point;
         if(pr>=TP)
           {
            trade.PositionClose(_Symbol);
            bs=true;//buy
           }
         if(pr<=-SL)
           {
            trade.PositionClose(_Symbol);
            bs=false;//sell
           }
        }
      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
        {
         pr=(PositionGetDouble(POSITION_PRICE_OPEN)-SymbolInfoDouble(_Symbol,SYMBOL_ASK))/_Point;
         if(pr>=TP)
           {
            trade.PositionClose(_Symbol);
            bs=false;//sell
           }
         if(pr<=-SL)
           {
            trade.PositionClose(_Symbol);
            bs=true;//buy
           }
        }
     }
  }
//+------------------------------------------------------------------+
