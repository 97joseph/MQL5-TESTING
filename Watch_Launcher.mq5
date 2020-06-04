//+------------------------------------------------------------------+
//|                                        Market_Watch_Launcher.mq5 |
//|                                 Copyright 2020, Sir. Dev_spartah |
//|                                                254loop@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Sir. Dev_spartah"
#property link      "254loop@gmail.com"
#property script_show_inputs
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#property description " This script opens all market watch symbols with the default template"
#property  description "using the selected period. Save prefferred template as default.tpl to have all"
#property description " charts open with same template of your choice. Happy Trading."
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <Trade\SymbolInfo.mqh>
//---
input ENUM_TIMEFRAMES Time_frame = PERIOD_H1;
input double Max_spread         = 20;
CSymbolInfo    m_symbol;
string Pair;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
    {
//    loop through market watch and open symbols fitting specifications
     for(int i = SymbolsTotal(true) - 1; i >= 0; --i)
         {
          Pair = SymbolName(i, true);
          if(Pair == SymbolName(i, true))
              {
               if(m_symbol.Name(Pair))
                   {
                    if(m_symbol.Spread() < Max_spread)
                         ChartOpen(Pair, Time_frame);
                   }
              }
          if(i == 0)
              {
               ChartClose(0);
              }
         }
//---     The task was completed successfully.
//---     Close the script and print some info for the user
     Print("Task Complete. Closing.");
     return;
    }
//+------------------------------------------------------------------+
