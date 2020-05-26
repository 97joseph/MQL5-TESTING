#include<Trade\Trade.mqh>

//Create an instance of CTrade
CTrade trade;

void OnTick()
  {
//We calculate the Ask price
double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
//We calculate the Bid price
double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
 
 //We create an array for the prices
 MqlRates PriceInfo[];
 //We sort the price array from the current candle downwards
 ArraySetAsSeries(PriceInfo,true);
 
 //We fill the array with the price data
 int PriceData=CopyRates(Symbol(),Period(),0,3,PriceInfo);
 
 //Create an empty string for the signal
   string signal="";
   
   //define the properties of the moving averages
   int SMA10Definition=iMA(_Symbol,_Period,10,0,MODE_SMA,PRICE_CLOSE);
   int SMA50Definition=iMA(_Symbol,_Period,50,0,MODE_SMA,PRICE_CLOSE);
   int SMA100Definition=iMA(_Symbol,_Period,100,0,MODE_SMA,PRICE_CLOSE);
   
   //Declare the arrays to be used
   double SMA10Array[];
   double SMA50Array[];
   double SMA100Array[];
  
  //Sort the price array from the current candle downwards
  ArraySetAsSeries(SMA10Array,true);
  ArraySetAsSeries(SMA50Array,true);
  ArraySetAsSeries(SMA100Array,true);
  
  //Defined EA ,one line,current candle,10 candles,store result
  CopyBuffer(SMA10Definition,0,0,10,SMA10Array);
  CopyBuffer(SMA50Definition,0,0,10,SMA50Array);
  CopyBuffer(SMA100Definition,0,0,10,SMA100Array);
  
  //Calculate the long signal
  if(SMA10Array[0]>SMA50Array[0])
  if(SMA50Array[0]>SMA100Array[0])
  {
  signal="buy";
  }
  
  //Calculate the short signal
  if(SMA10Array[0]<SMA50Array[0])
   if(SMA50Array[0]<SMA100Array[0])
   {
   signal="sell";
   }
   
   //Sell 10 microlots
   if(signal=="sell" && PositionsTotal()<1)
   trade.Sell(0.10,NULL,Bid,0,(Bid-150*_Point),NULL);
   
   //Buy 10 microlots
   if(signal=="buy" && PositionsTotal()<1)
   trade.Buy(0.10,NULL,Ask,0,(Ask+150*_Point),NULL);
   
   //Create a chart output
   Comment("The current signal is: ",signal);
  
  }
  
  
