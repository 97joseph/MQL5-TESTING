//+------------------------------------------------------------------+
//|                                                   Predictive.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <..\Experts\TrendPower\V1\TradingFunctions.mqh>
class BaseLine
  {
private:
   string            SYMBOL;
   ENUM_TIMEFRAMES   TIMEFRAME;
   TradingFunctions  *TF;
   double            point;
   int               digits;
   int               HandleBaseline;
public:
   
                     BaseLine(string symbol,ENUM_TIMEFRAMES timeframe);
                    ~BaseLine();
                    int Execute();
  };
//+----------------------------------------------------}--------------+
//|                                                                  |
//+------------------------------------------------------------------+
BaseLine::BaseLine(string symbol,ENUM_TIMEFRAMES timeframe)
  {
   SYMBOL=symbol;
   TIMEFRAME=timeframe;
   TF=new TradingFunctions(SYMBOL,TIMEFRAME);
   point=SymbolInfoDouble(SYMBOL,SYMBOL_POINT);
   digits=(int)SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS);
   HandleBaseline=iCustom(SYMBOL,TIMEFRAME,"trendpower",TREND_POWER_PERIOD_STEP,TREND_POWER_SMOOTHING_METHOD,TREND_POWER_PRICE_TYPE,TREND_POWER_HORIZONTAL_SHIFT);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BaseLine::~BaseLine()
{
}
int BaseLine::Execute()
  {
  
  double Base[];

   ArraySetAsSeries(Base,true);
   CopyBuffer(HandleBaseline,0,0,3,Base);


   double Rates[];
   CopyClose(SYMBOL,TIMEFRAME,0,3,Rates);
   
   double pipGap = MathAbs(Rates[1] - Base[1])/point/10;
   
   if (Rates[1] > Base[1] && pipGap >=TREND_POWER_REQUIRE_PIP_GAP) return  UP;
   if (Rates[1] < Base[1] && pipGap >=TREND_POWER_REQUIRE_PIP_GAP) return  DOWN;
   if ( pipGap <TREND_POWER_REQUIRE_PIP_GAP) return  FLAT;
   
   return  FLAT;
  
  }

//+------------------------------------------------------------------+
