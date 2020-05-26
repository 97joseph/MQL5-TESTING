//+------------------------------------------------------------------+
//|                                                SimpleTrading.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//--- input parameters
input string   Trading_Ex="=====TRADINNG====";
input string   TradingDirection="Bidirectional";
input string   BidirectionalProfitTarget="Disabled";
input string   BuyGrid_Ex="====BUYGRID====";
input string   Behavior="Regular(close trade by trade)";
input string   Trades="_5_Trades";
input string   Spacing="_10_pips";
input double   LotSize=1.0;
input string   Phase="Default";
input int      TakeProfit=20;
input double   AnchorPrice=0.0;
input double   LimitPrice=0.0;
input string   SellGrid_Ex="====SELL GRID====";
input string   Behavior="Regular(close trade by trade)";
input string   Trades="_5_Trades";
input string   Spacing="_10_pips";
input double   LotSize=0.01;
input string   Phase="Default";
input double   AnchorPrice=0.0;
input double   LimitPrice=0.0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
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
   
  }
//+------------------------------------------------------------------+
