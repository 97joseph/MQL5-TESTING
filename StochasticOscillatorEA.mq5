#include<Trade\Trade.mqh>
//Create an instance of CTrade
CTrade trade;

void OnTick()
  {
//Create a string for the signal
string signal="";
// calcuate the Ask Price
double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);

// calculate the the Bid price
double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

// create an array for the K-line and D-line
double KArray[];
double DArray[];

//Defined EA,current candle,3 candles,save the result
int StochasticDefinition=iStochastic(_Symbol,_Period,5,3,3,MODE_SMA,STO_LOWHIGH);

//fill the array with price data
CopyBuffer(StochasticDefinition,0,0,3,KArray);

CopyBuffer(StochasticDefinition,1,0,3,DArray);

// calculate the value for the current candle
double KValue0=KArray[0];
double DValue0=DArray[0];
// calculate the value for the last candle
double KValue1=KArray[1];
double DValue1=DArray[1];

//buy signal

//if both values are below 20
if(KValue0<20 && DValue0<20)
//if the KValue has crossed the Dvalue from below
if((KValue0>DValue0)&&(KValue1<DValue1))
{
signal="buy";
}

//sell signal
//if both values are above 80
if(KValue0>80 && DValue0>80)
//if the KValue has crossed the DValue from above
if((KValue0<DValue0) && (KValue1>DValue1))
{
signal="sell";
}

//Sell 10 microlot
if(signal=="sell" && PositionsTotal()<1)
trade.Sell(0.3,NULL,Bid,0,(Bid-20*_Point),NULL);

//Buy 10 microlot
if(signal=="buy" && PositionsTotal()<1)
trade.Buy(0.3,NULL,Ask,0,(Ask+20*_Point),NULL);

//Create a chart output
Comment("The current signal is: ",signal);

  }
//+------------------------------------------------------------------+
