//+------------------------------------------------------------------+
//|                                             GlobalTakeProfit.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <..\Experts\TrendPower\V4.3\TradingFunctions.mqh>

class GlobalTakeProfit
  {
private:
double gp;
TradingFunctions  *TF;
string SYMBOL;

public:
                     GlobalTakeProfit(string sym,double GlobalProfit);
                    ~GlobalTakeProfit();
                    void execute();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
GlobalTakeProfit::GlobalTakeProfit(string sym, double GlobalProfit)
  {
      gp = GlobalProfit;
      TF=new TradingFunctions(SYMBOL,TRADING_PERIOD);
      SYMBOL=sym;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
GlobalTakeProfit::~GlobalTakeProfit()
  {
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GlobalTakeProfit::execute()
  {

  }
//+------------------------------------------------------------------+
