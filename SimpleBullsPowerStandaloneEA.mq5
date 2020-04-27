#include<Trade\Trade.mqh>
//Create an instance of CTrade 
CTrade trade;
void OnTick()
  {
//Calculate the Ask price
double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);

//Calculate the Bid price
double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

//Create a string for the signal 
string signal="";

//Create an Array for prices
MqlRates PriceData[];

//Sort the array from the current  candle downwards
ArraySetAsSeries(PriceData,true);

//Copy the price data into the array
int Data=CopyRates(Symbol(),Period(),0,3,PriceData);

//Create an array for the EA data
double myPriceArray[];

//Sort the array from the current candle downwards
ArraySetAsSeries(myPriceArray,true);

//Define the Bulls power EA
int BullPowerDefinition=iBullsPower(_Symbol,_Period,13);

//fill the array with data
CopyBuffer(BullPowerDefinition,0,0,3,myPriceArray);

//Calculate the Array value
float BullsPowerValue=(myPriceArray[0]);

//if the Bulls Power value is above 0
if(BullsPowerValue>0)
signal="buy";

//if Bulls Power value is below 0
if(BullsPowerValue<0)
signal="sell";

//sell 10 microlot
if(signal=="sell" && PositionsTotal()<1)
trade.Sell(0.10,NULL,Bid,0,(Bid-150*_Point),NULL);

//buy 10 microlot
if(signal=="buy" && PositionsTotal()<1)
trade.Buy(0.10,NULL,Ask,0,(Ask+150*_Point),NULL);

Comment("The current signal is: ",signal);


   
  }
