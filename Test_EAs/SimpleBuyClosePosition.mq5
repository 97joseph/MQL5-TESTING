//ImportTrade.mqh
#include<Trade\Trade.mqh>

//Create an instance of Ctrade
CTrade trade;



void OnTick()
  {
           // Get the Ask price
                 double Ask=NormalizeDouble(SymboloInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
  
          //if we have less than 10 positions
             if(PositionsTotal()<10)
  
       //Open 1 lot buy positions
          trade.Buy(0.1,NULL,Ask,(Ask-1000*_Point),(Ask+150*_Point),NULL);
  
        //if we have exactlly 10 positions
      if(PositionsTotal()==10)
  
         //Close all open buy positions
          CloseAllBuyPositions();
  }
  
  void CloseAllBuyPositions()
          { 
 
                //count down until  there are no positions left
                        for(int i=PositionsTotal()-1;i>=0;i--)//go through all positions
                          {
                          
                          //Get the ticket number for the current position
                              int ticket=PositionGetTicket(i);
                          
                          //Get the position direction
                                    int PostionDirection=PositionGetInteger(POSITION_TYPE);   
                          
                            //if it is a buy position
                                   if(PositionDirection==POSITION_TYPE_BUY)
                          
                          //close the current position
                                   trade.PositionClose(ticket);
                               }//End of for loop
   }//End of function

   
  

