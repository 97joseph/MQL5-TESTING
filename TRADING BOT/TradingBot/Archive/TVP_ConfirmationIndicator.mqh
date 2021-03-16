//+------------------------------------------------------------------+
//|                                    TVP_ConfirmationIndicator.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <..\Experts\TrendPower\V1\Exit.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TVP_ConfirmationIndicator
  {
private:
   string            SYMBOL;
   ENUM_TIMEFRAMES   TIMEFRAME;
   double            point;
   int               digits;
   int               HandleSchafftrendcycle;
   int               HandleHeiken;
   int               HandleHeikenWk;
   int               HandleHeikenDy;
   int               HandleHeikenHr;

   int               HandleWilliamPercent;
   int               HandleKeltner;
   Exit         *exit;
   TradingFunctions *TF;
   int               PairPosition;

public:
   bool              CONFIRMATION_BUY;
   bool              CONFIRMATION_SELL;

   double            CONFIRMATION;

                     TVP_ConfirmationIndicator(string symbol,ENUM_TIMEFRAMES timeframe);
                    ~TVP_ConfirmationIndicator();
   void              getConfirmation(void);
   void              FillBarShape();

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TVP_ConfirmationIndicator::TVP_ConfirmationIndicator(string symbol,ENUM_TIMEFRAMES timeframe)
  {
   SYMBOL=symbol;
   TIMEFRAME=timeframe;

   exit=new Exit(SYMBOL,TRADING_PERIOD);

   point=SymbolInfoDouble(SYMBOL,SYMBOL_POINT);
   digits=(int)SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS);

   HandleSchafftrendcycle=iCustom(SYMBOL,TIMEFRAME,"schafftrendcycle",SCHAUFF_SMOOTH_METHOD,Schauff_Fast_MA,Schauff_Slow_MA,Schauff_MA_Smoothing,PRICE_CLOSE,Schauff_stochastic_period);
   HandleHeiken=iCustom(SYMBOL,TIMEFRAME,"heiken_ashi");

   HandleHeikenWk=iCustom(SYMBOL,PERIOD_W1,"heiken_ashi");
   HandleHeikenDy=iCustom(SYMBOL,PERIOD_D1,"heiken_ashi");
   HandleHeikenHr=iCustom(SYMBOL,PERIOD_H1,"heiken_ashi");


/*   
   HandleKeltner=iCustom(SYMBOL,TIMEFRAME,"keltner_channel",keltner_channel_PERIOD,Keltner_MA_Method,keltner_Ratio,PRICE_WEIGHTED,keltner_Horizontal_Shift);
   i=DATA.AddIndicator(PairPosition,"keltner");
   DATA.workbook.Pairs[PairPosition].indicators[i].handle=HandleKeltner;
*/
/* WILLIAM PERCENT
      HandleWilliamPercent = iWPR(SYMBOL,TIMEFRAME,26);
      i = DATA.AddIndicator(PairPosition,"WilliamPercent");
      DATA.workbook.Pairs[PairPosition].indicators[i].handle = HandleWilliamPercent;
      */

   TF=new TradingFunctions(SYMBOL,TIMEFRAME);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TVP_ConfirmationIndicator::~TVP_ConfirmationIndicator()
  {
  }
//+------------------------------------------------------------------+
void TVP_ConfirmationIndicator::getConfirmation(void)
  {

   CONFIRMATION_BUY  =false;
   CONFIRMATION_SELL =false;

   bool BARS_CONFIRMATION_BUY=false;
   bool BARS_CONFIRMATION_SELL=false;

   double Heiken[];
   ArraySetAsSeries(Heiken,true);
   CopyBuffer(HandleHeiken,4,0,30,Heiken);

   double HeikenWk[];
   ArraySetAsSeries(HeikenWk,true);
   CopyBuffer(HandleHeikenWk,4,0,30,HeikenWk);

   double HeikenDy[];
   ArraySetAsSeries(HeikenDy,true);
   CopyBuffer(HandleHeikenDy,4,0,30,HeikenDy);

   double HeikenHr[];
   ArraySetAsSeries(HeikenHr,true);
   CopyBuffer(HandleHeikenHr,4,0,30,HeikenHr);

   if((HeikenWk[1]==0) && (HeikenDy[1]==0) && (HeikenHr[1]==0)) CONFIRMATION_BUY=true;
   if((HeikenWk[1]==1) && (HeikenDy[1]==1) && (HeikenHr[1]==1)) CONFIRMATION_SELL=true;
return;
//if(Heiken[1] == 0) CONFIRMATION_BUY =true;
//if(Heiken[1] == 1) CONFIRMATION_SELL =true;



   FillBarShape();
   if(BARSHAPE[4]==0) //Current Uptrend
     {
      if((BARSHAPE[0]<BARSHAPE[2]) && (BARSHAPE[2]>=TREND_NUM_BARS) && (BARSHAPE[0]<=TREND_NUM_BARS)) BARS_CONFIRMATION_BUY=true;

     }
   else //Current DownTrend
     {
      if((BARSHAPE[0]<BARSHAPE[2]) && (BARSHAPE[2]>=TREND_NUM_BARS) && (BARSHAPE[0]<=TREND_NUM_BARS)) BARS_CONFIRMATION_SELL=true;

     }
   if(BARSHAPE[0]==1) //Exit Mini-Trend
     {
      if(BARSHAPE[4]==0) //Exit Short Trades
        {
         exit.Execute("SELL",true);
        }
      if(BARSHAPE[4]==1) //Exit Short Trades
        {
         exit.Execute("BUY",true);
        }
     }

   if(BARSHAPE[5]==0 && BARSHAPE[4]==0) //Exit Mini-Trend
     {
      exit.Execute("SELL",true);
     }
   if(BARSHAPE[5]==1 && BARSHAPE[4]==1) //Exit Mini-Trend
     {
      exit.Execute("BUY",true);
     }

//double Heiken[];
   ArraySetAsSeries(Heiken,true);
   CopyBuffer(HandleHeiken,1,0,4,Heiken);
   STATISTICS.sl_sell=Heiken[2];
   CopyBuffer(HandleHeiken,2,0,4,Heiken);
   STATISTICS.sl_buy=Heiken[2];

   CopyBuffer(HandleHeiken,4,0,4,Heiken);

/*
   if(Heiken[0]==1 && Heiken[1]==0)
     {
      //exit.Exit("BUY");
      STATISTICS.suspend_new=true;
      return;
     }

   if(Heiken[0]==0 && Heiken[1]==1)
     {
      //exit.Exit("SELL");
      STATISTICS.suspend_new=true;
      return;
     }
   */
   if((int)Heiken[1]==0 && BARS_CONFIRMATION_BUY)
     {
      STATISTICS.suspend_new=false;
      STATISTICS.suspend_buy=false;
      if((HeikenWk[1]==0) && (HeikenDy[1]==0) && (HeikenHr[1]==0)) CONFIRMATION_BUY=true;

      //CONFIRMATION_BUY  =true;
      CONFIRMATION_SELL=false;
      return;
     }
   if((int)Heiken[1]==1 && BARS_CONFIRMATION_SELL)
     {
      STATISTICS.suspend_new=false;
      STATISTICS.suspend_sell=false;
      CONFIRMATION_BUY=false;
      //CONFIRMATION_SELL =true;
      if((HeikenWk[1]==1) && (HeikenDy[1]==1) && (HeikenHr[1]==1)) CONFIRMATION_SELL=true;
      return;
     }

   return;

//-----Confirmation Schauffer
   CONFIRMATION_BUY  =false;
   CONFIRMATION_SELL =false;

   double Confirmation[];
   ArraySetAsSeries(Confirmation,true);
   CopyBuffer(HandleSchafftrendcycle,0,0,3,Confirmation);

   double confirmation_0 = Confirmation[0];
   double confirmation_1 = Confirmation[1];
   double confirmation_2=Confirmation[2];

   if(confirmation_1>20 && confirmation_1>confirmation_2) CONFIRMATION_BUY=true;
   if(confirmation_1<80 && confirmation_1<confirmation_2) CONFIRMATION_SELL=true;

//CONFIRMATION = Confirmation[0];
//if(Confirmation[1]>25 && Confirmation[2]<25) CONFIRMATION_BUY = true;
//if(Confirmation[1]>25 && Confirmation[2]<25) CONFIRMATION_BUY = true;


//if(Confirmation[1]>20 && Confirmation[1]>Confirmation[2]&& Heiken[0] == 0) CONFIRMATION_BUY = true;
//if(Confirmation[1]<80 && Confirmation[1]<Confirmation[2]&& Heiken[0] == 1) CONFIRMATION_SELL = true;


//Keltner Filter
   double Keltner[];
   double keltner_low;
   double keltner_high;

   ArraySetAsSeries(Keltner,true);

   CopyBuffer(HandleKeltner,0,0,4,Keltner);keltner_high= Keltner[1];
   CopyBuffer(HandleKeltner,2,0,4,Keltner);keltner_low = Keltner[1];

   MqlRates Rates[];
   CopyRates(SYMBOL,TIMEFRAME,0,3,Rates);

   if((Rates[1].close>keltner_high) || (Rates[1].close<keltner_low)) //Only trade within KELTNER Channel.
     {
      STATISTICS.suspend_new=true;
      CONFIRMATION_BUY=false;
      CONFIRMATION_SELL=false;
     }

  }
//+------------------------------------------------------------------+
void TVP_ConfirmationIndicator::FillBarShape()
  {
   double Heiken[];
   ArraySetAsSeries(Heiken,true);
   CopyBuffer(HandleHeiken,4,0,30,Heiken);

   BARSHAPE[0] = 0; //Initialize Current Uptrend Bars
   BARSHAPE[1] = 0; // Initialize Current Downtrend Bars
   BARSHAPE[2] = 0; // Initialize Previous Uptrend Bars
   BARSHAPE[3] = 0; // Intialize Previous Downtrend Bars
   BARSHAPE[4]=0;//Initialize Uptrend in past bar.
   BARSHAPE[5]=-1;//Initialize Uptrend in past bar.

   if(Heiken[1]==1) BARSHAPE[4]=1; //Downtrend in past bar
   int b=0; int target=BARSHAPE[4];
   for(int i=1;i<30;i++)
     {
      if(Heiken[i]==target){ BARSHAPE[b]++; continue;}
      target=1-target;
      b++;
      if(b==4) break;
      if(Heiken[i]==target){ BARSHAPE[b]++; continue;}

     }

   BARSHAPE[5]=(int)Heiken[1];//Initialize Uptrend in past bar.

  }
//+------------------------------------------------------------------+
