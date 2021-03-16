//+------------------------------------------------------------------+
//|                                              TradeClassifier.mqh |
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


   
class TradeClassifier
  {
private:
   double            ClosedBuyTradesProfit;
   double            ClosedSellTradesProfit;

   double            FloatingBuyTradesPosition;
   double            FloatingSellTradesPosition;

   //double            BenchMarkProfit;
   //double            BenchMarkOverallProfitability;
   double            cumBuyTradeProfitsClosed;
   double            cumSellTradeProfitsClosed;
   double            pipsMoved;
   //double            PipsMoveWindow;
   double            lastPricePoint;
   TradingFunctions *TF;
   string            SYMBOL;
public:
                     TradeClassifier(string sym);
                    ~TradeClassifier();
   void              ClassifyTrades();
   void              CloseTradesInProfit();
   void              PipsMonitor();
   void              MonitorOverallProfitability();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TradeClassifier::TradeClassifier(string sym)
  {

   ClosedBuyTradesProfit=0;
   ClosedSellTradesProfit=0;

   FloatingBuyTradesPosition=0;
   FloatingSellTradesPosition=0;

   cumBuyTradeProfitsClosed=0;
   cumSellTradeProfitsClosed=0;
   pipsMoved=0;

   SYMBOL=sym;

   lastPricePoint=SymbolInfoDouble(SYMBOL,SYMBOL_BID);
   TF=new TradingFunctions(SYMBOL,TRADING_PERIOD);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TradeClassifier::~TradeClassifier()
  {
  }
//+------------------------------------------------------------------+
void TradeClassifier::ClassifyTrades()
  {
// populate buyTrades & Sell Trades Floating Profits;
   int total= PositionsTotal();
   for(int i=total-1;i>0;i--)
     {
      ulong ticket=PositionGetTicket(i);
      double profit=PositionGetDouble(POSITION_PROFIT);
      ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE) PositionGetInteger(POSITION_TYPE);
      if(type==POSITION_TYPE_BUY)
        {
         FloatingBuyTradesPosition=FloatingBuyTradesPosition+profit;
         if(profit>BenchMarkProfit)
           {
            TF.exitSingleTrade(i,"ClassifierProfits",ticket);
            ClosedBuyTradesProfit=ClosedBuyTradesProfit+profit;
            FloatingBuyTradesPosition=FloatingBuyTradesPosition-profit;
           }

        }

      if(type==POSITION_TYPE_SELL)
        {
         FloatingSellTradesPosition=FloatingSellTradesPosition+profit;
         if(profit>BenchMarkProfit)
           {
            TF.exitSingleTrade(i,"ClassifierProfits",ticket);
            ClosedSellTradesProfit=ClosedSellTradesProfit+profit;
            FloatingSellTradesPosition=FloatingSellTradesPosition-profit;
           }
        }

     }
  }
//+------------------------------------------------------------------+
void TradeClassifier::CloseTradesInProfit()
  {
// populate buyTrades & Sell Trades Floating Profits;

  }
//+------------------------------------------------------------------+
void TradeClassifier::PipsMonitor()
  {
// Monitor performance over given PIPS intervals.
   double currentPrice=SymbolInfoDouble(SYMBOL,SYMBOL_BID);
   double point=SymbolInfoDouble(SYMBOL,SYMBOL_POINT);
   if(point ==0) return;
   pipsMoved=MathAbs(currentPrice-lastPricePoint)/point/10;

   if(pipsMoved>PipsMoveWindow)
     {
      ClassifyTrades();
      MonitorOverallProfitability();
      lastPricePoint=currentPrice;

     }

  }
//+------------------------------------------------------------------+

void TradeClassifier::MonitorOverallProfitability()
  {
// Monitor Overall performance to check if overall Profitability Targets met.
   double CumBuyProfits=ClosedBuyTradesProfit+FloatingBuyTradesPosition;
   double CumSellProfits=ClosedSellTradesProfit+FloatingSellTradesPosition;
   double CumProfits=CumBuyProfits+CumSellProfits;

   if(CumProfits>BenchMarkOverallProfitability)
     {
      TF.Exit("SELL","ClassifierOverall_ALL_ProfitMet");
      TF.Exit("BUY","ClassifierOverall_ALL_ProfitMet");
      ClosedSellTradesProfit=0;
      FloatingSellTradesPosition=0;
      ClosedBuyTradesProfit=0;
      FloatingBuyTradesPosition=0;

     }

   if(CumBuyProfits>BenchMarkOverallProfitability)
     {
      TF.Exit("BUY","ClassifierOverall_BUY_ProfitMet");
      ClosedBuyTradesProfit=0;
      FloatingBuyTradesPosition=0;
     }

   if(CumSellProfits>BenchMarkOverallProfitability)
     {
      TF.Exit("SELL","ClassifierOverall_SELL_ProfitMet");
      ClosedSellTradesProfit=0;
      FloatingSellTradesPosition=0;
     }

  }
//+------------------------------------------------------------------+
