//+------------------------------------------------------------------+
//|                                                          TVP.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#undef UP
#undef DOWN
#undef FLAT

#define UP 1
#define DOWN 2
#define FLAT 3

#include <..\Experts\TrendPower\V2\BaseLine.mqh>
#include <..\Experts\TrendPower\V2\Exit.mqh>
#include <..\Experts\TrendPower\V2\Confirmation.mqh>
#include <..\Experts\TrendPower\V2\LastTradeDetails.mqh>



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MAIN
  {
private:
   BaseLine          *baseline;
   Confirmation      *confirmation;
   Exit              *exit;
   LastTradeDetails  *lastDetails;
   TradingFunctions  *TF;



public:
   string            SYMBOL;
   double            ATR_CURRENT;
                     MAIN(string symbol);
                    ~MAIN();
   void              Execute();

   void              Update_LastTradeTime();

   void              logdata(ulong ticket,double openPrice,ENUM_POSITION_TYPE posType,double lot,double atr,double baseline,double primary,double confirmation,double confirmation2,double exit,double sl,double tp);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MAIN::MAIN(string symbol)
  {
   SYMBOL=symbol;

   lastDetails=new LastTradeDetails(SYMBOL);
   baseline=new BaseLine(SYMBOL,TRADING_PERIOD);
   confirmation=new Confirmation(SYMBOL);
   exit=new Exit(SYMBOL,TRADING_PERIOD);


   double point = SymbolInfoDouble(SYMBOL, SYMBOL_POINT);
   TF=new TradingFunctions(SYMBOL,TRADING_PERIOD);


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MAIN::~MAIN()
  {

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MAIN::Execute()
  {
   lastDetails.Fetch();
   int baseline_direction = baseline.Execute();
   int confirmation_direction = confirmation.Execute(INTER_TRADE_PIPS,lastDetails.last);
   if(baseline_direction == UP)
     {
      if(confirmation_direction==UP)
        {
         if(lastDetails.last.PositionsOpen<MAX_TRADES)
           {
            if(lastDetails.last.buyTrades<MAX_BUY_TRADES)
              {
               int timeDiff=(int)(TimeCurrent()-lastDetails.last.openTime);
               if(timeDiff>INTER_TRADE_WAIT_SECONDS) // Inter-Trade Wait
                 {
                  //Trade Buy
                  SLTP data;
                  double SL = TF.setSLTP(UP).SL;
                  double TP = TF.setSLTP(UP).TP;
                  double ask = TF.setSLTP(UP).ask;
                  double bid = TF.setSLTP(UP).bid;
                  TF.tradeBuy(SL,0,TP,LOT);
                 }
              }
           }
        }
     }
   if(baseline_direction == DOWN)
     {
      if(confirmation_direction==DOWN)
        {
         if(lastDetails.last.PositionsOpen<MAX_TRADES)
           {
            if(lastDetails.last.buyTrades<MAX_SELL_TRADES)
              {
               int timeDiff=(int)(TimeCurrent()-lastDetails.last.openTime);
               if(timeDiff>INTER_TRADE_WAIT_SECONDS) // Inter-Trade Wait
                 {
                  //Trade Sell
                  SLTP data;

                  double SL = TF.setSLTP(DOWN).SL;
                  double TP = TF.setSLTP(DOWN).TP;
                  double ask = TF.setSLTP(DOWN).ask;
                  double bid = TF.setSLTP(DOWN).bid;
                  TF.tradeSell(SL,0,TP,LOT);
                 }
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
