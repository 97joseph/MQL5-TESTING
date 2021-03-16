//+------------------------------------------------------------------+
//|                                                 TVP_BaseLine.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#include <..\Experts\TrendPower\V1\TradingFunctions.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TVP_BaseLine
  {
private:
   string            SYMBOL;
   ENUM_TIMEFRAMES   TIMEFRAME;
   double            point;
   int               digits;
   int               BaseLineHandle;
   int               VolatilityHandle;
   int               slopeHandle;
   int               emaHandle;
   int               HandleKeltner;
   
   TradingFunctions *TF;

   int               PairPosition;

public:
   bool              BASELINE_BUY;
   bool              BASELINE_SELL;
   double            BASELINE;

                     TVP_BaseLine(string symbol,ENUM_TIMEFRAMES timeframe);
                    ~TVP_BaseLine();
   void              getBaseLine();
   void              Exit(string type);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TVP_BaseLine::TVP_BaseLine(string symbol,ENUM_TIMEFRAMES timeframe)
  {
   SYMBOL=symbol;
   TIMEFRAME=timeframe;
   TF=new TradingFunctions(SYMBOL,TIMEFRAME);
   point=SymbolInfoDouble(SYMBOL,SYMBOL_POINT);
   digits=(int)SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS);



   /*BaseLineHandle=iCustom(SYMBOL,TIMEFRAME,"roc",ROC_PERIOD);
   int i=DATA.AddIndicator(PairPosition,"roc");
   DATA.workbook.Pairs[PairPosition].indicators[i].handle=BaseLineHandle;
   */
/* BOLLINGER BASELINE 
      VolatilityHandle = iBands(SYMBOL,TIMEFRAME,14,0,2,PRICE_CLOSE); 
      i = DATA.AddIndicator(PairPosition,"BollingerBands");
      DATA.workbook.Pairs[PairPosition].indicators[i].handle = VolatilityHandle;
      
  */     
   slopeHandle=iCustom(SYMBOL,SLOPE_TIMEFRAME,"LREG_Slope",SLOPE_PERIOD,PRICE_CLOSE);
   emaHandle = iMA(SYMBOL,SLOPE_TIMEFRAME,14,0,MODE_LWMA,PRICE_CLOSE);
   
   HandleKeltner=iCustom(SYMBOL,TIMEFRAME,"keltner_channel",keltner_channel_PERIOD,Keltner_MA_Method,keltner_Ratio,PRICE_WEIGHTED,keltner_Horizontal_Shift);
   
   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TVP_BaseLine::~TVP_BaseLine()
  {
  }
//+------------------------------------------------------------------+

void TVP_BaseLine::getBaseLine(void)
  {
      BASELINE_BUY = true;
      BASELINE_SELL = true;
      
      double SLOPE[];
      ArraySetAsSeries(SLOPE,true);
      CopyBuffer(slopeHandle,0,0,4,SLOPE);
      
      
   if(SLOPE[1] > -1*SLOPE_HYSTERISIS && SLOPE[1] < SLOPE_HYSTERISIS)
   {
      BASELINE_BUY = false;
      BASELINE_SELL = false;
      
   }


   if(SLOPE[1] > SLOPE[2])
   {
      
      BASELINE_SELL = false;
      
   }


   if(SLOPE[1] < SLOPE[2])
   {
      
      BASELINE_BUY = false;
      
   }
               
    return;
    
   
   //Exponential Moving Average
   double ema[];
   ArraySetAsSeries(ema,true);
   CopyBuffer(emaHandle,0,0,4,ema);
   
   //Keltner Channel
   double keltnerUpper[];
   double keltnerLower[];
   ArraySetAsSeries(keltnerUpper,true);
   ArraySetAsSeries(keltnerLower,true);
   CopyBuffer(HandleKeltner,0,0,4,keltnerUpper);
   CopyBuffer(HandleKeltner,2,0,4,keltnerLower);
   
   //Close Rates
   double close[];
   CopyClose(SYMBOL,SLOPE_TIMEFRAME,0,4,close);
   double bid = SymbolInfoDouble(SYMBOL, SYMBOL_BID);
   double ask = SymbolInfoDouble(SYMBOL, SYMBOL_ASK);
   
   if(close[1] > ema[1])
   {
      if(ask<keltnerUpper[0])
      {
         //BASELINE_BUY = true;
         BASELINE_SELL = false;
         return;
      }
   }
   
   if(close[1] < ema[1])
   {
      if(bid>keltnerLower[0])
      {
         //BASELINE_BUY = false;
         BASELINE_SELL = true;
         return;
      }
   }
   
   return;
   
   double volatilityUpper[];
   double volatilityLower[];
   double slope[];

   BASELINE_BUY=false;
   BASELINE_SELL=false;

   bool ROC_BASELINE_BUY=false;
   bool ROC_BASELINE_SELL=false;

   double hysterisis=0;
   switch(TIMEFRAME)
     {
      case PERIOD_D1:
         hysterisis= 0.5;
         break;
      case PERIOD_H1:
         hysterisis=0.2;
         break;
      case PERIOD_M1:
         hysterisis=0;
         break;

     }

// -----------------ROC Baseline ---------------------
/*
   int i=DATA.getIndicatorByName(PairPosition,"roc");
   double baseline_0 = DATA.workbook.Pairs[PairPosition].indicators[i].values[0];
   double baseline_1 = DATA.workbook.Pairs[PairPosition].indicators[i].values[1];

   if(baseline_1 > hysterisis )    {  ROC_BASELINE_BUY =true; DATA.workbook.Pairs[PairPosition].baseline.BASELINE_BUY =true;} //&& baseline_0 > baseline_1
   if(baseline_1 < -1*hysterisis)  {  ROC_BASELINE_SELL =true; DATA.workbook.Pairs[PairPosition].baseline.BASELINE_SELL =true;} // && baseline_0 < baseline_1
*/
//ArraySetAsSeries(BaseLine,true);
//CopyBuffer(BaseLineHandle,0,0,3,BaseLine);
//BASELINE = BaseLine[1];




//BASELINE_BUY = true;
//BASELINE_SELL =true;

// -----------SLOPE BASELINE -----------------
/*
   switch(TIMEFRAME)
     {
      case PERIOD_D1:
         hysterisis=50;
         break;
      case PERIOD_H1:
         hysterisis=20;
         break;
      case PERIOD_M1:
         hysterisis=10;
         break;

     }

   double slopeBuffer[];
   ArraySetAsSeries(slopeBuffer,true);
   CopyBuffer(slopeHandle,0,0,4,slopeBuffer);
   
   double baseline_0 = slopeBuffer[0];
   double baseline_1 = slopeBuffer[1];
   double baseline_2=  slopeBuffer[2];

//ArraySetAsSeries(slope,true);
//CopyBuffer(slopeHandle,0,0,3,slope);
   STATISTICS.slope=baseline_1;//slope[1];
   
   if(SLOPE_HYSTERISIS != -1) hysterisis = SLOPE_HYSTERISIS;

   if(baseline_1>-1*hysterisis && baseline_1<hysterisis)
     {
      
      BASELINE_BUY=false;
      BASELINE_SELL=false;
      //BASELINE_BUY =false;
      //BASELINE_SELL =false;
      STATISTICS.suspend_new=true;

      //BASELINE_BUY=DATA.workbook.Pairs[PairPosition].baseline.BASELINE_BUY;
      //BASELINE_SELL=DATA.workbook.Pairs[PairPosition].baseline.BASELINE_SELL;
      BASELINE=baseline_1;

      return;
     }
   if(baseline_1 >baseline_0)
   {
      BASELINE_BUY=false;
      STATISTICS.suspend_buy=true;
      BASELINE=baseline_1;
      
         BASELINE_BUY=false;
         BASELINE_SELL=true;
         STATISTICS.suspend_buy=true;
         STATISTICS.suspend_sell=false;

         BASELINE=baseline_1;
      
      
   
   }
   if(baseline_0 >baseline_1)
   {
      BASELINE_SELL=false;
      STATISTICS.suspend_sell=true;
      BASELINE=baseline_1;
      
         BASELINE_SELL=false;
         BASELINE_BUY =true;
         STATISTICS.suspend_sell=true;
         BASELINE=baseline_1;
   
   }
   return;
   if(ROC_BASELINE_BUY)
     {
      //if(baseline_0 >  baseline_1 && baseline_1 >  baseline_2) 
      if(baseline_1>hysterisis)
        {
            if(BASELINE_BUY){
         BASELINE_SELL=false;
         BASELINE_BUY =true;
         STATISTICS.suspend_sell=true;

         BASELINE=baseline_1;

         return;
            }

        }
      else
        {
         BASELINE_BUY=false;
         STATISTICS.suspend_buy=true;

        }
     }
   if(ROC_BASELINE_SELL)
     {
      //if(baseline_0 <  baseline_1 && baseline_1 <  baseline_2) 
      if(baseline_1<-1*hysterisis)
        {
         if(BASELINE_SELL){
         BASELINE_BUY=false;
         BASELINE_SELL=true;
         STATISTICS.suspend_buy=true;
         STATISTICS.suspend_sell=false;

         BASELINE=baseline_1;

         return;
         }

        }
      else
        {
         BASELINE_SELL=false;
         STATISTICS.suspend_sell=false;
        }
     }
   BASELINE=baseline_1;
   return;
   if(point==0) return;

   ArraySetAsSeries(volatilityLower,true);
   ArraySetAsSeries(volatilityUpper,true);

   CopyBuffer(VolatilityHandle,1,0,3,volatilityUpper);
   CopyBuffer(VolatilityHandle,2,0,3,volatilityLower);

   double upper = volatilityUpper[1];
   double lower = volatilityLower[1];
   double gap=(upper-lower)/point/10;

   STATISTICS.gap=gap;

   if(gap<40)
     {
      //BASELINE_BUY =false;
      //BASELINE_SELL =false;
      //STATISTICS.suspend_new=true;
     }

   if(BASELINE_BUY==true && STATISTICS.SellTrades>0)
     {
      //Exit("SELL");
      //STATISTICS.suspend_new =true;
     }
   if(BASELINE_SELL==true && STATISTICS.BuyTrades>0)
     {
      //Exit("BUY");
      //STATISTICS.suspend_new =true;
     }

   if(BASELINE_BUY==true && SYMBOL=="GBPNZD")
     {
      return;
     }


/*
   double ask = SymbolInfoDouble(SYMBOL,SYMBOL_ASK);
   double bid = SymbolInfoDouble(SYMBOL,SYMBOL_BID);
   
   MqlRates Rates[];
   CopyRates(SYMBOL,TIMEFRAME,0,3,Rates);
   
   
   if (ask ==0) return;
   if (bid ==0) return;
   if(point==0) return;
   if(Rates[1].close > 
   if((ask - BaseLine[0])/point/10 > 10) BASELINE_BUY = true;
   if((BaseLine[0] - bid)/point/10 > 10) BASELINE_SELL = true;
   BASELINE = BaseLine[0];
   */
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TVP_BaseLine::Exit(string type)
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
            TF.exitSingleTrade(-1,"BaseLine Buy Exit",ticket);
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
            TF.exitSingleTrade(-1,"BaseLine Sell Exit",ticket);
           }

        }
     }

  }
//+------------------------------------------------------------------+
