//+------------------------------------------------------------------+
//|                                                 TVP_ScaleOut.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <..\Experts\TrendPower\V1\TradingFunctions.mqh>
class TVP_ScaleOut
  {
private:
   MqlTradeTransaction TRANS;
   MqlTradeRequest REQUEST;
   MqlTradeResult RESULT;
   string SYMBOL; 
   ENUM_TIMEFRAMES TIMEFRAME;
   double point;
   int digits;
   double bid;
   double ask;

public:
                     TVP_ScaleOut(
                           const MqlTradeTransaction&    trans,        // trade transaction structure 
                           const MqlTradeRequest&        request,      // request structure 
                           const MqlTradeResult&         result,        // result structure )
                           ENUM_TIMEFRAMES timeframe
                          );
                    ~TVP_ScaleOut();
                    void Execute();
                    
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TVP_ScaleOut::TVP_ScaleOut(
   const MqlTradeTransaction&    trans,        // trade transaction structure 
   const MqlTradeRequest&        request,      // request structure 
   const MqlTradeResult&         result,        // result structure )
   ENUM_TIMEFRAMES timeframe

  )
  {
  
    SYMBOL = trans.symbol;
    TIMEFRAME = timeframe;
    point = SymbolInfoDouble(SYMBOL,SYMBOL_POINT);
    digits = (int)SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS);
    bid = SymbolInfoDouble(SYMBOL,SYMBOL_BID);
    ask = SymbolInfoDouble(SYMBOL,SYMBOL_ASK);
    
    TRANS=trans;
    REQUEST=request;
    RESULT=result;
    
    Execute();
    
   
  
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TVP_ScaleOut::~TVP_ScaleOut()
  {
  }
//+------------------------------------------------------------------+


void TVP_ScaleOut::Execute()
  {
  
     ulong    ticket; 
     datetime from=0; 
     datetime to=TimeCurrent(); 
     double SL =0;
//--- request the entire history 
   HistorySelect(from,to); 
  

  int t = HistoryOrdersTotal();
  for (int i = t - 1; i >= 0; i--)
  {
      ;
      if( (ticket = HistoryOrderGetInteger(i,ORDER_TICKET))>0) 
        { 
           
            double OrigPrice    =HistoryOrderGetDouble(ticket,ORDER_PRICE_OPEN); 
            
            int AchorMagic = (int)HistoryOrderGetInteger(ticket,ORDER_MAGIC);
            string comment = HistoryOrderGetString(ticket,ORDER_COMMENT);
            ENUM_ORDER_REASON  reason = (ENUM_ORDER_REASON) HistoryOrderGetInteger(i,ORDER_REASON);
            if(reason ==ORDER_REASON_TP)
            {
               //double ask = SymbolInfoDouble(SYMBOL,SYMBOL_ASK);
               //double bid = SymbolInfoDouble(SYMBOL,SYMBOL_BID);
               
               
               int total = PositionsTotal();
               for(int j=total-1; j>=0; j--)
                            {
                                 
                                 ulong tkt = PositionGetTicket(j);
                                 SYMBOL = PositionGetString(POSITION_SYMBOL);
                                 int magic = (int)PositionGetInteger(POSITION_MAGIC);
                                 if(magic == AchorMagic)
                                 {
                                    //Log
                                    SYMBOL = PositionGetString(POSITION_SYMBOL);
                                    double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
                                    double curSL = PositionGetDouble(POSITION_SL);
                                    ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE) PositionGetInteger(POSITION_TYPE);
                                    if(type == POSITION_TYPE_BUY) 
                                       {
                                          ask = SymbolInfoDouble(SYMBOL,SYMBOL_ASK);
                                          bid = SymbolInfoDouble(SYMBOL,SYMBOL_BID);
                                          
                                          
                                          double diff = MathAbs(openPrice-curSL)/point/10;
                                          int spread = (int)SymbolInfoInteger(SYMBOL,SYMBOL_SPREAD);
                                          if(diff <spread) continue;
                                          
                                          diff = (ask-openPrice)/point/10;
                                          double diff2 = MathAbs(bid-openPrice)/point/10;
                                          spread = (int)SymbolInfoInteger(SYMBOL,SYMBOL_SPREAD);
                                          if(diff <spread) continue;
                                          if(diff2 <spread) continue;
                                          
                                          TradingFunctions *tf = new TradingFunctions(SYMBOL,TIMEFRAME);
                                          if(tf.updateSL(tkt,openPrice))
                                             {
                                                STATISTICS.last_ticket_TP = ticket;
                                             }
                                           else
                                           {
                                                STATISTICS.last_ticket_TP = STATISTICS.last_ticket_TP;
                                           }
                                          delete tf;
                                            
                                       }
                                       if(type == POSITION_TYPE_SELL) 
                                       {
                                          ask = SymbolInfoDouble(SYMBOL,SYMBOL_ASK);
                                          bid = SymbolInfoDouble(SYMBOL,SYMBOL_BID);
                                          
                                          
                                          double diff = MathAbs(openPrice-curSL)/point/10;
                                          int spread = (int)SymbolInfoInteger(SYMBOL,SYMBOL_SPREAD);
                                          if(diff <spread) continue;
                                          
                                          diff = (openPrice-ask)/point/10;
                                          double diff2 = MathAbs(openPrice-bid)/point/10;
                                          spread = (int)SymbolInfoInteger(SYMBOL,SYMBOL_SPREAD);
                                          if(diff <spread) continue;
                                          if(diff2 <spread) continue;
                                          
                                          TradingFunctions *tf = new TradingFunctions(SYMBOL,TIMEFRAME);
                                          if(tf.updateSL(tkt,openPrice))
                                             {
                                                STATISTICS.last_ticket_TP = ticket;
                                             }
                                           else
                                           {
                                                STATISTICS.last_ticket_TP = STATISTICS.last_ticket_TP;
                                           }
                                          delete tf;
                                           //  }
                                       }
                                       
                                 
                                    /*
                                    SYMBOL = PositionGetString(POSITION_SYMBOL);
                                    double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
                                    double curSL = PositionGetDouble(POSITION_SL);
                                    double diff = MathAbs(openPrice-curSL);
                                    int spread = (int)SymbolInfoInteger(SYMBOL,SYMBOL_SPREAD);
                                    if(diff <spread*point*10) continue;
                                    TradingFunctions *tf = new TradingFunctions(SYMBOL);
                                    if(tf.updateSL(tkt,openPrice))
                                       {
                                          STATISTICS.last_ticket_TP = ticket;
                                       }
                                     else
                                     {
                                          STATISTICS.last_ticket_TP = STATISTICS.last_ticket_TP;
                                     }
                                    delete tf;
                                    */
                                    /*
                                    string commentCurrent = (double) PositionGetString(POSITION_COMMENT);
                                    
                                    double newSL = NormalizeDouble(openPrice,digits);
                                    ENUM_POSITION_TYPE type =(ENUM_POSITION_TYPE) PositionGetInteger(POSITION_TYPE);
                                    double curSL = PositionGetDouble(POSITION_SL);
                                    if(type == POSITION_TYPE_BUY) 
                                    {
                                       SL = NormalizeDouble(OrigPrice - STATISTICS.ATR,digits);
                                       double diff = SL - ask;
                                       if(diff >-10*point*10)
                                       {
                                          SL = NormalizeDouble(OrigPrice - STATISTICS.ATR*2,digits);
                                          //OrigPrice = NormalizeDouble(OrigPrice - STATISTICS.ATR,digits);
                                       }
                                    }
                                    if(type == POSITION_TYPE_SELL) 
                                    {
                                       SL = NormalizeDouble(OrigPrice + STATISTICS.ATR,digits);
                                       double diff = bid - SL;
                                       if(diff >-10*point*10)
                                       {
                                          SL = NormalizeDouble(OrigPrice + STATISTICS.ATR*2,digits);
                                          //OrigPrice = NormalizeDouble(OrigPrice - STATISTICS.ATR,digits);
                                       }
                                    }
                                    double diffSL = MathAbs(curSL-SL)/point/10;
                                    
                                    if(diffSL <10) continue;
                                    
                                    
                                    */
                                 }
                                
                             }
                  }
      
            }
      
      
  } 
  
  
  
  }
//+------------------------------------------------------------------+
