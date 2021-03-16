//+------------------------------------------------------------------+
//|                                                       TVP_V15.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

#include <..\Experts\TrendPower\V1\TVP_Orchestrator.mqh>
#include <..\Experts\TrendPower\V1\TVP_ScaleOut.mqh>
#include <..\Experts\TrendPower\V1\Logger.mqh>
#include <..\Experts\TrendPower\V1\Inputs.mqh>

string LOGFILE;
Logger *l;
datetime LastTrade[28];

Statistics STATISTICS;
PositionManagement POS_MANAGER[];
TVP_Orchestrator *tvp;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

//---
   Print("TERMINAL_PATH = ",TerminalInfoString(TERMINAL_PATH));
   Print("TERMINAL_DATA_PATH = ",TerminalInfoString(TERMINAL_DATA_PATH));
   Print("TERMINAL_COMMONDATA_PATH = ",TerminalInfoString(TERMINAL_COMMONDATA_PATH));
   START=TimeCurrent();

   LastTrade[1]=TimeCurrent()-86400*2;
   LastTrade[2]=TimeCurrent()-86400*2;
   LastTrade[3]=TimeCurrent()-86400*2;
   LastTrade[4]=TimeCurrent()-86400*2;
   LastTrade[5]=TimeCurrent()-86400*2;
   LastTrade[6]=TimeCurrent()-86400*2;
   LastTrade[7]=TimeCurrent()-86400*2;
   LastTrade[8]=TimeCurrent()-86400*2;
   LastTrade[9]=TimeCurrent()-86400*2;
   LastTrade[10]=TimeCurrent()-86400*2;
   LastTrade[11]=TimeCurrent()-86400*2;
   LastTrade[12]=TimeCurrent()-86400*2;
   LastTrade[13]=TimeCurrent()-86400*2;
   LastTrade[14]=TimeCurrent()-86400*2;
   LastTrade[15]=TimeCurrent()-86400*2;
   LastTrade[16]=TimeCurrent()-86400*2;
   LastTrade[17]=TimeCurrent()-86400*2;
   LastTrade[18]=TimeCurrent()-86400*2;
   LastTrade[19]=TimeCurrent()-86400*2;
   LastTrade[20]=TimeCurrent()-86400*2;
   LastTrade[21]=TimeCurrent()-86400*2;
   LastTrade[22]=TimeCurrent()-86400*2;
   LastTrade[23]=TimeCurrent()-86400*2;
   LastTrade[24]=TimeCurrent()-86400*2;
   LastTrade[25]=TimeCurrent()-86400*2;
   LastTrade[26]=TimeCurrent()-86400*2;
   LastTrade[27]=TimeCurrent()-86400*2;


   tvp=new TVP_Orchestrator();

   l=new Logger();
//lossCheck=new LossPerDay(SYMBOL,TRADING_PERIOD,START);
   LOGFILE=l.CreateLogFile();

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

//---DEBUGGING STOP-----
   datetime tStop=TimeCurrent();
   if(tStop>StringToTime("2019.01.03 01:03:00"))
     {
      tStop=tStop;
     }

//---
//fill Spreadsheet
//Multi Currency Orchestrator 
   tvp.Execute();

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  OnTradeTransaction(
                         const MqlTradeTransaction&    trans,        // trade transaction structure 
                         const MqlTradeRequest&        request,      // request structure 
                         const MqlTradeResult&         result        // result structure 
                         )
  {

//TVP_ScaleOut scaleOut(trans,request,result,TRADING_PERIOD);
//scaleOut = new TVP_ScaleOut(trans,request,result);
//delete scaleOut;

   double profit=0;
   if(HistoryDealSelect(result.deal))
     {
      profit=HistoryDealGetDouble((ulong)result.deal,DEAL_PROFIT);
     }

   ulong order=request.order;
   if(OrderSelect(order))
     {
      ENUM_ORDER_REASON reason=(ENUM_ORDER_REASON) OrderGetInteger(ORDER_REASON);

      if(reason==ORDER_REASON_SL || reason==ORDER_REASON_TP)
        {
         ENUM_POSITION_TYPE posType=POSITION_TYPE_BUY;
         ENUM_ORDER_TYPE typ=(ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
         if(typ==ORDER_TYPE_SELL) posType=POSITION_TYPE_SELL;

         logdata(
                 order,
                 OrderGetString(ORDER_SYMBOL),
                 OrderGetDouble(ORDER_PRICE_OPEN),
                 posType,
                 OrderGetDouble(ORDER_VOLUME_INITIAL),
                 0,0,0,0,0,0,
                 OrderGetDouble(ORDER_SL),
                 OrderGetDouble(ORDER_TP),
                 OrderGetDouble(ORDER_PRICE_CURRENT),
                 profit
                 );

        }

     }

  }
//+------------------------------------------------------------------+
void logdata(ulong ticket,string sym,double openPrice,ENUM_POSITION_TYPE posType,double lot,double atr,double baseline,double primary,double confirmation,double confirmation2,double exit,double sl,double tp,double closePrice,double profit)
  {

   l.LOGDATA.Sym=sym;
   l.LOGDATA.ticket=ticket;
   l.LOGDATA.openPrice=NormalizeDouble(openPrice,5);
   l.LOGDATA.posType=posType;
   l.LOGDATA.lot = lot;
   l.LOGDATA.atr = atr;
   l.LOGDATA.baseline= baseline;
   l.LOGDATA.primary = primary;
   l.LOGDATA.confirmation = confirmation;
   l.LOGDATA.cofirmation2 = confirmation2;
   l.LOGDATA.exit=exit;
   l.LOGDATA.sl = NormalizeDouble(sl,5);
   l.LOGDATA.tp = NormalizeDouble(tp,5);
   l.LOGDATA.closePrice=NormalizeDouble(closePrice,5);
   l.LOGDATA.profit=NormalizeDouble(profit,2);

   l.SaveData();

  }
//+------------------------------------------------------------------+
