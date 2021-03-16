//+------------------------------------------------------------------+
//|                                              PositionManager.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class PositionManager
  {
private:
int positions;

string SYMBOL;
public:
                     PositionManager(string symbol);
                    ~PositionManager();
                     void compact();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PositionManager::PositionManager(string symbol)
  {
   positions = PositionsTotal();
  
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PositionManager::~PositionManager()
  {
  }
//+------------------------------------------------------------------+
PositionManager::compact(void)
  {
      int t = PositionsTotal();
      {
         for(int i=t-1;i>=0;i--)
         {
         
         
            positions = 0;
         }
      
      }
  
  }
//+------------------------------------------------------------------+

PositionManager::compact(void)
  {
  }