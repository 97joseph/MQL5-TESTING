//+------------------------------------------------------------------+
//|                                                   LossPerDay.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#define MAX_ALLOWED_LOSS -10
#define GAP_TO_NEXT_TRADE 1
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class LossPerDay
  {
private:
   string            SYMBOL;
   ENUM_TIMEFRAMES   TIMEFRAME;
   string            sYMBOL;
   ENUM_TIMEFRAMES   tIMEFRAME;
   datetime          START_DATE;
   int               supervision_window;

public:
   bool              ALLOW_BUY;
   bool              ALLOW_SELL;

                     LossPerDay(string symbol,ENUM_TIMEFRAMES timeframe,datetime startDate);
                    ~LossPerDay();
   bool              Execute();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LossPerDay::LossPerDay(string symbol,ENUM_TIMEFRAMES timeframe,datetime startDate)
  {
   int window=0;

   switch(timeframe)
     {
      case PERIOD_CURRENT:
         break;

      case PERIOD_M1:
         window=60;
         break;

      case PERIOD_M2:
         window=120;
         break;

      case PERIOD_M3:
         window=60*3;
         break;

      case PERIOD_M4:
         window=60*4;
         break;

      case PERIOD_M5:
         window=60*5;
         break;

      case PERIOD_M6:
         window=60*6;
         break;

      case PERIOD_M10:
         window=60*10;
         break;

      case PERIOD_M12:
         window=60*12;
         break;

      case PERIOD_M15:
         window=60*15;
         break;
      case PERIOD_M20:
         window=60*20;
         break;

      case PERIOD_M30:
         window=60*30;
         break;

      case PERIOD_H1:
         window=60*60*1;
         break;

      case PERIOD_H2:
         window=60*60*2;
         break;

      case PERIOD_H3:
         window=60*60*3;
         break;

      case PERIOD_H4:
         window=60*60*4;
         break;

      case PERIOD_H6:
         window=60*60*6;
         break;

      case PERIOD_H8:
         window=60*60*8;
         break;

      case PERIOD_H12:
         window=60*60*12;
         break;

      case PERIOD_D1:
         window=60*60*24*1;
         break;

      case PERIOD_W1:
         window=60*60*24*7;
         break;

      case PERIOD_MN1:
         window=60*60*24*30;
         break;
     }

   supervision_window=window*GAP_TO_NEXT_TRADE;
   START_DATE=startDate;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LossPerDay::~LossPerDay()
  {
  }
//+------------------------------------------------------------------+
bool LossPerDay::Execute()
  {
  
   ALLOW_BUY =true;
   ALLOW_SELL = true;
   datetime NOW=TimeCurrent();
   
   if(HistorySelect(START_DATE,NOW))
     {
      int t=HistoryDealsTotal();
      for(int i=t-1;i>=0;i--)
        {
         ulong deal_ticket=HistoryDealGetTicket(i);
         double volume=HistoryDealGetDouble(deal_ticket,DEAL_VOLUME);
         datetime transaction_time=(datetime)HistoryDealGetInteger(deal_ticket,DEAL_TIME);
         ulong order_ticket=HistoryDealGetInteger(deal_ticket,DEAL_ORDER);
         ENUM_DEAL_TYPE deal_type=(ENUM_DEAL_TYPE)HistoryDealGetInteger(deal_ticket,DEAL_TYPE);
         string symbol=                                        HistoryDealGetString(deal_ticket,DEAL_SYMBOL);
         double profit=                                       HistoryDealGetDouble(deal_ticket,DEAL_PROFIT);
         ulong position_ID=HistoryDealGetInteger(deal_ticket,DEAL_POSITION_ID);
         int timeElapsed=(int)(NOW-transaction_time);

         if(symbol==sYMBOL)
           {
            if((profit<=MAX_ALLOWED_LOSS) && (timeElapsed>supervision_window))
              {
               if(deal_type == DEAL_TYPE_BUY) ALLOW_SELL = false;
               if(deal_type == DEAL_TYPE_SELL) ALLOW_BUY  = false;
              }

           }

        }
     }

   return true;
  }
//+------------------------------------------------------------------+
