//+------------------------------------------------------------------+
//|                                             LastTradeDetails.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <..\Experts\TrendPower\V4.3\Inputs.mqh>
class LastTradeDetails
  {
private:
   string            SYMBOL;
   ENUM_TIMEFRAMES   TIMEFRAME;
public:

   LastTrade         last;
                     LastTradeDetails(string symbol);
                    ~LastTradeDetails();
                 double Fetch();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LastTradeDetails::LastTradeDetails(string symbol)
  {
   SYMBOL=symbol;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LastTradeDetails::~LastTradeDetails()
  {
  }
//+------------------------------------------------------------------+
double LastTradeDetails::Fetch()
  {

   double price =0;
   bool gotPrice=false;
   int t=PositionsTotal();
   last.lastPrice=0; //Reset last price to zero
   
   //Reset trade counters to zero
   last.PositionsOpen=0;
   last.buyTrades=0;
   last.sellTrades=0;
   last.openTime =0;
   
   for(int i=t-1; i>=0; i--)
     {
      ulong ticket =PositionGetTicket(i);
      string Sym = PositionGetString(POSITION_SYMBOL);
      if(Sym==SYMBOL)
        {
         last.PositionsOpen++;//Increment Positions Open counter

         ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE) PositionGetInteger(POSITION_TYPE);
         if(type == POSITION_TYPE_BUY) last.buyTrades++;
         if(type == POSITION_TYPE_SELL) last.sellTrades++;
         if(gotPrice==false)
           {
            last.lastPrice = PositionGetDouble(POSITION_PRICE_OPEN);
             last.ticket = PositionGetInteger(POSITION_TICKET);
             last.type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
             last.openTime = (datetime)PositionGetInteger(POSITION_TIME);
             last.lotsize =PositionGetDouble(POSITION_VOLUME);
             gotPrice=true;
           }

         if(type==POSITION_TYPE_BUY)
            last.buyTrades++;//Increment Buy Trades counter

         if(t==POSITION_TYPE_SELL)
            last.sellTrades++; //Increment Sell Trades counter
        }
     }

   return last.lastPrice;
  }
//+------------------------------------------------------------------+
