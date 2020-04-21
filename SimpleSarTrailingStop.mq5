#include<Trade\Trade.mqh>
//Create an instance of CTrade
CTrade trade;

void OnTick()
  {
//We call the Bid price
double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

//Open test position and sell 10 microlots
if(PositionsTotal()<1)
trade.Sell(0.10,NULL,Bid,0,(Bid-150*_Point),NULL);

//Create a SAR array
double mySARArray[];

//Defined SAR EA ,current candle,3 candles,save the result
int SARDefinition=iSAR(_Symbol,_Period,0.02,0.2);

//Sort the array from the current candle downwards
ArraySetAsSeries(mySARArray,true);

//Defined EA ,current buffer,current candle,3 candles,save in array
CopyBuffer(SARDefinition,0,0,3,mySARArray);

//Calculate the value for the last candle
double SARValue=NormalizeDouble(mySARArray[0],5);

//Check the trailing stop
CheckSarSellTrailingStop(Bid,SARValue);

   
  }
void CheckSarSellTrailingStop(double Bid,double SARValue){
//Go through all positions
for(int i=PositionsTotal()-1;i>=0;i--)
{
string symbol=PositionGetSymbol(i);//Get the symbol of the position
//check if the current working symbol and the symbol on the chart are equal
if(_Symbol==symbol)//Check if the current symbol and the current symbol on the chart are equal
{
//Get the ticket number
ulong PositionTicket=PositionGetInteger(POSITION_TICKET);

//Calculate the current stop loss
double CurrentStopLoss=PositionGetDouble(POSITION_SL);
//if the current stop loss is below the SAR value
if((CurrentStopLoss>SARValue)||(CurrentStopLoss==0)){
//move the stop loss
trade.PositionModify(PositionTicket,SARValue,0);
}}}
}