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
#include <..\Experts\TrendPower\V1\Inputs.mqh>
#include <..\Experts\TrendPower\V1\TVP_ATR.mqh>
#include <..\Experts\TrendPower\V1\TVP_BaseLine.mqh>
#include <..\Experts\TrendPower\V1\TVP_PrimaryIndicator.mqh>
#include <..\Experts\TrendPower\V1\TVP_Volume.mqh>
#include <..\Experts\TrendPower\V1\TVP_ConfirmationIndicator.mqh>
#include <..\Experts\TrendPower\V1\TVP_Exit.mqh>
#include <..\Experts\TrendPower\V1\TradingFunctions.mqh>
#include <..\Experts\TrendPower\V1\Logger.mqh>
#include <..\Experts\TrendPower\V1\SpreadSheet.mqh>
#include <..\Experts\TrendPower\V1\LossPerDay.mqh>
#include <..\Experts\TrendPower\V1\TradeClassifier.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TVP
  {
private:
   TVP_ATR          *atr;
   TVP_BaseLine     *baseline;
   TVP_PrimaryIndicator *primary;
   TVP_ConfirmationIndicator *confirmation;
   TVP_Volume       *volume;
   TVP_Exit         *exit;
   LossPerDay       *lossCheck;
   TradingFunctions *TF;
      TradeClassifier *TC;

public:
   string            SYMBOL;
   double            ATR_CURRENT;
                     TVP(string symbol);
                    ~TVP();
   void              Execute();
   void              Statistics();
   void              Update_LastTradeTime();
   datetime          Get_LastTradeTime();
   void              logdata(ulong ticket,double openPrice,ENUM_POSITION_TYPE posType,double lot,double atr,double baseline,double primary,double confirmation,double confirmation2,double exit,double sl,double tp);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TVP::TVP(string symbol)
  {
   SYMBOL=symbol;
   
   baseline=new TVP_BaseLine(SYMBOL,TRADING_PERIOD);
//primary = new TVP_PrimaryIndicator(SYMBOL,TRADING_PERIOD);
//volume = new TVP_Volume(SYMBOL,TRADING_PERIOD);
   confirmation=new TVP_ConfirmationIndicator(SYMBOL,TRADING_PERIOD);
   exit=new TVP_Exit(SYMBOL,TRADING_PERIOD);
   atr=new TVP_ATR(SYMBOL,TRADING_PERIOD,ATR_PERIOD);
   double point = SymbolInfoDouble(SYMBOL, SYMBOL_POINT);
   TF=new TradingFunctions(SYMBOL,TRADING_PERIOD);
   TC = new TradeClassifier(SYMBOL);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TVP::~TVP()
  {
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TVP::Execute()
  {

//Statistics

   Statistics();
   STATISTICS.suspend_new =false;
   STATISTICS.suspend_buy =false;
   STATISTICS.suspend_sell=false;
   
   //Classifier Strategy
   TC.PipsMonitor();

//ScaleOut();
//LOSS PER DAY
//lossCheck.Execute();

//ATR

   double ATR=atr.getATR();
   double point=SymbolInfoDouble(SYMBOL,SYMBOL_POINT);
   if(point ==0) return;
   double atR=ATR/point/10;
   TF.ATR_CURRENT=ATR;
//if(atR <20) return; 
   STATISTICS.ATR=ATR;

//EXIT INDICATOR   


   //exit.getExit();
   point  = SymbolInfoDouble(SYMBOL, SYMBOL_POINT);
   double effectiveATR = ATR/point/10/100;
   
   TF.GlobalTakeProfit(effectiveATR);
   TF.GlobalStopLoss(effectiveATR);
   //TF.GlobalPairTakeProfit(effectiveATR);
   TF.GlobalExit();
   TF.GlobalReducePositions(effectiveATR);
   TF.GlobalPositiveTakeProfit(effectiveATR);

//exit.PRIMARY_BUY = primary.PRIMARY_BUY;
//exit.PRIMARY_SELL = primary.PRIMARY_SELL;
   exit.CONFIRMATION_BUY=confirmation.CONFIRMATION_BUY;
   exit.CONFIRMATION_SELL=confirmation.CONFIRMATION_SELL;

//VOLUME
   bool VOLUME=true;// volume.getVolume();
                    //STATISTICS.Volume=VOLUME;
//if(VOLUME =false) return;

//BASELINE
   baseline.getBaseLine();
//STATISTICS.BaseLine=baseline.BASELINE;
//Comment("Gap: "+DoubleToString(STATISTICS.gap,2));

//CONFIRMATION TREND INDICATOR
   confirmation.getConfirmation();

//Update Trailing Stop Loss
   TF.trailing_StopLoss();

//STATISTICS.suspend_new =false;
//STATISTICS.suspend_buy =false;
//STATISTICS.suspend_sell =false;
//if(confirmation.CONFIRMATION_BUY) baseline.BASELINE_BUY =true;
//if(confirmation.CONFIRMATION_SELL) baseline.BASELINE_SELL =true;

//if(!(baseline.BASELINE_BUY ||baseline.BASELINE_SELL)) return;
   if(!(confirmation.CONFIRMATION_BUY||confirmation.CONFIRMATION_SELL)) return;
   STATISTICS.Confirmation=confirmation.CONFIRMATION;

//PRIMARY TREND INDICATOR
// primary.getPrimary();
//STATISTICS.Primary_AroonUp=primary.PRIMARY_AROONUP;
//STATISTICS.Primary_AroonDown=primary.PRIMARY_AROONDOWN;




//BUY ENTRY 
   if(atr.BUY_ALLOWED || true)
     { //TRADE LIMIT
      if(baseline.BASELINE_BUY || true)
        { //WITHIN BASELINE
         if(primary.PRIMARY_BUY || true)
           { //PRIMARY TREND
            if(confirmation.CONFIRMATION_BUY)
              { //TREND CONFIRMATION
               if(VOLUME || true)
                 { //VOLUME FUEL
                  if(!(STATISTICS.suspend_new || STATISTICS.suspend_buy))
                    {
                     //if(DATA.workbook.Pairs[p].BUY_ALLOWED && DATA.workbook.Pairs[p].BUY_POSITIONS<MAX_TRADES)
                       {
                        if(!exit.EXIT_BUY || true)
                          {
                           if(STATISTICS.BuyTrades<MAX_TRADES)
                             {
                              int timeDiff=(int)(TimeCurrent()-Get_LastTradeTime());
                              if(timeDiff>INTER_TRADE_WAIT_SECONDS) // Inter-Trade Wait
                                {
                                 //Trade Buy
                                 double atrr = atr.ATR;
                                 int magic=MathRand();
                                 //TF.tradeBuy(atr.SL_BUY,magic,atr.TP_BUY,atr.LOT,atr.ATR);
                                 //TF.tradeBuy(atr.SL_BUY,magic,0,atr.LOT,atr.ATR);
                                 
                                 TF.tradeBuy(0,magic,atr.TP_BUY,atr.LOT,atr.ATR/point/10);
                                 TF.tradeBuy(0,magic,0,atr.LOT,atr.ATR/point/10);
                                 
                                 
                                 Update_LastTradeTime();
                                 //TF.tradeBuy(0,magic,0,atr.LOT);
                                 //LOG
                                 double price=SymbolInfoDouble(SYMBOL,SYMBOL_ASK);
                                 //logdata(TF.lastTicket,price,POSITION_TYPE_BUY,atr.LOT,atr.ATR,baseline.BASELINE,0,confirmation.CONFIRMATION,0,0,atr.SL_BUY,atr.TP_BUY);

                                 //log
                                 //TF.tradeBuy(atr.SL_BUY,magic,0,atr.LOT);
                                }
                             }
                          }
                       }
                    }
                 }
              }
           }
        }
     }
//SELL ENTRY 
   if(atr.SELL_ALLOWED || true)
     { //TRADES LIMIT
      if(baseline.BASELINE_SELL|| true)
        { //WITHIN BASELINE
         if(primary.PRIMARY_SELL || true)
           { //PRIMARY TREND
            if(confirmation.CONFIRMATION_SELL)
              { //TREND CONFIRMATION
               if(VOLUME)
                 { //VOLUME FUEL
                  if(!(STATISTICS.suspend_new || STATISTICS.suspend_sell))
                    {
                     //if(DATA.workbook.Pairs[p].SELL_ALLOWED && DATA.workbook.Pairs[p].SELL_POSITIONS<MAX_TRADES)
                       {
                        //if(!exit.EXIT_SELL)
                          {
                           if(STATISTICS.SellTrades<MAX_TRADES)
                             {
                              datetime tNow = TimeCurrent();
                              datetime tLast =    Get_LastTradeTime();
                              int diff = (int)(tNow - tLast);
                              int timeDiff=(int)(TimeCurrent()-Get_LastTradeTime());
                              if(timeDiff>INTER_TRADE_WAIT_SECONDS) // Inter-Trade Wait
                                {
                                 //Trade Sell 
                                 double atrr = atr.ATR;  
                                 int magic=MathRand();
                                 //TF.tradeSell(atr.SL_SELL,magic,atr.TP_SELL,atr.LOT,atr.ATR);
                                 //TF.tradeSell(atr.SL_SELL,magic,0,atr.LOT,atr.ATR);
                                 
                                 TF.tradeSell(0,magic,atr.TP_SELL,atr.LOT,atr.ATR/point/10);
                                 TF.tradeSell(0,magic,0,atr.LOT,atr.ATR/point/10);
                                 
                                 Update_LastTradeTime();
                                 //TF.tradeSell(0,magic,0,atr.LOT);
                                 double price=SymbolInfoDouble(SYMBOL,SYMBOL_BID);
                                 //log
                                 //logdata(TF.lastTicket,price,POSITION_TYPE_SELL,atr.LOT,atr.ATR,baseline.BASELINE,0,confirmation.CONFIRMATION,0,0,atr.SL_SELL,atr.TP_SELL);
                                }
                             }
                          }
                       }
                     //TF.tradeSell(atr.SL_SELL,magic,0,atr.LOT);
                    }
                 }
              }
           }
        }
     }

  }
//+------------------------------------------------------------------+
void TVP::Statistics()
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
      if(ENABLE_EQUITY_TAKE) TF.GlobalExit(true);
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
void TVP::Update_LastTradeTime()
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  {
   if(SYMBOL=="AUDCAD") {LastTrade[1]=TimeCurrent();}
   if(SYMBOL == "AUDCHF")  {LastTrade[2] = TimeCurrent();}
   if(SYMBOL == "AUDJPY")  {LastTrade[3] = TimeCurrent();}
   if(SYMBOL == "AUDNZD")  {LastTrade[4] = TimeCurrent();}
   if(SYMBOL == "AUDUSD")  {LastTrade[5] = TimeCurrent();}
   if(SYMBOL == "CADCHF")  {LastTrade[6] = TimeCurrent();}
   if(SYMBOL == "CADJPY")  {LastTrade[7] = TimeCurrent();}
   if(SYMBOL == "CHFJPY")  {LastTrade[8] = TimeCurrent();}
   if(SYMBOL == "EURAUD")  {LastTrade[9] = TimeCurrent();}
   if(SYMBOL == "EURCAD")  {LastTrade[10] = TimeCurrent();}
   if(SYMBOL == "EURCHF")  {LastTrade[11] = TimeCurrent();}
   if(SYMBOL == "EURGBP")  {LastTrade[12] = TimeCurrent();}
   if(SYMBOL == "EURJPY")  {LastTrade[13] = TimeCurrent();}
   if(SYMBOL == "EURNZD")  {LastTrade[14] = TimeCurrent();}
   if(SYMBOL == "EURUSD")  {LastTrade[15] = TimeCurrent();}
   if(SYMBOL == "GBPAUD")  {LastTrade[16] = TimeCurrent();}
   if(SYMBOL == "GBPCAD")  {LastTrade[17] = TimeCurrent();}
   if(SYMBOL == "GBPCHF")  {LastTrade[18] = TimeCurrent();}
   if(SYMBOL == "GBPJPY")  {LastTrade[19] = TimeCurrent();}
   if(SYMBOL == "GBPNZD")  {LastTrade[20] = TimeCurrent();}
   if(SYMBOL == "GBPUSD")  {LastTrade[21] = TimeCurrent();}
   if(SYMBOL == "NZDCHF")  {LastTrade[22] = TimeCurrent();}
   if(SYMBOL == "NZDJPY")  {LastTrade[23] = TimeCurrent();}
   if(SYMBOL == "NZDUSD")  {LastTrade[24] = TimeCurrent();}
   if(SYMBOL == "USDCAD")  {LastTrade[25] = TimeCurrent();}
   if(SYMBOL == "USDCHF")  {LastTrade[26] = TimeCurrent();}
   if(SYMBOL == "USDJPY")  {LastTrade[27] = TimeCurrent();}


  }
//+------------------------------------------------------------------+
datetime TVP::Get_LastTradeTime()
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  {
   if(SYMBOL=="AUDCAD") {return LastTrade[1];}
   if(SYMBOL == "AUDCHF")  {return LastTrade[2];}
   if(SYMBOL == "AUDJPY")  {return LastTrade[3];}
   if(SYMBOL == "AUDNZD")  {return LastTrade[4];}
   if(SYMBOL == "AUDUSD")  {return LastTrade[5];}
   if(SYMBOL == "CADCHF")  {return LastTrade[6];}
   if(SYMBOL == "CADJPY")  {return LastTrade[7];}
   if(SYMBOL == "CHFJPY")  {return LastTrade[8];}
   if(SYMBOL == "EURAUD")  {return LastTrade[9];}
   if(SYMBOL == "EURCAD")  {return LastTrade[10];}
   if(SYMBOL == "EURCHF")  {return LastTrade[11];}
   if(SYMBOL == "EURGBP")  {return LastTrade[12];}
   if(SYMBOL == "EURJPY")  {return LastTrade[13];}
   if(SYMBOL == "EURNZD")  {return LastTrade[14];}
   if(SYMBOL == "EURUSD")  {return LastTrade[15];}
   if(SYMBOL == "GBPAUD")  {return LastTrade[16];}
   if(SYMBOL == "GBPCAD")  {return LastTrade[17];}
   if(SYMBOL == "GBPCHF")  {return LastTrade[18];}
   if(SYMBOL == "GBPJPY")  {return LastTrade[19];}
   if(SYMBOL == "GBPNZD")  {return LastTrade[20];}
   if(SYMBOL == "GBPUSD")  {return LastTrade[21];}
   if(SYMBOL == "NZDCHF")  {return LastTrade[22];}
   if(SYMBOL == "NZDJPY")  {return LastTrade[23];}
   if(SYMBOL == "NZDUSD")  {return LastTrade[24];}
   if(SYMBOL == "USDCAD")  {return LastTrade[25];}
   if(SYMBOL == "USDCHF")  {return LastTrade[26];}
   if(SYMBOL == "USDJPY")  {return LastTrade[27];}

   return -1;

  }
//+------------------------------------------------------------------+
