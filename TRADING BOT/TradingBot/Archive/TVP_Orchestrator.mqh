//+------------------------------------------------------------------+
//|                                             TVP_Orchestrator.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#include <..\Experts\TrendPower\V1\TVP.mqh>
#include <..\Experts\TrendPower\V1\Inputs.mqh>
#include <..\Experts\TrendPower\V1\SpreadSheet.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TVP_Orchestrator
  {
private:
   TVP              *tvp[27];
   int               SYMBOLS;
   string         PAIRS[];
   datetime       LastTrade[];
   
public:
                     TVP_Orchestrator();
                    ~TVP_Orchestrator();
                    int AddPair(string symbol);
   void              Execute();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TVP_Orchestrator::Execute()
  {
   
   for(int i=0;i<SYMBOLS;i++)
     {
      tvp[i].Execute();
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TVP_Orchestrator::TVP_Orchestrator()
  {

   int i=0;
   if(AUDCAD)  {i++;AddPair("AUDCAD");}
   if(AUDCHF)  {i++;AddPair("AUDCHF");}
   if(AUDJPY)  {i++;AddPair("AUDJPY");}
   if(AUDNZD)  {i++;AddPair("AUDNZD");}
   if(AUDUSD)  {i++;AddPair("AUDUSD");}
   if(CADCHF)  {i++;AddPair("CADCHF");}
   if(CADJPY)  {i++;AddPair("CADJPY");}
   if(CHFJPY)  {i++;AddPair("CHFJPY");}
   if(EURAUD)  {i++;AddPair("EURAUD");}
   if(EURCAD)  {i++;AddPair("EURCAD");}
   if(EURCHF)  {i++;AddPair("EURCHF");}
   if(EURGBP)  {i++;AddPair("EURGBP");}
   if(EURJPY)  {i++;AddPair("EURJPY");}
   if(EURNZD)  {i++;AddPair("EURNZD");}
   if(EURUSD)  {i++;AddPair("EURUSD");}
   if(GBPAUD)  {i++;AddPair("GBPAUD");}
   if(GBPCAD)  {i++;AddPair("GBPCAD");}
   if(GBPCHF)  {i++;AddPair("GBPCHF");}
   if(GBPJPY)  {i++;AddPair("GBPJPY");}
   if(GBPNZD)  {i++;AddPair("GBPNZD");}
   if(GBPUSD)  {i++;AddPair("GBPUSD");}
   if(NZDCHF)  {i++;AddPair("NZDCHF");}
   if(NZDJPY)  {i++;AddPair("NZDJPY");}
   if(NZDUSD)  {i++;AddPair("NZDUSD");}
   if(USDCAD)  {i++;AddPair("USDCAD");}
   if(USDCHF)  {i++;AddPair("USDCHF");}
   if(USDJPY)  {i++;AddPair("USDJPY");}

   SYMBOLS=i;


   i=0;
   for(i=0;i<SYMBOLS;i++)
     {
      string sym=PAIRS[i]; //Insert Symbols in Workbook
      tvp[i]=new TVP(sym);

     }
/*
      if(AUDCAD) {tvp[i] = new TVP( "AUDCAD"); i++;}
      if(AUDCHF) {tvp[i] = new TVP( "AUDCHF"); i++;}
      if(AUDJPY) {tvp[i] = new TVP( "AUDJPY"); i++;}
      if(AUDNZD) {tvp[i] = new TVP( "AUDNZD"); i++;}
      if(AUDUSD) {tvp[i] = new TVP( "AUDUSD"); i++;}
      if(CADCHF) {tvp[i] = new TVP( "CADCHF"); i++;}
      if(CADJPY) {tvp[i] = new TVP( "CADJPY"); i++;}
      if(CHFJPY) {tvp[i] = new TVP( "CHFJPY"); i++;}
      if(EURAUD) {tvp[i] = new TVP( "EURAUD"); i++;}
      if(EURCAD) {tvp[i] = new TVP( "EURCAD"); i++;}
      if(EURCHF) {tvp[i] = new TVP( "EURCHF"); i++;}
      if(EURGBP) {tvp[i] = new TVP( "EURGBP"); i++;}
      if(EURJPY) {tvp[i] = new TVP( "EURJPY"); i++;}
      if(EURNZD) {tvp[i] = new TVP( "EURNZD"); i++;}
      if(EURUSD) {tvp[i] = new TVP( "EURUSD"); i++;}
      if(GBPAUD) {tvp[i] = new TVP( "GBPAUD"); i++;}
      if(GBPCAD) {tvp[i] = new TVP( "GBPCAD"); i++;}
      if(GBPCHF) {tvp[i] = new TVP( "GBPCHF"); i++;}
      if(GBPJPY) {tvp[i] = new TVP( "GBPJPY"); i++;}
      if(GBPNZD) {tvp[i] = new TVP( "GBPNZD"); i++;}
      if(GBPUSD) {tvp[i] = new TVP( "GBPUSD"); i++;}
      if(NZDCHF) {tvp[i] = new TVP( "NZDCHF"); i++;}
      if(NZDJPY) {tvp[i] = new TVP( "NZDJPY"); i++;}
      if(NZDUSD) {tvp[i] = new TVP( "NZDUSD"); i++;}
      if(USDCAD) {tvp[i] = new TVP( "USDCAD"); i++;}
      if(USDCHF) {tvp[i] = new TVP( "USDCHF"); i++;}
      if(USDJPY) {tvp[i] = new TVP( "USDJPY"); i++;}
      */
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TVP_Orchestrator::~TVP_Orchestrator()
  {
  }
//+------------------------------------------------------------------+
int TVP_Orchestrator::AddPair(string symbol)
  {
      int size=ArraySize(PAIRS);
      ArrayResize(PAIRS,size+1);
      PAIRS[size]=symbol;
      return size;
  }