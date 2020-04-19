//Import Trade.mqh\
#include<Trade\Trade.mqh>

//Create an instance of CTrade

void OnTick()
  {
 //Get the Ask price
 double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
 
 // if we have less than 10 positions
 if(PositionsTotal()<10)
 //Open 10 microlot buy postions
  trade.Buy(0.10,NULL,Ask,(Ask-1000*_Point),(Ask+150*_Point),NULL);
 
 //if we have exactly 10 positions
 if(PositionsTotal()==10)
 
   CloseAllBuyPositions();
 
  }
  void CloseAllBuyPositions(){
  for(int i=PositionsTotal()-1;i>=0;i--) //go throgh all positions
  {
  //Get the ticket number for the current position
  int ticket=PositionGetTicket(i);
  
  //Get the position direction
  int PositionDirection=PositionGetInteger(POSITION_TYPE);
  
  //if it is a buy position
  if(PositionDirection==POSITION_TYPE_BUY)
  //close the current position
  trade.PositionClose(ticket);
  
  
  }
  
  
  }
 