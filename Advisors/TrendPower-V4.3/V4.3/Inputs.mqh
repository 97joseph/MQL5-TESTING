//+------------------------------------------------------------------+
//|                                                       Inputs.mqh |
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
int BARSHAPE[6];
//System Inputs
datetime START;
double escalated_lot_size;
double bufferGlobalTakeProfit=0;
double GlobalTakeProfitTrail=0.9;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum Schauff_Smooth_Method
  {
   MODE_SMA_,  //SMA
   MODE_EMA_,  //EMA
   MODE_SMMA_, //SMMA
   MODE_LWMA_, //LWMA
   MODE_JJMA,  //JJMA
   MODE_JurX,  //JurX
   MODE_ParMA, //ParMA
   MODE_T3,     //T3
   MODE_VIDYA,  //VIDYA
   MODE_AMA     //AMA
  };
  
struct LastTrade
{
   ulong ticket;
   datetime openTime;
   ENUM_POSITION_TYPE type;
   int PositionsOpen;
   int buyTrades;
   int sellTrades;
   double lastPrice;
   double lastBuyPrice;
   double lastSellPrice;
   double lotsize;
}; 

struct SLTP
{
   double SL;
   double TP;
   double ask;
   double bid;
};

/*

#define ATR_SL_FACTOR 3
#define ATR_TP_FACTOR 1
#define MAX_TRADES 1
#define INTER_TRADE_PIPS 2
*/
//User Inputs

input string Single_Trade_Settings = "_________Single Trade Settings _________";
input double LOT=0.01;
input double TAKE_PROFIT_PIPS = 20;
input double STOP_LOSS_PIPS = 20;
input bool ENABLE_STOP_ON_ATR = true;
input double ATR_STOP_MULTIPLIER =1;

input  ENUM_MA_METHOD   TREND_POWER_SMOOTHING_METHOD=MODE_EMA;          // smoothing method
input ENUM_APPLIED_PRICE   TREND_POWER_PRICE_TYPE=PRICE_CLOSE;   // type of price
input int    TREND_POWER_HORIZONTAL_SHIFT=0; 
input double TREND_POWER_REQUIRE_PIP_GAP = 10;
input double TREND_POWER_MAX_PIP_GAP = 10;
input double INTER_TRADE_PIPS = 10;
input bool ENABLE_INCLUDE_SPREAD_IN_PIPS =true;

input string Trading_Window_Settings="___Trading Window Settings_____";
   input ENUM_TIMEFRAMES TRADING_PERIOD=PERIOD_W1;
   input uint   TREND_POWER_PERIOD_STEP=10; 

   
   input int MAX_TRADES=10;
   input int MAX_BUY_TRADES=10;
   input int MAX_SELL_TRADES=10;
   int input INTER_TRADE_WAIT_SECONDS = 86400;
   
   input string Global_Take_Settings = "__________Global Take Settings__________";

   double input GLOBAL_TAKE_PROFIT=200;
   input double GLOBAL_STOP_LOSS=-200;

/*
input string Equity_Take_Settings="____Equity Take Settings____";

   string input _____EQUITY_TAKE____="";
   bool input ENABLE_EQUITY_TAKE=true;
   double input  EQUITY_TAKE_THRESHOLD=0.99;


   input bool ENABLE_GLOBAL_STOP_LOSS =false;
   

*/
/*

input string Classifier_Settings="________";
input double BenchMarkProfit=0;
input double PipsMoveWindow = 10;
input double BenchMarkOverallProfitability=1;

input double ATR_MAX_INDIVIDUAL_LOSS=-20;

input bool ENABLE_GLOBAL_POSITIVE_TAKE=false;
input double GLOBAL_POSITIVE_TAKE_LOSS_TRIGGER=-200;
input double ATR_RATIO_POSITIVE_TAKE_PROFIT=20;

//RISk MANAGEMENT
string input _____RISK_MANAGEMENT____="";
input double ALLOWED_RISK=0.02;
//ESCALATION
input double LINEAR_ESC_OFFSET=0;
input double EXPONENTIOAL_ESC_OFFSET=2;

//ATR PARAMETERS
string input _ATR_="";
input ENUM_TIMEFRAMES ATR_TIMEFRAME=PERIOD_D1;
input int ATR_PERIOD=5;
input double ATR_SL_FACTOR=1;
input double ATR_TP_FACTOR=1;
input int MAX_TRADES=10;

input string ________Baseline___________="----------------BASELINE INDICATORS-------------";
//input string ___ROC_Parameters_____ = "--ROC PARAMETERS--";
input int ROC_PERIOD=14;
//input string ___SLOPE_Parameters_____ = "--LREG SLOPE PARAMETERS--";
input int SLOPE_PERIOD=40;
input ENUM_TIMEFRAMES SLOPE_TIMEFRAME=PERIOD_D1;
input double SLOPE_HYSTERISIS=40;
input string ________CONFIRMATION___________="----------------CONFIRMATION INDICATORS-------------";
input Schauff_Smooth_Method SCHAUFF_SMOOTH_METHOD=MODE_EMA_;
input int Schauff_Fast_MA=6;
//23;
input int Schauff_Slow_MA=12;
//50;
input int Schauff_MA_Smoothing=100;
input int Schauff_stochastic_period=30;
input int keltner_channel_PERIOD=5;
input ENUM_MA_METHOD Keltner_MA_Method=MODE_EMA;
input double keltner_Ratio=0.7;
input double keltner_Horizontal_Shift= 0;
input string ________EXIT___________ = "----------------EXIT INDICATORS-------------";
input double Parabolic_SAR_Step=0.05;
// 0.1;
input double Parabolic_SAR_Max=0.4;
// 20;

*/

string input _TradingPairs_="";
bool input AUDCAD = false;
bool input AUDCHF = false;
bool input AUDJPY = false;
bool input AUDNZD = false;
bool input AUDUSD = false;
bool input CADCHF = false;
bool input CADJPY = false;
bool input CHFJPY = false;
bool input EURAUD = false;
bool input EURCAD = false;
bool input EURCHF = false;
bool input EURGBP = false;
bool input EURJPY = false;
bool input EURNZD = false;
bool input EURUSD = true;
bool input GBPAUD = false;
bool input GBPCAD = false;
bool input GBPCHF = false;
bool input GBPJPY = false;
bool input GBPNZD = false;
bool input GBPUSD = false;
bool input NZDCHF = false;
bool input NZDJPY = false;
bool input NZDUSD = false;
bool input USDCAD = false;
bool input USDCHF = false;
bool input USDJPY = false;



//GLOBAL VARIABLES;
double CONVERSION_FACTOR=1;
double VOLUME_TARGET=2000;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct Statistics
  {
   int               BuyTrades;
   int               SellTrades;

   double            ATR;
   double            BaseLine;
   double            Primary_AroonUp;
   double            Primary_AroonDown;
   double            Confirmation;
   double            Volume;
   double            EquityMaxDrop;
   double            EquityMinGrowth;
   double            RefEquity;
   double            RefCapital;
   ulong             last_ticket_TP;
   bool              suspend_new;
   bool              suspend_buy;
   bool              suspend_sell;
   double            gap;
   double            slope;
   double            sl_buy;
   double            sl_sell;

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct PositionManagement
  {
   ulong             ticket;
   ulong             stopLoss;
   ulong             takeProfit;
   ulong             openPrice;

  };

ulong buyTrades[];
ulong sellTrades[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct LogData
  {
   datetime          date;
   string            Sym;
   ulong             ticket;
   ENUM_POSITION_TYPE posType;
   double            lot;
   double            sl;
   double            tp;
   double            atr;
   double            openPrice;
   double            baseline;
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
struct positionLog
  {
   datetime          date;
   string            Sym;
   ulong             ticket;
   ENUM_POSITION_TYPE posType;
   double            lot;
   double            sl;
   double            tp;
   double            atr;
   double            openPrice;
   double            baseline;
   double            primary;
   double            confirmation;
   double            cofirmation2;
   double            exit;
   double            closePrice;
   double            profit;

  };
//+------------------------------------------------------------------+
