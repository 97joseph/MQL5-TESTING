//+------------------------------------------------------------------+
//|                                                     TVP_Exit.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#include <..\Experts\TrendPower\V1\TradingFunctions.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TVP_Exit
  {
private:
   string            SYMBOL;
   ENUM_TIMEFRAMES   TIMEFRAME;
   double            point;
   int               digits;
   int               ExitSAR;
   int               macd;
   TradingFunctions *TF;
   int               ConfirmationHandle;
   int               HandleHeiken;
   int               PairPosition;
   double            buyLot;
   double            sellLot;
   bool              EscalatedBuy;
   bool              EscalatedSell;
public:
   bool              EXIT_BUY;
   bool              EXIT_SELL;

   bool              PRIMARY_BUY;
   bool              PRIMARY_SELL;

   bool              CONFIRMATION_BUY;
   bool              CONFIRMATION_SELL;

                     TVP_Exit(string symbol,ENUM_TIMEFRAMES timeframe);
                    ~TVP_Exit();
   void              getExit(void);
   void              Exit(string type,bool onProfit=false);
   void              GetLot();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TVP_Exit::TVP_Exit(string symbol,ENUM_TIMEFRAMES timeframe)
  {
   SYMBOL=symbol;
   TIMEFRAME=timeframe;
   point=SymbolInfoDouble(SYMBOL,SYMBOL_POINT);
   digits=(int)SymbolInfoInteger(SYMBOL,SYMBOL_DIGITS);
   TF=new TradingFunctions(SYMBOL,TIMEFRAME);
/*
   ExitSAR=iSAR(SYMBOL,TIMEFRAME,Parabolic_SAR_Step,Parabolic_SAR_Max);
//macd = iMACD(SYMBOL,TIMEFRAME,12,26,9,PRICE_CLOSE);

   PairPosition=DATA.getPairByName(SYMBOL);
*/

   HandleHeiken=iCustom(SYMBOL,TIMEFRAME,"heiken_ashi");
//int i=DATA.AddIndicator(PairPosition,"heiken_ashi");
//DATA.workbook.Pairs[PairPosition].indicators[i].handle=HandleHeiken;


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TVP_Exit::~TVP_Exit()
  {
  }
//+------------------------------------------------------------------+
void TVP_Exit::getExit(void)
  {

   double Confirmation[];
   double Heiken[];

   EXIT_BUY  =false;
   EXIT_SELL =false;
//return;

   ArraySetAsSeries(Confirmation,true);
   ArraySetAsSeries(Heiken,true);

   CopyBuffer(ConfirmationHandle,0,0,3,Confirmation);
   CopyBuffer(HandleHeiken,1,0,4,Heiken);
   STATISTICS.sl_sell=Heiken[2];

   CopyBuffer(HandleHeiken,2,0,4,Heiken);
   STATISTICS.sl_buy=Heiken[2];

   CopyBuffer(HandleHeiken,4,0,4,Heiken);

   if(Heiken[1]==0 && Heiken[2]==1)//&& Heiken[3]==1
     {
      Exit("SELL");
      return;
     }
   if(Heiken[1]==1 && Heiken[2]==0)// && Heiken[3]==0
     {
      Exit("BUY");
      return;
     }

   return;



   EXIT_BUY=false;
   EXIT_SELL=false;

   double Main[];double Signal[];
/* ----------- MACD EXIT-----------
   //ArraySetAsSeries(Main,true);ArraySetAsSeries(Signal,true);
   //CopyBuffer(macd,0,0,3,Main);CopyBuffer(macd,1,0,3,Signal);
   
   //if((Signal[0] > Main[0]) && (Signal[1] < Main[1]) && (Signal[0]>0)) 
   //   EXIT_BUY=true;
   //if((Signal[0] < Main[0]) && (Signal[1] > Main[1]) && (Signal[0]<0))
   //    EXIT_SELL=true;
   
   //if(EXIT_BUY) Exit("BUY");
   //if(EXIT_SELL) Exit("SELL");
   
  //double Rates[];
  //CopyClose(SYMBOL,TIMEFRAME,0,3,Rates);
 
  
   //return;
   */
//---------------------------------------------
   double Exit[];

   ArraySetAsSeries(Exit,true);
   CopyBuffer(ExitSAR,0,0,3,Exit);

   double ask = SymbolInfoDouble(SYMBOL,SYMBOL_ASK);
   double bid = SymbolInfoDouble(SYMBOL,SYMBOL_BID);

   EXIT_BUY=false;
   EXIT_SELL=false;

   double Rates[];
   CopyClose(SYMBOL,TIMEFRAME,0,3,Rates);

   STATISTICS.suspend_new =false;
   STATISTICS.suspend_buy =false;
   STATISTICS.suspend_sell=false;
   if(ArraySize(Rates) == 0) return;
   if(Exit[1]>Rates[1] && Exit[2]<Rates[1])
      STATISTICS.suspend_new=true;
   if(Exit[1]<Rates[1] && Exit[2]>Rates[1])
      STATISTICS.suspend_new=true;

   if(Exit[1]>Rates[1])
      STATISTICS.suspend_buy=true;

   if(Exit[1]<Rates[1])
      STATISTICS.suspend_sell=true;

   if(Exit[1]>Rates[1] && STATISTICS.BuyTrades>0)
     {
      //if(STATISTICS.slope >-25 && STATISTICS.slope >25){
      EXIT_BUY=true;
      STATISTICS.suspend_buy=true;
      TF.Exit("BUY","Trend Change");
      if(!EscalatedBuy)
        {
         this.GetLot();
         escalated_lot_size = this.buyLot;
         escalated_lot_size = NormalizeDouble((escalated_lot_size + LINEAR_ESC_OFFSET)* EXPONENTIOAL_ESC_OFFSET,2);
         TF.tradeSell(0,888,0,escalated_lot_size,0.01);
         EscalatedBuy=false;
         EscalatedSell=true;
        }
      //}
     }

   if(Exit[1]<Rates[1] && STATISTICS.SellTrades>0)
     {
      //if(STATISTICS.slope >-25 && STATISTICS.slope >25){
      STATISTICS.suspend_sell=true;
      EXIT_SELL=true;
      TF.Exit("SELL","Trend Change");
      if(!EscalatedBuy)
        {
         escalated_lot_size = this.sellLot;
         escalated_lot_size = NormalizeDouble((escalated_lot_size + LINEAR_ESC_OFFSET)* EXPONENTIOAL_ESC_OFFSET,2);
         TF.tradeBuy(0,888,0,escalated_lot_size,0.1);
         EscalatedBuy=true;
         EscalatedSell=false;
        }
      //}
     }
   if(Exit[1]>Rates[1]) EXIT_BUY=true;
   if(Exit[1]<Rates[1]) EXIT_SELL=true;

   return;

/*
   if(
            (STATISTICS.BuyTrades >0) &&
             ((
               STATISTICS.Primary_AroonDown > STATISTICS.Primary_AroonUp) 
               &&(
               STATISTICS.Confirmation < 95
             )
               ||
             (
               Exit[0] > ask
             ))  
      ) //BUY EXIT Condition Met
      {
         EXIT_BUY =true;
         Exit("BUY");
      }
   if(
            (STATISTICS.SellTrades >0) &&
             (
               STATISTICS.Primary_AroonUp > STATISTICS.Primary_AroonDown &&
               STATISTICS.Confirmation > 5
               ||
             (
               bid > Exit[0]
             ))  
      ) //SELL EXIT Condition Met
      {
         EXIT_SELL =true;
         Exit("SELL");
      }
   */

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TVP_Exit::Exit(string type,bool onProfit=false)
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
            if(onProfit)
              {
               if(profit>0) TF.exitSingleTrade(-1,"Exit Indicator BUY Exit",ticket);
              }
            else
              {
               TF.exitSingleTrade(-1,"Exit Indicator BUY Exit",ticket);
              }
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

            if(onProfit)
              {
               if(profit>0) TF.exitSingleTrade(-1,"Exit Indicator SELL Exit",ticket);
              }
            else
              {
               TF.exitSingleTrade(-1,"Exit Indicator SELL Exit",ticket);
              }
           }

        }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void TVP_Exit::GetLot()
  {
   int total=PositionsTotal();
   buyLot=0;
   sellLot=0;
   for(int i=total-1; i>=0; i--)
     {
      ulong ticket=PositionGetTicket(i);
      string sym=PositionGetString(POSITION_SYMBOL);
      if(sym==SYMBOL)
        {
         ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE) PositionGetInteger(POSITION_TYPE);
         double vol=PositionGetDouble(POSITION_VOLUME);
         if(type == POSITION_TYPE_BUY) buyLot = buyLot + vol;
         if(type == POSITION_TYPE_SELL) sellLot = sellLot + vol;

         int magic=(int)PositionGetInteger(POSITION_MAGIC);
         if(magic == 888)
           {
            if(type == POSITION_TYPE_BUY) EscalatedBuy = false;
            if(type == POSITION_TYPE_SELL) EscalatedSell = false;


           }

        }
     }

  }
//+------------------------------------------------------------------+
