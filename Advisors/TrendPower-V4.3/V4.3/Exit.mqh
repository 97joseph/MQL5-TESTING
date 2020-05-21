//+------------------------------------------------------------------+
//|                                                     TVP_Exit.mqh |
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
class Exit
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

                     Exit(string symbol,ENUM_TIMEFRAMES timeframe);
                    ~Exit();
   void              getExit(void);
   void              Execute(string type,bool onProfit=false);
   void              GetLot();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Exit::Exit(string symbol,ENUM_TIMEFRAMES timeframe)
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
Exit::~Exit()
  {
  }
//+------------------------------------------------------------------+
void Exit::getExit(void)
  {

  
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Exit::Execute(string type,bool onProfit=false)
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void Exit::GetLot()
  {
   

  }
//+------------------------------------------------------------------+
