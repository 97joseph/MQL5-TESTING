//+------------------------------------------------------------------+
//|                                                   Predictive.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <..\Experts\TrendPower\V1\TradingFunctions.mqh>
class Predictive
  {
private:
   string            SYMBOL;
   ENUM_TIMEFRAMES   TIMEFRAME;
   TradingFunctions *TF;
   double            point;
   int               digits;
public:
                     Predictive(string symbol,ENUM_TIMEFRAMES timeframe);
                    ~Predictive();
  };
//+----------------------------------------------------}--------------+
//|                                                                  |
//+------------------------------------------------------------------+
Predictive::Predictive(string symbol,ENUM_TIMEFRAMES timeframe)
  {
   SYMBOL=symbol;
   TIMEFRAME=timeframe;
   TF=new TradingFunctions(SYMBOL,TIMEFRAME);
   point=SymbolInfoDouble(SYMBOL,SYMBOL_POINT);
   digits=(int)SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Predictive::~Predictive()
  {
  }

