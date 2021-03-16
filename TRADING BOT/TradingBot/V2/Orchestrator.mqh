//+------------------------------------------------------------------+
//|                                             Orchestrator.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <..\Experts\TrendPower\V2\MAIN.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Orchestrator
  {
private:
   MAIN              *main[27];
   int               SYMBOLS;
   string         PAIRS[];
   datetime       LastTrade[];
   
public:
                     Orchestrator();
                    ~Orchestrator();
                    int AddPair(string symbol);
   void              Execute();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Orchestrator::Execute()
  {
   
   for(int i=0;i<SYMBOLS;i++)
     {
      main[i].Execute();
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Orchestrator::Orchestrator()
  {

   int i=0;
   if(AUDCAD)  {i++;AddPair("AUDCAD");}
   if(AUDCHF)  {i++;AddPair("AUDCHF");}
   if(AUDJPY)  {i++;AddPair("AUDJPY");}
   if(AUDNZD)  {i++;AddPair("AUDNZD");}
   if(AUDUSD)  {i++;AddPair("AUDUSD");}
   if(CADCHF)  {i++;AddPair("CADCHF");}
   if(CADJPY)  {i++;AddPair("CADJPY");}
   if(CHFJPY)  {i++;AddPair("CHFJPY");}
   if(EURAUD)  {i++;AddPair("EURAUD");}
   if(EURCAD)  {i++;AddPair("EURCAD");}
   if(EURCHF)  {i++;AddPair("EURCHF");}
   if(EURGBP)  {i++;AddPair("EURGBP");}
   if(EURJPY)  {i++;AddPair("EURJPY");}
   if(EURNZD)  {i++;AddPair("EURNZD");}
   if(EURUSD)  {i++;AddPair("EURUSD");}
   if(GBPAUD)  {i++;AddPair("GBPAUD");}
   if(GBPCAD)  {i++;AddPair("GBPCAD");}
   if(GBPCHF)  {i++;AddPair("GBPCHF");}
   if(GBPJPY)  {i++;AddPair("GBPJPY");}
   if(GBPNZD)  {i++;AddPair("GBPNZD");}
   if(GBPUSD)  {i++;AddPair("GBPUSD");}
   if(NZDCHF)  {i++;AddPair("NZDCHF");}
   if(NZDJPY)  {i++;AddPair("NZDJPY");}
   if(NZDUSD)  {i++;AddPair("NZDUSD");}
   if(USDCAD)  {i++;AddPair("USDCAD");}
   if(USDCHF)  {i++;AddPair("USDCHF");}
   if(USDJPY)  {i++;AddPair("USDJPY");}

   SYMBOLS=i;


   i=0;
   for(i=0;i<SYMBOLS;i++)
     {
      string sym=PAIRS[i]; //Insert Symbols in Workbook
      main[i]=new MAIN(sym);

     }

     
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Orchestrator::~Orchestrator()
  {
  }
//+------------------------------------------------------------------+
int Orchestrator::AddPair(string symbol)
  {
      int size=ArraySize(PAIRS);
      ArrayResize(PAIRS,size+1);
      PAIRS[size]=symbol;
      return size;
  }