//+------------------------------------------------------------------+
//|                                             TradingFunctions.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#undef UP
#undef DOWN
#undef FLAT

#define UP 1
#define DOWN 2
#define FLAT 3

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <..\Experts\TrendPower\V4.3\Inputs.mqh>
#include<Trade\Trade.mqh>



#define GTP 50000
#define PTP 50000
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TradingFunctions
  {
private:
   string            SYMBOL;
   ENUM_TIMEFRAMES   TIMEFRAME;
   double            point;
   int               digits;
   CTrade            ct;


public:
   Statistics        STATISTICS;
   double            ATR_CURRENT;
   ulong             lastTicket;


                     TradingFunctions(string symbol,ENUM_TIMEFRAMES timeframe);
                    ~TradingFunctions();
   void              Statistics();

   void              tradeBuy(double SL,int magic,double TP,double LOTSIZE,double atr=NULL);
   void              tradeSell(double SL,int magic,double TP,double LOTSIZE=NULL,double atr=NULL);
   void              tradeExit();
   void              Exit(string type,string reason);

   void              exitSingleTrade(int pos,string reason,ulong ticket=NULL);
   void              trailing_StopLossOld();
   void              trailing_StopLoss();
   bool              updateSL(ulong tkt,double SL,string exit_type=NULL);
   double            getSL(ENUM_POSITION_TYPE direction);
   double            getSL3BARS(ENUM_POSITION_TYPE direction);
   void              GlobalExit(bool EquityTake=false);
   void              GlobalTake(double profit);
   void              logdata(ulong ticket,double openPrice,ENUM_POSITION_TYPE posType,double lot,double atr,double baseline,double primary,double confirmation,double confirmation2,double exit,double sl,double tp);

   void              GlobalCloseAllPositionsNew(string reason);
   void              GlobalTakeProfit(double effectiveATR);
   void              ScaleOut();
   void              GlobalReducePositions(double effectiveATR);
   //void              GlobalPairTakeProfit(double effectiveATR);
   void              GlobalStopLoss(double effectiveATR);
   void              GlobalPositiveTakeProfit(double effectiveATR);
   void              Update_LastTradeTime();
   datetime          Get_LastTradeTime();
   SLTP              setSLTP(int direction,double atr);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TradingFunctions::TradingFunctions(string symbol,ENUM_TIMEFRAMES timeframe)
  {
   SYMBOL=symbol;
   TIMEFRAME=timeframe;
   point=SymbolInfoDouble(SYMBOL,SYMBOL_POINT);
   digits=(int)SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TradingFunctions::~TradingFunctions()
  {
  }
//+------------------------------------------------------------------+
void TradingFunctions::tradeBuy(double SL,int magic,double TP,double LOTSIZE,double atr=NULL)
  {

   MqlTradeRequest request;
   MqlTradeResult  result;

//--- zeroing the request and result values
   ZeroMemory(request);
   ZeroMemory(result);

//double price;                                                       // order triggering price

   digits=(int)SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS);                // number of decimal places (precision)

//--- parameters to place a pending order
   request.action=TRADE_ACTION_DEAL;                             // type of trade operation
   request.symbol=SYMBOL;                                         // symbol
   request.volume=LOTSIZE;                                              // volume of 0.1 lot
   request.deviation=2;
   request.magic=magic;
   request.type=ORDER_TYPE_BUY;                                // order type
   request.comment = "A:" +DoubleToString(NormalizeDouble(atr,5));  //Original Trade Entry ATR
   double price=SymbolInfoDouble(SYMBOL,SYMBOL_ASK); // price for opening
//request.comment = NormalizeDouble(price,digits);                      // normalized opening price
   request.price=NormalizeDouble(price,digits);                      // normalized opening price
   request.sl=SL; //Stop Loss
   if(TP>0)
      request.tp=TP; //Take Profit
//double slPrice = NormalizeDouble(price - ATR_VAL*1.5,digits);
//request.sl = slPrice;

//double tpPrice = NormalizeDouble(price + ATR_VAL*0.8*RISK_REWARD,digits);
//request.tp = tpPrice;

//--- send the request
   if(!OrderSend(request,result))
     {
      PrintFormat("OrderSend error %d",GetLastError());                 // if unable to send the request, output the error code
     }
   else
     {
      //--- information about the operation
      double a=atr;
      PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
      lastTicket=result.order;
     }
//log

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradingFunctions::tradeSell(double SL,int magic,double TP,double LOTSIZE,double atr=NULL)
  {

   MqlTradeRequest request;
   MqlTradeResult  result;

//--- zeroing the request and result values
   ZeroMemory(request);
   ZeroMemory(result);

//double price;                                                       // order triggering price

   digits=(int)SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS);                // number of decimal places (precision)

//--- parameters to place a pending order
   request.action=TRADE_ACTION_DEAL;                             // type of trade operation
   request.symbol=SYMBOL;                                         // symbol
   request.volume=LOTSIZE;                                              // volume of 0.1 lot
   request.deviation=2;
   request.magic=magic;
   request.type=ORDER_TYPE_SELL;                                // order type
   request.comment = "A:"+DoubleToString(NormalizeDouble(atr,5));  //Original Trade Entry ATR
   double price=SymbolInfoDouble(SYMBOL,SYMBOL_BID); // price for opening
//request.comment =   NormalizeDouble(price,digits);                      // normalized opening price
   request.price=NormalizeDouble(price,digits);                      // normalized opening price
   request.sl=SL; //Stop Loss
   if(TP>0)
      request.tp=TP;
//double slPrice = NormalizeDouble(price - ATR_VAL*1.5,digits);
//request.sl = slPrice;

//double tpPrice = NormalizeDouble(price + ATR_VAL*0.8*RISK_REWARD,digits);
//request.tp = tpPrice;

//--- send the request
   if(!OrderSend(request,result))
     {
      PrintFormat("OrderSend error %d",GetLastError());                 // if unable to send the request, output the error code
     }
   else
     {
      //--- information about the operation
      double a=atr;
      PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
      lastTicket=result.order;
     }
//Log

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradingFunctions::tradeExit()
  {

   int t=PositionsTotal();
   for(int i=t-1; i>=0; i--)
     {

      exitSingleTrade(i,"");

     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradingFunctions::exitSingleTrade(int pos,string reason,ulong ticket=NULL)
  {
   ulong  position_ticket=0;
//return;
   bool bypass=true;
   if(ticket==0)
     {
      position_ticket=PositionGetTicket(pos);
     }
   else
     {
      bypass=false;
      position_ticket=ticket;
      PositionSelectByTicket(ticket);

     }
   double open_price=PositionGetDouble(POSITION_PRICE_OPEN);
   double volume=PositionGetDouble(POSITION_VOLUME);

   string sym=PositionGetString(POSITION_SYMBOL);
   ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);    // type of the position
   double profit=PositionGetDouble(POSITION_PROFIT);
   double sl = PositionGetDouble(POSITION_SL);
   double tp = PositionGetDouble(POSITION_TP);
   int magic=(int)PositionGetInteger(POSITION_MAGIC);

   MqlTradeRequest request;
   MqlTradeResult  result;
//--- parameters of the order

//--- zeroing the request and result values
   ZeroMemory(request);
   ZeroMemory(result);
//--- setting the operation parameters

   request.action   =TRADE_ACTION_DEAL;        // type of trade operation
   request.position =position_ticket;          // ticket of the position
   request.symbol=sym;          // symbol
   request.volume   =volume;                   // volume of the position
   request.deviation=5;                        // allowed deviation from the price
   request.comment  = (string) reason;
   double closePrice= 0;
   if(type==POSITION_TYPE_BUY)
     {
      request.price=SymbolInfoDouble(sym,SYMBOL_BID);
      closePrice=request.price;
      request.type=ORDER_TYPE_SELL;
     }
   else
     {
      request.price=SymbolInfoDouble(sym,SYMBOL_ASK);
      closePrice=request.price;
      request.type=ORDER_TYPE_BUY;
     }

   if(OrderSend(request,result))
     {
      PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
      lastTicket=result.order;



     }
   else
     {
      PrintFormat("OrderSend error %d",GetLastError());  // if unable to send the request, output the error code

     }
//Log

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradingFunctions::trailing_StopLoss()
  {
   int t=PositionsTotal();
   if(t>0)
     {
      for(int i=t-1; i>=0; i--)
        {
         ulong ticket=PositionGetTicket(i);
         ENUM_POSITION_TYPE posType=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         string symbol=PositionGetString(POSITION_SYMBOL);
         if(symbol!=SYMBOL)
            continue;

         double curTP=PositionGetDouble(POSITION_TP);
         //if(curTP >0) continue;

         int spread=(int) SymbolInfoInteger(SYMBOL,SYMBOL_SPREAD);

         if(posType==POSITION_TYPE_BUY)
           {
            double curSL=PositionGetDouble(POSITION_SL);
            //double sl = STATISTICS.sl_buy;
            double sl=getSL(posType);
            if(sl<=curSL)
               continue;
            ct.PositionModify(ticket,sl,curTP);
            /*
                        MqlRates rates[];

                        if(CopyRates(symbol,ATR_TIMEFRAME,0,3,rates) ==-1) continue;
                        point = SymbolInfoDouble(symbol,SYMBOL_POINT);
                        //sl = rates[2].low;

                        double diff = (rates[0].low - rates[2].low)/point/10;
                        //if(diff <spread) continue;

                        */

            //updateSL(ticket,sl);

           }

         if(posType==POSITION_TYPE_SELL)
           {
            double curSL=PositionGetDouble(POSITION_SL);
            //double sl = STATISTICS.sl_sell;
            double sl=getSL(posType);
            if(sl>=curSL)
               continue;
            ct.PositionModify(ticket,sl,curTP);
            /*
                        MqlRates rates[];

                        if(CopyRates(symbol,ATR_TIMEFRAME,0,3,rates) ==-1) continue;
                        point = SymbolInfoDouble(symbol,SYMBOL_POINT);
                        //sl = rates[2].high;

                           double diff = (rates[0].low - rates[2].low)/point/10;

                        */

            //updateSL(ticket,sl);

           }

         //double sl = getSL3BARS(posType);

        }
     }
   point=SymbolInfoDouble(SYMBOL,SYMBOL_POINT);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradingFunctions::trailing_StopLossOld()
  {
   return;
   int t=PositionsTotal();
   if(t>0)
     {
      for(int i=t-1; i>=0; i--)
        {
         ulong ticket=PositionGetTicket(i);

         ENUM_POSITION_TYPE posType=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         string symbol=PositionGetString(POSITION_SYMBOL);
         if(symbol!=SYMBOL)
            continue;
         double curSL = PositionGetDouble(POSITION_SL);
         double curTP = PositionGetDouble(POSITION_TP);
         if(curTP>0)
            continue;

         double priceOpen=PositionGetDouble(POSITION_PRICE_OPEN);
         double sl=getSL3BARS(posType);
         double deltaSL=0;
         if(posType==POSITION_TYPE_BUY)
           {
            double ask = SymbolInfoDouble(SYMBOL,SYMBOL_ASK);
            double bid = SymbolInfoDouble(SYMBOL,SYMBOL_BID);


            double diff= MathAbs(sl-curSL)/point/10;
            int spread =(int)SymbolInfoInteger(SYMBOL,SYMBOL_SPREAD);
            if(diff<spread)
               continue;

            diff=(ask-sl)/point/10;
            double diff2=MathAbs(bid-sl)/point/10;
            spread=(int)SymbolInfoInteger(SYMBOL,SYMBOL_SPREAD);
            if(diff<spread)
               continue;
            if(diff2<spread)
               continue;

            updateSL(ticket,sl);

           }
         if(posType==POSITION_TYPE_SELL)
           {
            double ask = SymbolInfoDouble(SYMBOL,SYMBOL_ASK);
            double bid = SymbolInfoDouble(SYMBOL,SYMBOL_BID);


            double diff= MathAbs(sl-curSL)/point/10;
            int spread =(int)SymbolInfoInteger(SYMBOL,SYMBOL_SPREAD);
            if(diff<spread)
               continue;

            diff=(sl-ask)/point/10;
            double diff2=MathAbs(sl-bid)/point/10;
            spread=(int)SymbolInfoInteger(SYMBOL,SYMBOL_SPREAD);
            if(diff<spread)
               continue;
            if(diff2<spread)
               continue;

            updateSL(ticket,sl);
            //  }
           }

        }

     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TradingFunctions::updateSL(ulong tkt,double SL,string exit_type=NULL)
  {
   ulong ticket=PositionSelectByTicket(tkt);
   ENUM_POSITION_TYPE direction=(ENUM_POSITION_TYPE) PositionGetInteger(POSITION_TYPE);
   double price=PositionGetDouble(POSITION_PRICE_CURRENT);
   double TP=PositionGetDouble(POSITION_TP);
   double lot= PositionGetDouble(POSITION_VOLUME);
   double sl = SL;
   if(exit_type=="EMERGENCY_EXIT")
     {
      MqlRates rates[];
      ArraySetAsSeries(rates,true);
      int copied=CopyRates(SYMBOL,TIMEFRAME,0,5,rates);
      double threeBarsAgo=rates[2].close;
      double diff=MathAbs(threeBarsAgo-price);

      if(direction == POSITION_TYPE_BUY)
         sl = price - diff;
      if(direction == POSITION_TYPE_SELL)
         sl = price + diff;

     }

   MqlTradeRequest request;
   MqlTradeResult  result;

//--- zeroing the request and result values
   ZeroMemory(request);
   ZeroMemory(result);

//double price;                                                       // order triggering price

   digits=(int)SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS);                // number of decimal places (precision)

//--- parameters to place a pending order
   request.action=TRADE_ACTION_SLTP; // type of trade operation
   request.position=tkt;   // ticket of the position
   request.symbol=SYMBOL;     // symbol
   request.sl=sl;                // Stop Loss of the position
   request.tp= TP;

//--- output information about the modification
   PrintFormat("Modify #%I64d %s %s",ticket,ticket,EnumToString(direction));
//--- send the request
   if(!OrderSend(request,result))
     {
      PrintFormat("OrderSend error %d",GetLastError());  // if unable to send the request, output the error code
      return false;
     }
//--- information about the operation
   PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
   logdata(tkt,price,direction,lot,0,0,0,0,0,0,sl,TP);
   return true;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*double TradingFunctions::getSL(ENUM_POSITION_TYPE direction)
  {

   if(ATR_CURRENT==0) return 0; //Refresh ATR;
   if(direction==POSITION_TYPE_BUY)
     {
      double ask=SymbolInfoDouble(SYMBOL,SYMBOL_ASK);
      return NormalizeDouble(ask - ATR_CURRENT*ATR_SL_FACTOR,digits);
     }
   if(direction==POSITION_TYPE_SELL)
     {
      double bid=SymbolInfoDouble(SYMBOL,SYMBOL_BID);
      return NormalizeDouble(bid + ATR_CURRENT*ATR_SL_FACTOR,digits);
     }

   return 0;

  }
*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TradingFunctions::getSL3BARS(ENUM_POSITION_TYPE direction)
  {

   MqlRates rates[];
   CopyRates(SYMBOL,PERIOD_D1,3,1,rates);

   if(rates[0].low == 0)
      return 0;
   if(rates[0].high == 0)
      return 0;

   if(direction==POSITION_TYPE_BUY)
     {
      return rates[0].low;
     }

   if(direction==POSITION_TYPE_SELL)
     {
      return rates[0].high;
     }
   return 0;
   /*

         if(ATR_CURRENT ==0) return 0; //Refresh ATR;
         if(direction == POSITION_TYPE_BUY){
            double ask = SymbolInfoDouble(SYMBOL,SYMBOL_ASK);
            return NormalizeDouble(ask - ATR_CURRENT*ATR_SL_FACTOR,digits);
          }
          if(direction == POSITION_TYPE_SELL){
            double bid = SymbolInfoDouble(SYMBOL,SYMBOL_BID);
            return NormalizeDouble(bid + ATR_CURRENT*ATR_SL_FACTOR,digits);
          }

         return 0;
         */
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradingFunctions::GlobalCloseAllPositionsNew(string reason)
  {

   int total=PositionsTotal(); // number of open positions
//--- iterate over all open positions
   for(int i=total-1; i>=0; i--)
     {
      exitSingleTrade(i,reason,0);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*
void TradingFunctions::GlobalTakeProfit(double effectiveATR)
  {

   double profit=AccountInfoDouble(ACCOUNT_PROFIT);
   if(profit>GLOBAL_TAKE_PROFIT)
     {
      if(profit>bufferGlobalTakeProfit*GlobalTakeProfitTrail)
        {
         bufferGlobalTakeProfit=profit;
         return;
        }
      else
        {
         int total=PositionsTotal(); // number of open positions
         //--- iterate over all open positions
         for(int i=total-1; i>=0; i--)
           {
            ulong ticket=PositionGetTicket(i);
            exitSingleTrade(i,"GLOBAL TAKE PROFIT MET");
            //string SYM=PositionGetString(POSITION_SYMBOL);
            //profit=PositionGetDouble(POSITION_PROFIT);
            //if(SYM==SYMBOL && profit>PTP)
            //{

            //}
           }
        }
     }
  }
  */
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void TradingFunctions::GlobalExit(bool EquityTake=false)
  {

   if(EquityTake)
     {
      GlobalCloseAllPositionsNew("EQUITY TAKE PROFIT MET");
      return;

     }
   double profit=AccountInfoDouble(ACCOUNT_PROFIT);
   if(profit>GTP)
     {
      GlobalCloseAllPositionsNew("GTP MET");
      return;

     }
   int total=PositionsTotal(); // number of open positions
//--- iterate over all open positions
   for(int i=total-1; i>=0; i--)
     {
      ulong ticket=PositionGetTicket(i);
      string SYM=PositionGetString(POSITION_SYMBOL);
      profit=PositionGetDouble(POSITION_PROFIT);
      if(SYM==SYMBOL && profit>PTP)
        {
         exitSingleTrade(i,"PAIR Profit Target MET");
        }
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradingFunctions::Exit(string type,string reason)
  {

   if(type=="BUY")
     {
      int total=PositionsTotal();

      for(int i=total-1; i>=0; i--)
        {
         //ulong ticket =buyTrades[i];
         ulong ticket=PositionGetTicket(i);
         double profit=PositionGetDouble(POSITION_PROFIT);
         string sym=PositionGetString(POSITION_SYMBOL);
         ENUM_POSITION_TYPE posType=(ENUM_POSITION_TYPE) PositionGetInteger(POSITION_TYPE);
         if(posType==POSITION_TYPE_BUY && sym==SYMBOL)
           {

            //if(profit >0)
            exitSingleTrade(-1,reason,ticket);
           }
        }
     }
   if(type=="SELL")
     {
      int total= PositionsTotal();
      for(int i=total-1; i>=0; i--)
        {
         //ulong ticket =//sellTrades[i];

         ulong ticket=PositionGetTicket(i);
         double profit=PositionGetDouble(POSITION_PROFIT);
         string sym=PositionGetString(POSITION_SYMBOL);
         ENUM_POSITION_TYPE posType=(ENUM_POSITION_TYPE) PositionGetInteger(POSITION_TYPE);
         if(posType==POSITION_TYPE_SELL && sym==SYMBOL)
           {

            //if(profit >0)
            exitSingleTrade(-1,reason,ticket);
           }

        }
     }

  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
/*
void TradingFunctions::GlobalReducePositions(double effectiveATR)
  {

   int total=PositionsTotal(); // number of open positions
//--- iterate over all open positions
   int count=0;
   for(int i=total-1; i>=0; i--)
     {

      ulong ticket=PositionGetTicket(i);
      string sym=PositionGetString(POSITION_SYMBOL);
      if(sym==SYMBOL) count++;

     }

   if(count>=REDUCE_POSITION_LEVEL)
     {
      for(int i=0; i<=total; i++)
        {

         ulong ticket=PositionGetTicket(i);
         string sym=PositionGetString(POSITION_SYMBOL);
         if(sym==SYMBOL)
           {



            double curPrice=0;double openPrice=0; double pipsMoved=0; double openATR=0; string comment="";double PipsPerATR=0;

            curPrice=PositionGetDouble(POSITION_PRICE_CURRENT);
            openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
            comment=PositionGetString(POSITION_COMMENT);
            string split[];
            int k=StringSplit(comment,':',split);
            if(k>0)
              {
               double atrOrig=StringToDouble(split[1]);
               ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
               if(type==POSITION_TYPE_BUY)  pipsMoved=(curPrice-openPrice)/point/10;
               if(type==POSITION_TYPE_SELL) pipsMoved=(openPrice-curPrice)/point/10;
               PipsPerATR=pipsMoved/atrOrig;

               //if(profit<-1*REDUCE_POSITION_PROFIT_LEVEL*effectiveATR)
               if(PipsPerATR<-1*REDUCE_POSITION_PROFIT_LEVEL)
                 {
                  exitSingleTrade(i,"EXIT TO REDUCE POSITIONS OPEN");
                  return;
                 }

              }
           }
        }
     }

  }
  */
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*
void TradingFunctions::GlobalStopLoss(double effectiveATR)
  {
   if(ENABLE_GLOBAL_STOP_LOSS)
     {
      double profit=AccountInfoDouble(ACCOUNT_PROFIT);
      if(profit<=GLOBAL_STOP_LOSS)
        {
         int total=PositionsTotal(); // number of open positions
         //--- iterate over all open positions
         int count=0;
         for(int i=total-1; i>=0; i--)
           {

            ulong ticket=PositionGetTicket(i);
            string sym=PositionGetString(POSITION_SYMBOL);
            if(sym==SYMBOL)
              {

               double curPrice=0;
               double openPrice=0;
               double pipsMoved=0;
               double openATR=0;
               string comment="";
               double PipsPerATR=0;

               curPrice=PositionGetDouble(POSITION_PRICE_CURRENT);
               openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
               comment=PositionGetString(POSITION_COMMENT);
               string split[];
               int k=StringSplit(comment,':',split);
               if(k>0)
                 {
                  double atrOrig=StringToDouble(split[1]);

                  ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
                  if(type==POSITION_TYPE_BUY)
                     pipsMoved=(curPrice-openPrice)/point/10;
                  if(type==POSITION_TYPE_SELL)
                     pipsMoved=(openPrice-curPrice)/point/10;
                  PipsPerATR=pipsMoved/atrOrig;

                  //if(profit<-1*REDUCE_POSITION_PROFIT_LEVEL*effectiveATR)
                  /*
                  if(PipsPerATR<ATR_MAX_INDIVIDUAL_LOSS)
                    {
                     exitSingleTrade(i,"GLOBAL STOP LOSS EXIT");
                     return;
                    }
                  *//*
                 }

              }
           }
        }

     }
  }
  */
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

/*
void TradingFunctions::GlobalPairTakeProfit(double effectiveATR)
  {

   int total=PositionsTotal(); // number of open positions
//--- iterate over all open positions
   int count=0;double CumProfit=0;
   for(int i=total-1; i>=0; i--)
     {

      ulong ticket=PositionGetTicket(i);
      string sym=PositionGetString(POSITION_SYMBOL);
      double profit=PositionGetDouble(POSITION_PROFIT);
      if(sym==SYMBOL) CumProfit=CumProfit+profit;

     }

   if(CumProfit>=GLOBAL_TAKE_PROFIT)
     {
      for(int i=total-1; i>=0; i--)
        {

         ulong ticket=PositionGetTicket(i);
         string sym=PositionGetString(POSITION_SYMBOL);
         if(sym==SYMBOL)
           {

            double curPrice=0;double openPrice=0; double pipsMoved=0; double openATR=0; string comment="";double PipsPerATR=0;

            curPrice=PositionGetDouble(POSITION_PRICE_CURRENT);
            openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
            openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
            comment=PositionGetString(POSITION_COMMENT);
            string split[];
            int k=StringSplit(comment,":",split);
            if(k>0)
              {
               double atrOrig=StringToDouble(split[1]);
               if(type=POSITION_TYPE_BUY)  pipsMoved=(curPrice-openPrice)/point/10;
               if(type=POSITION_TYPE_SELL) pipsMoved=(openPrice-curPrice)/point/10;
               PipsPerATR=pipsMoved/atrOrig;

               //if(profit<-1*REDUCE_POSITION_PROFIT_LEVEL*effectiveATR)
               if(PipsPerATR>ATR_RATIO_POSITIVE_TAKE_PROFIT)
                 {
                  exitSingleTrade(i,"PAIR STOP LOSS LEVEL HIT");
                  return;
                 }

              }

           }
        }
     }

  }
 */
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*void TradingFunctions::GlobalPositiveTakeProfit(double effectiveATR)
  {
   if(ENABLE_GLOBAL_POSITIVE_TAKE)
     {
      double profit=AccountInfoDouble(ACCOUNT_PROFIT);
      if(profit>=GLOBAL_POSITIVE_TAKE_LOSS_TRIGGER)
        {
         int total=PositionsTotal(); // number of open positions
         //--- iterate over all open positions
         int count=0;
         for(int i=total-1; i>=0; i--)
           {

            ulong ticket=PositionGetTicket(i);
            string sym=PositionGetString(POSITION_SYMBOL);
            if(sym==SYMBOL)
              {

               double curPrice=0;double openPrice=0; double pipsMoved=0; double openATR=0; string comment="";double PipsPerATR=0;

               curPrice=PositionGetDouble(POSITION_PRICE_CURRENT);
               openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
               comment=PositionGetString(POSITION_COMMENT);
               string split[];
               int k=StringSplit(comment,':',split);
               if(k>0)
                 {
                  double atrOrig=StringToDouble(split[1]);
                  ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE) PositionGetInteger(POSITION_TYPE);
                  if(type==POSITION_TYPE_BUY)  pipsMoved=(curPrice-openPrice)/point/10;
                  if(type==POSITION_TYPE_SELL) pipsMoved=(openPrice-curPrice)/point/10;
                  PipsPerATR=pipsMoved/atrOrig;

                  //if(profit<-1*REDUCE_POSITION_PROFIT_LEVEL*effectiveATR)
                  if(PipsPerATR>ATR_RATIO_POSITIVE_TAKE_PROFIT)
                    {
                     exitSingleTrade(i,"POSITIVE TAKE PROFIT MET");
                     return;
                    }

                 }

              }
           }
        }

     }
  }
  */
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
/*
void TradingFunctions::Statistics()
  {
   STATISTICS.BuyTrades=0;
   STATISTICS.SellTrades=0;
   ArrayFree(buyTrades);
   ArrayFree(sellTrades);

   double Capital= AccountInfoDouble(ACCOUNT_BALANCE);
   double Equity = AccountInfoDouble(ACCOUNT_EQUITY);

   if(STATISTICS.RefEquity==0)
     {
      STATISTICS.RefEquity=Equity;
      STATISTICS.RefCapital=Capital;//*5.02;
     }
   if(Equity<Capital)
     {
      STATISTICS.RefCapital= Capital;
      STATISTICS.RefEquity = Equity;
     }
   if(Equity>STATISTICS.RefEquity)
     {
      STATISTICS.RefEquity=Equity;
      STATISTICS.EquityMaxDrop=STATISTICS.RefEquity*EQUITY_TAKE_THRESHOLD;//7;

     }
   if(Equity<STATISTICS.EquityMaxDrop && Equity>STATISTICS.RefCapital)
     {
      if(ENABLE_EQUITY_TAKE)
         GlobalExit(true);
      STATISTICS.RefCapital=AccountInfoDouble(ACCOUNT_BALANCE);
      STATISTICS.EquityMaxDrop=STATISTICS.RefCapital*EQUITY_TAKE_THRESHOLD;
     }

   int total=PositionsTotal(); // number of open positions
//--- iterate over all open positions
   for(int i=total-1; i>=0; i--)
     {
      ulong ticket=PositionGetTicket(i);
      string SYM=PositionGetString(POSITION_SYMBOL);
      if(SYM==SYMBOL)
        {

         ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE) PositionGetInteger(POSITION_TYPE);

         if(type==POSITION_TYPE_BUY)
           {
            STATISTICS.BuyTrades++;
            int index=ArraySize(buyTrades);
            ArrayResize(buyTrades,index+1);
            buyTrades[index]=ticket;
           }
         if(type==POSITION_TYPE_SELL)
           {
            STATISTICS.SellTrades++;
            int index=ArraySize(sellTrades);
            ArrayResize(sellTrades,index+1);
            sellTrades[index]=ticket;
           }
        }
     }
  }
*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SLTP TradingFunctions::setSLTP(int direction,double atr)
  {

   SLTP data;
   data.SL=0;
   data.TP=0;
   double ask =SymbolInfoDouble(SYMBOL, SYMBOL_ASK);
   double bid = SymbolInfoDouble(SYMBOL, SYMBOL_BID);
   data.ask =ask;
   data.bid = bid;
   
   double stop_loss_pips=0;
   
   if(ENABLE_STOP_ON_ATR)
     {
      stop_loss_pips = atr * ATR_STOP_MULTIPLIER/point/10;
     }
    else
    {
      stop_loss_pips = STOP_LOSS_PIPS;
    }

   if(direction==UP)
     {
      data.SL = ask - stop_loss_pips*point*10;
      data.TP = ask + TAKE_PROFIT_PIPS*point*10;
     }

   if(direction==DOWN)
     {
      data.SL = bid + stop_loss_pips*point*10;
      data.TP = bid - TAKE_PROFIT_PIPS*point*10;

     }
   return data;
  }
//+------------------------------------------------------------------+
