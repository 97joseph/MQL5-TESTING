//Create an EA that buys and sells 1 lot every 10 pips movement 
//Adjust for spread so that profit and loss is acheieved afeter overcoming spread
//Adjust for multiple positions as a user input

//Library include files

#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>  
CPositionInfo  m_position;                   // trade position object
CTrade         m_trade;                      // trading object
CSymbolInfo    m_symbol;                     // symbol info object






//User input Parameters
input int NumCandles=1000;
input int MAXIMUMPOSITIONS=3;
input double DIRECTIONALPIPS=10;
input double TAKEPROFITPIPS=20;
input double STOPLOSSPIPS=20;



void OnStart()
  {
//---
   int bulls=0,bears=0;
   double op[],cl[];
   int sp[];
   if(CopyOpen(_Symbol,PERIOD_CURRENT,0,NumCandles,op)<0) return;
   if(CopyClose(_Symbol,PERIOD_CURRENT,0,NumCandles,cl)<0) return;
   if(CopySpread(_Symbol,PERIOD_CURRENT,0,NumCandles,sp)<0) return;
   for(int i=0; i<NumCandles; i++)
     {
      if(cl[i]-op[i]>sp[i]*_Point) bulls++; 
      if(op[i]-cl[i]>sp[i]*_Point) bears++; 
     }
   MessageBox(_Symbol+"   "+StringSubstr(EnumToString(_Period),7)+"\n"+
              "Candles "+IntegerToString(NumCandles)+"\n"+
              "Bulls "+IntegerToString(bulls)+"\n"+
              "Bears "+IntegerToString(bears));
  }
//+------------------------------------------------------------------+
