//+------------------------------------------------------------------+
//|                                                          ATR.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
class ATR
  {
private:
   string            SYMBOL;
   ENUM_TIMEFRAMES   TIMEFRAME;
   int               PERIOD;
   double            point;
   int               digits;
   int               atrHandle;
public:
   double            aTR;
                     ATR(string symbol,ENUM_TIMEFRAMES timeframe,int period);
                    ~ATR();
   double            getATR();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ATR::ATR(string symbol,ENUM_TIMEFRAMES timeframe,int period)
  {
   SYMBOL=symbol;
   TIMEFRAME=timeframe;
   PERIOD= period;
   point = SymbolInfoDouble(SYMBOL,SYMBOL_POINT);
   digits=(int)SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS);
   atrHandle=iATR(SYMBOL,timeframe,period);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ATR::~ATR()
  {
  }
//+------------------------------------------------------------------+
double ATR::getATR()
  {

   double atr[];
   ArraySetAsSeries(atr,true);
   CopyBuffer(atrHandle,0,0,4,atr);

   aTR = atr[1];


   if(aTR <0.0001)
      aTR =0;

   return aTR;

  }
//+------------------------------------------------------------------+
