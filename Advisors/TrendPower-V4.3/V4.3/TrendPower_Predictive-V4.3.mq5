//+------------------------------------------------------------------+
//|                                                       TVP_V4.35.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

#include <..\Experts\TrendPower\V4.3\Orchestrator.mqh>
Orchestrator *orchestrator;
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




   orchestrator=new Orchestrator();



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


   orchestrator.Execute();//Multi Currency Orchestrator

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
