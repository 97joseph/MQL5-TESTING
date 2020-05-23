//+------------------------------------------------------------------+
//|                                                      ATR.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <..\Experts\TrendPower\V4.3\TradingFunctions.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ATR
  {
private:
   string            SYMBOL;
   ENUM_TIMEFRAMES   TIMEFRAME;
   int               PERIOD;
   double            point;
   int               digits;
   int               atrHandle;
public:
   double            aTR;
   double            LOT;
   double            SL_BUY;
   double            SL_SELL;
   double            TP_BUY;
   double            TP_SELL;
   int               BUY_POSITIONS;
   int               SELL_POSITIONS;
   bool              BUY_ALLOWED;
   bool              SELL_ALLOWED;
   int               PairPosition;

                     ATR(string symbol,ENUM_TIMEFRAMES timeframe,int period);
                    ~ATR();
   double            getATR();
   void              SL();
   void              setLot();
   double            getLot();
   void              fillPositions();

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ATR::ATR(string symbol,ENUM_TIMEFRAMES timeframe,int period)
  {
   SYMBOL=symbol;
   TIMEFRAME=timeframe;
   PERIOD= period;
   point = SymbolInfoDouble(SYMBOL,SYMBOL_POINT);
   digits=(int)SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS);
   atrHandle=iATR(SYMBOL,ATR_TIMEFRAME,ATR_PERIOD);

//*data = &d;


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ATR::~ATR()
  {
  }
//+------------------------------------------------------------------+
double ATR::getATR()
  {
   
   double atr[];
   ArraySetAsSeries(atr,true);
   CopyBuffer(atrHandle,0,0,4,atr);
   
   aTR = atr[1];
   

   if(aTR <0.0001) aTR =0;
   SL(); //Update SL/TP
   return aTR;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ATR::SL()
  {

   if(aTR ==0) return; //Refresh ATR;

   setLot();

   double ask = SymbolInfoDouble(SYMBOL,SYMBOL_ASK);
   double bid = SymbolInfoDouble(SYMBOL,SYMBOL_BID);

   SL_BUY=NormalizeDouble(ask-aTR*ATR_SL_FACTOR,digits);
   SL_SELL=NormalizeDouble(bid+aTR*ATR_SL_FACTOR,digits);

   TP_BUY=NormalizeDouble(ask+aTR*ATR_TP_FACTOR,digits);
   TP_SELL=NormalizeDouble(bid-aTR*ATR_TP_FACTOR,digits);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ATR::setLot()
  {
   LOT=getLot();
   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ATR::getLot()
  {
   double lot =0.01;
   return lot;
   
   //----------------------------------
   if(aTR ==0) return 0;
   if(point==0) point = SymbolInfoDouble(SYMBOL, SYMBOL_POINT);
   if(point==0) return 0;
   double riskAmount=ALLOWED_RISK*MathMin(AccountInfoDouble(ACCOUNT_EQUITY),AccountInfoDouble(ACCOUNT_BALANCE));
   double price=(SymbolInfoDouble(SYMBOL,SYMBOL_ASK)+SymbolInfoDouble(SYMBOL,SYMBOL_BID))/2;
//1 LOT = $10 PER PIP 
   double riskPips=riskAmount/10 *CONVERSION_FACTOR; //
   lot=NormalizeDouble(riskPips/27*27/((aTR*ATR_SL_FACTOR/(point*10*CONVERSION_FACTOR))),1);
   if(lot<0.01) lot=0.01;
//lot =0.1;
   return lot;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ATR::fillPositions()
  {
   int total=PositionsTotal(); // number of open positions  
   BUY_POSITIONS=0;
   SELL_POSITIONS=0;
   BUY_ALLOWED=false;
   SELL_ALLOWED=false;
   ulong ticket= PositionGetTicket(total-1);
   double inter_trade_pips=0;
//--- iterate over all open positions
   for(int i=total-1; i>=0; i--)
     {
      ticket=PositionGetTicket(i);
      if(PositionGetSymbol(i)==SYMBOL)
        {
         double openPrice=PositionGetDouble(POSITION_PRICE_OPEN);
         double ask = SymbolInfoDouble(SYMBOL,SYMBOL_ASK);
         double bid = SymbolInfoDouble(SYMBOL,SYMBOL_BID);

         ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         if(type==POSITION_TYPE_BUY)
           {
            BUY_POSITIONS++;
            if(inter_trade_pips==0) inter_trade_pips=MathAbs(ask-openPrice)/point/10;
           }
         if(type==POSITION_TYPE_SELL)
           {
            SELL_POSITIONS++;
            if(inter_trade_pips==0) inter_trade_pips=MathAbs(bid-openPrice)/point/10;
           }

        }
     }
   if(inter_trade_pips<INTER_TRADE_PIPS)
     {
      BUY_ALLOWED=true;
      SELL_ALLOWED=true;

      if(BUY_POSITIONS>0) BUY_ALLOWED=false;
      if(SELL_POSITIONS>0) SELL_ALLOWED=false;

      return;
     }
   if(BUY_POSITIONS<MAX_TRADES) BUY_ALLOWED=true;
   if(SELL_POSITIONS<MAX_TRADES) SELL_ALLOWED=true;

  }
//+------------------------------------------------------------------+
