//+------------------------------------------------------------------+
//|                                                     SimpleEA.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//--- input parameters
input int      StopLoss=30;  //Stop Loss
input int      TakeProfit=30;  //Take profit
input int      ADX_Period=8;   //ADX period
input int      MA_Period=8;   //Moving Average period
input int      EA_Magic=12345; //EA Magic Number for  all orders by the EA
input double   Adx_Min=22.0;   //Minimum ADX valuea
input double   Lot=0.1;   //Lots to Trade

//Other parameters

int adxHandle; //handle for our ADX indicator
int maHandle; //handle for our moving average indicator
double plsDI[],minDI[],adxVal[];//Dynamic arrays to hold the values of +DI,-DI and ADX values for each bars
double maVal[];//Dynamic array to hold the values of the Moving Average
double p_close; //Variable to store the close value of a bar to monitor for checking the Buy/Sell Trades
int STP,TKP; //Variables to store the TakeProfit and StopLoss 
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
//-- Get the handle for the ADX indicator
 adxHandle=iADX(NULL //Current symbol on the current chart
       ,0 //The current timeframe on the current chart
        ,ADX_Period //The ADX averaging period for calculating the index
          );
 
//--Get the handle for the Moving Average indicator
   maHandle=iMA(_Symbol,_Period,MA_Period,0,MODE_EMA,PRICE_CLOSE);

//--What if handle returns Invalid Handle
  if(adxHandle<0||maHandle<0)
  {
  Alert("Error catching Handles for indicators",GetLastError(),"!!!");
  
  }  
  //--Let us handle currency pairs with 5 or 3 digits
  STP=StopLoss;
  TKP=TakeProfit;
  if(_Digits==5||_Digits==3){
  STP=STP*10;
  TKP=TKP*10;
  }
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---Release the indicator handles
  IndicatorRelease(adxHandle);
  IndicatorRelease(maHandle);
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
// Do we have enough bars to work with
   if(Bars(_Symbol,_Period)<60) // if total bars is less than 60 bars
     {
      Alert("We have less than 60 bars, EA will now exit!!");
      return;
     }
// We will use the static Old_Time variable to serve the bar time.
// At each OnTick execution we will check the current bar time with the saved one.
// If the bar time isn't equal to the saved time, it indicates that we have a new tick.
   static datetime Old_Time;
   datetime New_Time[1];
   bool IsNewBar=false;

// copying the last bar time to the element New_Time[0]
   int copied=CopyTime(_Symbol,_Period,0,1,New_Time);
   if(copied>0) // ok, the data has been copied successfully
     {
      if(Old_Time!=New_Time[0]) // if old time isn't equal to new bar time
        {
         IsNewBar=true;   // if it isn't a first call, the new bar has appeared
         if(MQL5InfoInteger(MQL5_DEBUGGING)) Print("We have new bar here ",New_Time[0]," old time was ",Old_Time);
         Old_Time=New_Time[0];            // saving bar time
        }
     }
   else
     {
      Alert("Error in copying historical times data, error =",GetLastError());
      ResetLastError();
      return;
     }

//--- EA should only check for new trade if we have a new bar
   if(IsNewBar==false)
     {
      return;
     }
 
//--- Do we have enough bars to work with
   int Mybars=Bars(_Symbol,_Period);
   if(Mybars<60) // if total bars is less than 60 bars
     {
      Alert("We have less than 60 bars, EA will now exit!!");
      return;
     }

//--- Define some MQL5 Structures we will use for our trade
   MqlTick latest_price;     // To be used for getting recent/latest price quotes
   MqlTradeRequest mrequest;  // To be used for sending our trade requests
   MqlTradeResult mresult;    // To be used to get our trade results
   MqlRates mrate[];         // To be used to store the prices, volumes and spread of each bar
   ZeroMemory(mrequest);     // Initialization of mrequest structure
   
  }
//+------------------------------------------------------------------+
