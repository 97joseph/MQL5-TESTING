//+------------------------------------------------------------------+
//|                                                   Predictive.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <..\Experts\TrendPower\V4.3\TradingFunctions.mqh>
class BaseLine
  {
private:
   string            SYMBOL;
   ENUM_TIMEFRAMES   TIMEFRAME;
   TradingFunctions  *TF;
   double            point;
   int               digits;
   int               HandleBaseline;
   int               HandleHeiken;
public:
   double            last_ma_price;

                     BaseLine(string symbol,ENUM_TIMEFRAMES timeframe);
                    ~BaseLine();
   int               Execute();
   int               TrendPower();
   int               HeikenAshi();
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
   HandleHeiken=iCustom(SYMBOL,TIMEFRAME,"heiken_ashi");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BaseLine::~BaseLine()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int BaseLine::Execute()
  {
      int tp = TrendPower();
      int hk = HeikenAshi();
      if(tp==UP && hk == UP) return UP;
      if(tp==DOWN && hk == DOWN) return DOWN;
      return FLAT;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int BaseLine::HeikenAshi()
  {
      double Heiken[];
      ArraySetAsSeries(Heiken,true);
      CopyBuffer(HandleHeiken,4,0,4,Heiken);

   if(Heiken[1]==0 && Heiken[0]==0)
     {
      
      return UP;
     }
   if((int)Heiken[1]==1 && Heiken[0]==1)
     {
      
      return DOWN;
     }
   return FLAT;
   

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int BaseLine::TrendPower()
  {
   double Base[];

   ArraySetAsSeries(Base,true);
   CopyBuffer(HandleBaseline,0,0,3,Base);


   double Rates[];
   CopyClose(SYMBOL,TIMEFRAME,0,3,Rates);
   if(ArraySize(Rates)==0)
      return FLAT;
   double pipGap = MathAbs(Rates[1] - Base[1])/point/10;

   last_ma_price = Base[0];

   if(Rates[0] > Base[0] && pipGap >=TREND_POWER_REQUIRE_PIP_GAP)
      return  UP;
   if(Rates[0] < Base[0] && pipGap >=TREND_POWER_REQUIRE_PIP_GAP)
      return  DOWN;
   if(pipGap <TREND_POWER_REQUIRE_PIP_GAP)
      return  FLAT;

   return  FLAT;

  }

//+------------------------------------------------------------------+
