//+------------------------------------------------------------------+
//|                                                 Confirmation.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <..\Experts\TrendPower\V4.3\TradingFunctions.mqh>

#undef UP
#undef DOWN
#undef FLAT

#define UP 1
#define DOWN 2
#define FLAT 3

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Confirmation
  {
private:
   string            SYMBOL;
   ENUM_TIMEFRAMES   TIMEFRAME;
   double            point;
   int               digits;
   double               GAP;

public:
   int               confirmation_direction;
   int               buyTrades;
   int               sellTrades;
   int               PositionsOpen;
                     Confirmation(string symbol);
                    ~Confirmation();
   int               Execute(int PIP_GAP,LastTrade &last, int direction=FLAT);
   int               Confirmation_with_direction(int PIP_GAP,LastTrade &last);
   int               Confirmation_no_direction(double PIP_GAP,LastTrade &last, int direction, double ma_price=0);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Confirmation::Confirmation(string symbol)
  {
   SYMBOL=symbol;

   point=SymbolInfoDouble(SYMBOL,SYMBOL_POINT);
   digits=(int)SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS);

   buyTrades=0;
   sellTrades=0;
   PositionsOpen=0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Confirmation::~Confirmation()
  {

  }
//+------------------------------------------------------------------+
int Confirmation::Execute(int PIP_GAP,LastTrade &last, int direction=FLAT)
  {
//Confirmation with Direction
//Confirmation_with_direction(PIP_GAP,&last);

//Confirmation No Direction.
   return Confirmation_no_direction( PIP_GAP, last,  direction);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Confirmation::Confirmation_with_direction(int PIP_GAP,LastTrade &last)
  {
   GAP = PIP_GAP;

   double Rates[];
   int c=0;
   double gap = 0;

   ArraySetAsSeries(Rates,true);
   CopyClose(SYMBOL,TRADING_PERIOD,0,3000,Rates);

   double price = (double)last.lastPrice;
   if(price <=0.001)
     {

      while(gap < PIP_GAP)
        {
         //Pick highest variation if check did not capture pips movement within required slabs.
         price = Rates[c];
         gap = MathAbs(Rates[0]- price)/point/10;
         c++;
        }
     }
   else
     {
      gap = MathAbs(Rates[0]- price)/point/10;
     }
   if(gap > PIP_GAP)
     {
      if(gap <TREND_POWER_MAX_PIP_GAP)
      {
         if(Rates[0]>price)
            return UP;
   
   
         if(Rates[0]<price)
            return DOWN;
      }
     }

   return FLAT;

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Confirmation::Confirmation_no_direction(double PIP_GAP,LastTrade &last, int direction, double ma_price=0)
  {
  int spread = (int)SymbolInfoInteger(SYMBOL, SYMBOL_SPREAD);
   GAP = PIP_GAP;

   double Rates[];
   int c=0;
   double gap = 0;

   ArraySetAsSeries(Rates,true);
   CopyClose(SYMBOL,TRADING_PERIOD,0,3000,Rates);
   if(ArraySize(Rates)==0) return FLAT; //No Rates Copied. Return Flat.
   
   double price = (double)ma_price;
   if(price <=0.001)
     {

      while(gap < PIP_GAP)
        {
         //Pick highest variation if check did not capture pips movement within required slabs.
         price = Rates[c];
         gap = MathAbs(Rates[0]- price)/point/10;
         c++;
        }
     }
   else
     {
      gap = MathAbs(Rates[0]- price)/point/10;
     }
   if(gap > PIP_GAP)
     {
      
      if(gap <TREND_POWER_MAX_PIP_GAP+spread)
      {
         return direction;
      }
     }

   return FLAT;

  }


//+------------------------------------------------------------------+
