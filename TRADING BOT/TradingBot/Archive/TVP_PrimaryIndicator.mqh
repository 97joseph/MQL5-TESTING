//+------------------------------------------------------------------+
//|                                         TVP_PrimaryIndicator.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#define SAR_STEP  0.02
#define SAR_MAX   0.2
#include <..\Experts\TrendPower\V1\TVP_Exit.mqh>
class TVP_PrimaryIndicator
  {
private:
TVP_Exit *exit;
string SYMBOL;
   ENUM_TIMEFRAMES TIMEFRAME;
   double point;
   int digits ;
   int PrimaryHandle;
   int PrimaryHandle2;
   int AD1, AH4,AH1,AM10,AM30,AM15,AM1;
   int SD1, SH4,SH1,SM10,SM30,SM15,SM1;
   bool BUY[10];
   bool SELL[10];
public:
   bool PRIMARY_BUY;
   bool PRIMARY_SELL;
   double PRIMARY_AROONUP;
   double PRIMARY_AROONDOWN;
   
                     TVP_PrimaryIndicator(string symbol, ENUM_TIMEFRAMES timeframe);
                    ~TVP_PrimaryIndicator();
                    void getPrimary(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TVP_PrimaryIndicator::TVP_PrimaryIndicator(string symbol, ENUM_TIMEFRAMES timeframe)
  {
      SYMBOL = symbol;
      TIMEFRAME = timeframe;
      point = SymbolInfoDouble(SYMBOL,SYMBOL_POINT);
      digits  = (int)SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS);
      //PrimaryHandle = iCustom(SYMBOL,TIMEFRAME,"trendpower",14);
      PrimaryHandle = iCustom(SYMBOL,TIMEFRAME,"Aroon_Up_Down",14);
      PrimaryHandle2 = iSAR(SYMBOL,TIMEFRAME,SAR_STEP, SAR_MAX);
      //AM1 = iCustom(SYMBOL,PERIOD_M1,"Aroon_Up_Down",14);
      AM10 = iCustom(SYMBOL,PERIOD_M10,"Aroon_Up_Down",14);
      //AM30 = iCustom(SYMBOL,PERIOD_M30,"Aroon_Up_Down",14);
      AH1 = iCustom(SYMBOL,PERIOD_H1,"Aroon_Up_Down",14);
      //AH4 = iCustom(SYMBOL,PERIOD_H4,"Aroon_Up_Down",14);
      AD1 = iCustom(SYMBOL,PERIOD_D1,"Aroon_Up_Down",14);
      
      //SM1 = iSAR(SYMBOL,PERIOD_M1,SAR_STEP, SAR_MAX);
      SM10 = iSAR(SYMBOL,PERIOD_M10,SAR_STEP, SAR_MAX);
      //SM30 = iSAR(SYMBOL,PERIOD_M30,SAR_STEP, SAR_MAX);
      SH1 = iSAR(SYMBOL,PERIOD_H1,SAR_STEP, SAR_MAX);
      //SH4 = iSAR(SYMBOL,PERIOD_H4,SAR_STEP, SAR_MAX);
      SD1 = iSAR(SYMBOL,PERIOD_D1,SAR_STEP, SAR_MAX);
      
      exit = new TVP_Exit(SYMBOL,TRADING_PERIOD);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TVP_PrimaryIndicator::~TVP_PrimaryIndicator()
  {
  }
//+------------------------------------------------------------------+
/*
void TVP_PrimaryIndicator::getPrimary(void)
  {
  
   double PrimaryBuy[];
   double PrimarySell[];
   
   PRIMARY_BUY = false;
   PRIMARY_SELL = false;

   
   ArraySetAsSeries(PrimaryBuy,true);
   ArraySetAsSeries(PrimarySell,true);
   
   CopyBuffer(PrimaryHandle,0,3,3,PrimaryBuy);
   CopyBuffer(PrimaryHandle,0,4,3,PrimarySell);
    
    
   double ask = SymbolInfoDouble(SYMBOL,SYMBOL_ASK);
   double bid = SymbolInfoDouble(SYMBOL,SYMBOL_BID);
   
   if(ask > PrimaryBuy[1]) PRIMARY_BUY =true;
   if(bid < PrimarySell[1]) PRIMARY_SELL =true;
   
  }

*/
void TVP_PrimaryIndicator::getPrimary(void)
  {
  
   double AroonUp[];
   double AroonDown[];
   double Sar[];
   
   //double aum1[];ArraySetAsSeries(aum1,true);CopyBuffer(AM1,0,0,3,aum1);
   double aum10[];ArraySetAsSeries(aum10,true);CopyBuffer(AM10,0,0,3,aum10);
   //double aum30[];ArraySetAsSeries(aum30,true);CopyBuffer(AM30,0,0,3,aum30);
   double auh1[];ArraySetAsSeries(auh1,true);CopyBuffer(AH1,0,0,3,auh1);
   //double auh4[];ArraySetAsSeries(auh4,true);CopyBuffer(AH4,0,0,3,auh4);
   double aud1[];ArraySetAsSeries(aud1,true);CopyBuffer(AD1,0,0,3,aud1);
   
   //double adm1[];ArraySetAsSeries(adm1,true);CopyBuffer(AM1,1,0,3,adm1);
   double adm10[];ArraySetAsSeries(adm10,true);CopyBuffer(AM10,1,0,3,adm10);
   //double adm30[];ArraySetAsSeries(adm30,true);CopyBuffer(AM30,1,0,3,adm30);
   double adh1[];ArraySetAsSeries(adh1,true);CopyBuffer(AH1,1,0,3,adh1);
   //double adh4[];ArraySetAsSeries(adh4,true);CopyBuffer(AH4,1,0,3,adh4);
   double add1[];ArraySetAsSeries(add1,true);CopyBuffer(AD1,1,0,3,add1);
   
   //double sm1[];ArraySetAsSeries(sm1,true);CopyBuffer(SM1,0,0,3,sm1);
   double sm10[];ArraySetAsSeries(sm10,true);CopyBuffer(SM10,0,0,3,sm10);
   //double sm30[];ArraySetAsSeries(sm30,true);CopyBuffer(SM30,0,0,3,sm30);
   double sh1[];ArraySetAsSeries(sh1,true);CopyBuffer(SH1,0,0,3,sh1);
   //double sh4[];ArraySetAsSeries(sh4,true);CopyBuffer(AH4,0,0,3,sh4);
   double sd1[];ArraySetAsSeries(sd1,true);CopyBuffer(SD1,0,0,3,sd1);
   for(int i = 0;i<10;i++) 
   {
      BUY[i]=false;
      SELL[i]=false;
   }
   //if(aum1[0] > adm1[0])  BUY[0] =true;if(aum1[0] < adm1[0])   SELL[0] =true;
   if(aum10[0] > adm10[0]) BUY[1] =true;if(aum10[0] < adm10[0])  SELL[1] =true;
   //if(aum30[0] > adm30[0]) BUY[2] =true;if(aum30[0] < adm30[0])  SELL[2] =true;
   if(auh1[0] > adh1[0])  BUY[3] =true;if(auh1[0] < adh1[0])   SELL[3] =true;
   //if(auh4[0] > adH4[0])  BUY[4] =true;if(auh4[0] < adh4[0])   SELL[4] =true;
   if(aud1[0] > add1[0])  BUY[5] =true;if(aud1[0] < add1[0])   SELL[5] =true;
   
   
   int buy = 0;
   int sell =0;
   for(int i = 0;i<6;i++) 
   {
      if(BUY[i]==true) buy++;
      if(SELL[i]==true) sell++;
      
   }
   
   double buy_strength_aroon = buy/3.0;
   double sell_strength_aroon = sell/3.0;
   
   for(int i = 0;i<10;i++) 
   {
      BUY[i]  = false;
      SELL[i] = false;
      
   }
   
   double ask = SymbolInfoDouble(SYMBOL,SYMBOL_ASK);
   double bid = SymbolInfoDouble(SYMBOL,SYMBOL_BID);
   
   //if(sm1[0] < ask)  BUY[0] =true;if(sm1[0] > bid)   SELL[0] =true;
   if(sm10[0] < ask) BUY[1] =true;if(sm10[0] > bid)  SELL[1] =true;
   //if(sm30[0] < ask) BUY[2] =true;if(sm1[0] > bid)  SELL[2] =true;
   if(sh1[0] < ask)  BUY[3] =true;if(sh1[0] > bid)   SELL[3] =true;
  // if(sh4[0] < ask)  BUY[4] =true;if(sm1[0] > bid)   SELL[4] =true;
   if(sd1[0] < ask)  BUY[5] =true;if(sd1[0] > bid)   SELL[5] =true;
   
   
   buy = 0;
   sell =0;
   for(int i = 0;i<6;i++) 
   {
      if(BUY[i]==true) buy++;
      if(SELL[i]==true) sell++;
      
   }
   
   double buy_strength_sar = buy/3.0;
   double sell_strength_sar = sell/3.0;
   
   if (buy>sell && buy_strength_aroon >=1)// && buy_strength_sar >=1) 
   {
      PRIMARY_BUY =true;
      //exit.Exit("SELL");
   }
   else 
   {
   //   PRIMARY_BUY =false;
   }
   if (buy<sell && sell_strength_aroon >=1)// && buy_strength_sar >=1)
   {
      PRIMARY_SELL =true;
      //exit.Exit("BUY");
   }
   else 
   {
 //     PRIMARY_SELL=false;
   } 
   /*
   PRIMARY_BUY = false;
   PRIMARY_SELL = false;

   
   ArraySetAsSeries(AroonUp,true);
   ArraySetAsSeries(AroonDown,true);
   ArraySetAsSeries(Sar,true);
   
   CopyBuffer(PrimaryHandle,0,0,3,AroonUp);
   CopyBuffer(PrimaryHandle,1,0,3,AroonDown);
   CopyBuffer(PrimaryHandle2,0,0,3,Sar);
   
   PRIMARY_AROONUP =  AroonUp[0];
   PRIMARY_AROONDOWN =  AroonDown[0];
    
    
   double ask = SymbolInfoDouble(SYMBOL,SYMBOL_ASK);
   double bid = SymbolInfoDouble(SYMBOL,SYMBOL_BID);
   
   double SAR = Sar[0];
   if(point==0) point  = SymbolInfoDouble(SYMBOL, SYMBOL_POINT);
   if(point==0) return;
   if(SAR ==0) return;
   double difSar = MathMin(MathAbs(ask -SAR),MathAbs(bid-SAR))/(point*10);
   
   if(difSar <20) return;
   
   if(AroonUp[0] > AroonDown[0]) PRIMARY_BUY =true;
   if(AroonDown[0] > AroonUp[0]) PRIMARY_SELL =true;
   if(SAR > ask) PRIMARY_BUY =false;
   if(bid > SAR) PRIMARY_SELL =false;
   
   if(difSar <20) return;
   */
  }
