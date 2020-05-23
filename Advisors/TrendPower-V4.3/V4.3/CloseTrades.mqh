//+------------------------------------------------------------------+
//|                                                  CloseTrades.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
class CloseTrades
  {
private:

public:
                     CloseTrades();
                    ~CloseTrades();
                    void singleTradeClose(ulong ticket)
                    void GlobalTradesClose()
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CloseTrades::CloseTrades()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CloseTrades::~CloseTrades()
  {
  }
//+------------------------------------------------------------------+
void CloseTrades::singleTradeClose(ulong ticket)
{
   
}

