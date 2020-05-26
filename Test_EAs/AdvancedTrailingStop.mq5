//include the file Trade.mqh
#include<Trade\Trade.mqh>

//Create an instance of CTrade

CTrade trade;

void OnTick()
  {
  //Get the Ask price
  
  double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
  
  //if we have less than 2 positions
  
  if(PositionsTotal()<2)
  
  //Open 2 test buy positions
  
  trade.Buy(0.10,NULL,Ask,(Ask-1000*_Point),(Ask+500*_Point),NULL);
  
  //Call the TrailingStop Module
  
  CheckTrailingStop(Ask);  
   
  }
  
  //End of the OnTick function
  
void CheckTrailingStop(double Ask){

//Set the desired Stop Loss to 150 points

double SL=NormalizeDouble((Ask-150*_Point),Digits); 

//Check all open positions for the current symbol

for(int i=PositionsTotal()-1;i>=0;i--)//count all currency pair positions
{
string symbol=PositionGetSymbol(i);//get position symbol
}

if(_Symbol==symbol)

//if chart symbol equals position symbol

{
     //get the ticket number
     
     ulong PositionTicket=PositionGetInteger(POSITION_TICKET);
     
     //get the current Stop Loss
     
     double CurrentStopLoss=PositionGetDouble(POSITION_SL);
     
     //if the current Stop Loss is below 50 points from Ask Price
     
     if (CurrentStopLoss<SL) 
     {
     //Modify the Stop Loss by 10 points
     trade.PositionModify(PositionTicket,(CurrentStopLoss+10*_Point),0);
        }
       }///End of symbol if loop
   }//End of loop
}//End of Trailing Stop function
