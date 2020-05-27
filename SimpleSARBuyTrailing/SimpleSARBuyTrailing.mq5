//The simple SAR indicator adjust the the The Current Stop Loss
#include<Trade\Trade.mqh>
//Create an instance of CTrade
//The 
CTrade trade; 
void OnTick()
  {
//We calculate the Ask price
double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);

//Open the test position and buy 10 microlot
if(PositionsTotal()<1)
trade.Buy(0.10,NULL,Ask,0,(Ask+150*_Point),NULL);   
  
  //create a SAR array
  double mySARArray[];
  
  //Defined SAR EA ,current,3 candles ,save the result
  int SARDefinition=iSAR(_Symbol,_Period,0.02,0.2);
  //sort the array from the current candle downwards
  ArraySetAsSeries(mySARArray,true);
  
  //Defined EA,current buffer,current candle,3 candles,save in array
  CopyBuffer(SARDefinition,0,0,3,mySARArray);
  //Calculate the value for the last candle
  double SARValue=NormalizeDouble(mySARArray[0],5);
  
  //Check the trailing Stop
  CheckSarBuyTrailingStop(Ask,SARValue);
  
  }
  void CheckSarBuyTrailingStop(double Ask,double SARValue){
  //Go through all positions
  for(int i=PositionsTotal()-1;i>=0;i--){
      string symbol=PositionGetSymbol(i);//Get the symbol of the position
        if(_Symbol==symbol)//If currency pair is equal
           {
            //get the ticket number
            ulong PositionTicket=PositionGetInteger(POSITION_TICKET);
            
            //calculate the current stop loss
            double CurrentStopLoss=PositionGetDouble(POSITION_SL);
            
            //If the current stop loss is below the SAR value
            if(CurrentStopLoss<SARValue)
            //move the stop loss
            trade.PositionModify(PositionTicket,SARValue,0);
            }
            
            
           } 
           } 
            
     