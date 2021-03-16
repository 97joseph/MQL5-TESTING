//+------------------------------------------------------------------+
//|                                                  SpreadSheet.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#define BUFFER_LEN 14

#include <..\Experts\TrendPower\V1\Inputs.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct INDICATOR
  {
   int               handle;
   string            name;
   ENUM_TIMEFRAMES   timeframe;
   int               period;
   double            bars;
   double            values[BUFFER_LEN];

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct bASELINE
  {
   bool              BASELINE_BUY;
   bool              BASELINE_SELL;
   double            BASELINE;
   double            hysterisis;

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct cONFIRMATION
  {
   bool              CONFIRMATION_BUY;
   bool              CONFIRMATION_SELL;
   double            CONFIRMATION;
   double            hysterisis;

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct aTR
  {
   double            ATR;

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct ROW
  {
   ulong             ticket;
   string            SYMBOL;
   datetime          date;
   ENUM_POSITION_TYPE posType;
   double            lot;
   double            sl;
   double            tp;

   double            openPrice;
   double            primary;
   double            confirmation;
   double            cofirmation2;
   double            exit;
   double            closePrice;
   double            profit;

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct SHEET
  {
   string            SYMBOL;
   int               positions;
   int               BUY_POSITIONS;
   int               SELL_POSITIONS;
   bool              BUY_ALLOWED;
   bool              SELL_ALLOWED;
   //double            ask;
   //double            bid;
   double            spread;
   int               digits;
   double            point;
   double            inter_trade_pips;
   double            ATR;
   double            SL_BUY;
   double            SL_SELL;
   double            TP_BUY;
   double            TP_SELL;
   double            LOT;
   double            LastTradeProfit;
   double            LastTradeLot;
   bool              ESCALATED_SELL;
   bool              ESCALATED_BUY;
   double               CummulativePositionSize;
   ENUM_POSITION_TYPE LastTradeType;
    
   bASELINE          baseline;
   aTR               atr;
   cONFIRMATION      confirmation;

   ROW               Positions[];
   INDICATOR         indicators[];
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct WORKBOOK
  {
   int               pairs;

   SHEET             Pairs[];
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SpreadSheet
  {
private:

public:
   int               sheets;
   WORKBOOK          workbook;

                     SpreadSheet();

   int               AddPair(string symbol);
   void              DeletePair(string symbol);
   int               getPairByName(string symbol);

   int               AddPosition(ulong ticket,int pair);
   void              DeletePosition(ulong ticket,int pair);
   int               getPositionbyTicket(ulong ticket,int pair);

   int               AddIndicator(int pair,string IndicatorName);
   void              DeleteIndicator(int pair,string IndicatorName);
   int               getIndicatorByName(int pair,string IndicatorName);

   void              fillSpreadsheet();



                    ~SpreadSheet();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SpreadSheet::SpreadSheet()
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SpreadSheet::~SpreadSheet()
  {
  }
//+------------------------------------------------------------------+
int SpreadSheet::AddPair(string symbol)
  {
   int size=ArraySize(workbook.Pairs);
   ArrayResize(workbook.Pairs,size+1);
   workbook.Pairs[size].SYMBOL=symbol;
   return size;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SpreadSheet::DeletePair(string symbol)
  {
   int index= getPairByName(symbol);
   if(index>=0) ArrayRemove(workbook.Pairs,index,1);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int SpreadSheet::getPairByName(string symbol)
  {

   int size = ArraySize(workbook.Pairs);
   for(int i=0;i<size;i++)
     {
      if(workbook.Pairs[i].SYMBOL == symbol) return i;
     }
   return -1;
  }
//+------------------------------------------------------------------+
int SpreadSheet::AddPosition(ulong ticket,int pair)
  {
   int size=ArraySize(workbook.Pairs[pair].Positions);
   ArrayResize(workbook.Pairs[pair].Positions,size+1);
   workbook.Pairs[pair].Positions[size].ticket=ticket;
   return size;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SpreadSheet::DeletePosition(ulong ticket,int pair)
  {
   int index= getPositionbyTicket(ticket,pair);
   if(index>=0) ArrayRemove(workbook.Pairs[pair].Positions,index,1);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int SpreadSheet::getPositionbyTicket(ulong ticket,int pair)
  {

   int size = ArraySize(workbook.Pairs[pair].Positions);
   for(int i=0;i<size;i++)
     {
      if(workbook.Pairs[pair].Positions[i].ticket == ticket) return i;
     }
   return -1;
  }
//+------------------------------------------------------------------+
int SpreadSheet::AddIndicator(int pair,string IndicatorName)
  {
   if(pair >1000) return 0;
   int size=ArraySize(workbook.Pairs[pair].indicators);
   ArrayResize(workbook.Pairs[pair].indicators,size+1);
   workbook.Pairs[pair].indicators[size].name=IndicatorName;
   return size;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SpreadSheet::DeleteIndicator(int pair,string IndicatorName)
  {
   int index= getIndicatorByName(pair,IndicatorName);
   if(index>=0) ArrayRemove(workbook.Pairs[pair].indicators,index,1);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int SpreadSheet::getIndicatorByName(int pair,string IndicatorName)
  {

   int size = ArraySize(workbook.Pairs[pair].indicators);
   for(int i=0;i<size;i++)
     {
      if(workbook.Pairs[pair].indicators[i].name == IndicatorName) return i;
     }
   return -1;
  }
//+------------------------------------------------------------------+
void SpreadSheet::fillSpreadsheet()
  {
   int pairs= workbook.pairs;
   for(int p=0;p<pairs;p++)
     {
      int indicators=ArraySize(workbook.Pairs[p].indicators);
      double buffer[];
      ArraySetAsSeries(buffer,true);
      int handle=0;
      int index = 0;

      for(int i=0;i<indicators;i++)
        {

         //Fill Indicator Buffers
         handle=workbook.Pairs[p].indicators[i].handle;
         CopyBuffer(handle,0,0,BUFFER_LEN,buffer);
         int s = ArraySize(buffer);
         int len = MathMin(BUFFER_LEN,ArraySize(buffer));
         for(int b=0;b<len;b++)
           {
            workbook.Pairs[p].indicators[i].values[b]=buffer[b];
           }

        }
      workbook.Pairs[p].BUY_POSITIONS=0;
      workbook.Pairs[p].SELL_POSITIONS=0;
      workbook.Pairs[p].BUY_ALLOWED=true;
      workbook.Pairs[p].SELL_ALLOWED=true;

     }
   int total=PositionsTotal(); // number of open positions  

   ulong ticket=PositionGetTicket(total-1);
   
//double inter_trade_pips = 0;
//----------MASTER PAIR LOOP ----------------
   for(int i=total-1; i>=0; i--)
     {
      ticket=PositionGetTicket(i);
      string symbol=PositionGetSymbol(i);
      int pair=this.getPairByName(symbol);
      double ask = SymbolInfoDouble(symbol,SYMBOL_ASK);
      double bid = SymbolInfoDouble(symbol,SYMBOL_BID);
      workbook.Pairs[pair].point=SymbolInfoDouble(symbol,SYMBOL_POINT);

      workbook.Pairs[pair].SL_BUY=NormalizeDouble(ask-workbook.Pairs[pair].ATR*ATR_SL_FACTOR,workbook.Pairs[pair].digits);
      workbook.Pairs[pair].SL_SELL=NormalizeDouble(bid+workbook.Pairs[pair].ATR*ATR_SL_FACTOR,workbook.Pairs[pair].digits);

      workbook.Pairs[pair].TP_BUY=NormalizeDouble(ask+workbook.Pairs[pair].ATR*ATR_TP_FACTOR,workbook.Pairs[pair].digits);
      workbook.Pairs[pair].TP_SELL=NormalizeDouble(bid-workbook.Pairs[pair].ATR*ATR_TP_FACTOR,workbook.Pairs[pair].digits);

      int pos= this.getPositionbyTicket(ticket,pair);
      if(pos == -1)
        {
         this.AddPosition(ticket,pair);
         pos=this.getPositionbyTicket(ticket,pair);
        }
      workbook.Pairs[pair].Positions[pos].SYMBOL=symbol;
      workbook.Pairs[pair].Positions[pos].date=(datetime)PositionGetInteger(POSITION_TIME);
      workbook.Pairs[pair].Positions[pos].openPrice=PositionGetDouble(POSITION_PRICE_OPEN);
      workbook.Pairs[pair].Positions[pos].posType=(ENUM_POSITION_TYPE) PositionGetInteger(POSITION_TYPE);

      if(workbook.Pairs[pair].Positions[pos].posType==POSITION_TYPE_BUY)
        {
         workbook.Pairs[pair].BUY_POSITIONS++;
         if(workbook.Pairs[pair].inter_trade_pips==0) workbook.Pairs[pair].inter_trade_pips=MathAbs(ask-workbook.Pairs[pair].Positions[pos].openPrice)/workbook.Pairs[pair].point/10;
        }
      if(workbook.Pairs[pair].Positions[pos].posType==POSITION_TYPE_SELL)
        {
         workbook.Pairs[pair].SELL_POSITIONS++;
         if(workbook.Pairs[pair].inter_trade_pips==0) workbook.Pairs[pair].inter_trade_pips=MathAbs(bid-workbook.Pairs[pair].Positions[pos].openPrice)/workbook.Pairs[pair].point/10;
        }

      if(workbook.Pairs[pair].BUY_POSITIONS<MAX_TRADES) workbook.Pairs[pair].BUY_ALLOWED=true;
      if(workbook.Pairs[pair].SELL_POSITIONS<MAX_TRADES) workbook.Pairs[pair].SELL_ALLOWED=true;
      
      if(workbook.Pairs[pair].inter_trade_pips<INTER_TRADE_PIPS)
        {

         if(workbook.Pairs[pair].BUY_POSITIONS>0) workbook.Pairs[pair].BUY_ALLOWED=false;
         if(workbook.Pairs[pair].SELL_POSITIONS>0) workbook.Pairs[pair].SELL_ALLOWED=false;

          
        }
 
     workbook.Pairs[pair].CummulativePositionSize = workbook.Pairs[pair].CummulativePositionSize + PositionGetDouble(POSITION_VOLUME); 
     if(i == (total-1)) //LAST TRADE
     {
         
         workbook.Pairs[pair].LastTradeProfit = PositionGetDouble(POSITION_PROFIT);
         workbook.Pairs[pair].LastTradeType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         double vol =PositionGetDouble(POSITION_VOLUME);
         workbook.Pairs[pair].CummulativePositionSize  = vol;
         if(workbook.Pairs[pair].LastTradeProfit <0)
         {
            if(workbook.Pairs[pair].LastTradeType == POSITION_TYPE_BUY) if(workbook.Pairs[pair].BUY_POSITIONS>0) workbook.Pairs[pair].BUY_ALLOWED=false;
            if(workbook.Pairs[pair].LastTradeType == POSITION_TYPE_BUY) if(workbook.Pairs[pair].BUY_POSITIONS>0) workbook.Pairs[pair].SELL_ALLOWED=false;
            workbook.Pairs[pair].LastTradeLot = vol;
            
         }    
        
         ulong magic = (ulong)PositionGetInteger(POSITION_MAGIC);
         if(magic == 888)
           {
               if(workbook.Pairs[pair].Positions[pos].posType == POSITION_TYPE_BUY) {workbook.Pairs[pair].ESCALATED_BUY = true;workbook.Pairs[pair].ESCALATED_SELL = false;}
               if(workbook.Pairs[pair].Positions[pos].posType == POSITION_TYPE_SELL) {workbook.Pairs[pair].ESCALATED_BUY = false;workbook.Pairs[pair].ESCALATED_SELL = true;}
           
           }
     
         
     }   
     
     
     
      
     }



  }
//+------------------------------------------------------------------+
