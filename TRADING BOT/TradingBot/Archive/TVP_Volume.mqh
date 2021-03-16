//+------------------------------------------------------------------+
//|                                                   TVP_Volume.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <..\Experts\TrendPower\V1\TradingFunctions.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TVP_Volume
  {
private:
   string            SYMBOL;
   ENUM_TIMEFRAMES   TIMEFRAME;
   double            point;
   int               digits;
   int               VolumeHandle;
   int               adHandle;
   TradingFunctions *TF;

public:
   bool              VOLUME;

                     TVP_Volume(string symbol,ENUM_TIMEFRAMES timeframe);
                    ~TVP_Volume();
   bool              getVolume(void);
   void              Exit(string type);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TVP_Volume::TVP_Volume(string symbol,ENUM_TIMEFRAMES timeframe)
  {
   SYMBOL=symbol;
   TIMEFRAME=timeframe;
   TF=new TradingFunctions(SYMBOL,TIMEFRAME);
   point=SymbolInfoDouble(SYMBOL,SYMBOL_POINT);
   digits=(int)SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS);
   VolumeHandle=iBWMFI(SYMBOL,TIMEFRAME,VOLUME_TICK);
   adHandle=iAD(SYMBOL,TIMEFRAME,VOLUME_TICK);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TVP_Volume::~TVP_Volume()
  {
  }
//+------------------------------------------------------------------+
bool TVP_Volume::getVolume(void)
  {

   double Volume[];
   double AD[];

   ArraySetAsSeries(Volume,true);
   CopyBuffer(VolumeHandle,0,0,3,Volume);

   ArraySetAsSeries(AD,true);
   CopyBuffer(adHandle,0,0,3,AD);

   if(AD[0]<AD[1] || AD[1]<AD[2])
      STATISTICS.suspend_buy=true;

   if(AD[0]>AD[1] || AD[1]>AD[2])
      STATISTICS.suspend_sell=true;

   if((AD[0]-AD[1])>3000 && (AD[1]-AD[2])>3000 && STATISTICS.SellTrades>0)
     {
      //Exit("SELL");
      STATISTICS.suspend_sell=true;

     }
   if((AD[1]-AD[0])>3000 && (AD[2]-AD[1])>3000 && STATISTICS.BuyTrades>0)
     {

      //Exit("BUY");
      STATISTICS.suspend_buy=true;

     }
   double vol=Volume[0];
   if(vol<0.0001) VOLUME=false;
   if(vol>VOLUME_TARGET) VOLUME=true;
   return VOLUME;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TVP_Volume::Exit(string type)
  {

   if(type=="BUY")
     {
      int total=PositionsTotal();

      for(int i=total-1; i>=0; i--)
        {
         //ulong ticket =buyTrades[i];
         ulong ticket=PositionGetTicket(i);
         double profit=PositionGetDouble(POSITION_PROFIT);
         string sym=PositionGetString(POSITION_SYMBOL);
         ENUM_POSITION_TYPE posType=(ENUM_POSITION_TYPE) PositionGetInteger(POSITION_TYPE);
         if(posType==POSITION_TYPE_BUY && sym==SYMBOL)
           {

            //if(profit >0)
            TF.exitSingleTrade(-1,"Volume Triggered BUY Exit",ticket);
           }
        }
     }
   if(type=="SELL")
     {
      int total= PositionsTotal();
      for(int i=total-1; i>=0; i--)
        {
         //ulong ticket =//sellTrades[i];

         ulong ticket=PositionGetTicket(i);
         double profit=PositionGetDouble(POSITION_PROFIT);
         string sym=PositionGetString(POSITION_SYMBOL);
         ENUM_POSITION_TYPE posType=(ENUM_POSITION_TYPE) PositionGetInteger(POSITION_TYPE);
         if(posType==POSITION_TYPE_SELL && sym==SYMBOL)
           {

            //if(profit >0)
            TF.exitSingleTrade(-1,"Volume Triggered SELL Exit",ticket);
           }

        }
     }

  }
//+------------------------------------------------------------------+
