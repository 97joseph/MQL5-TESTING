#include<Trade\Trade.mqh>

//Create an instance of CTrade\
CTrade trade;

void OnTick()
  {
 //We calculate the Ask price
 double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
 
 //We calculate the Equity
 double Equity=AccountInfoDouble(ACCOUNT_EQUITY);
 
 //We calculate the Balance
 double Balance=AccountInfoDouble(ACCOUNT_BALANCE);
 
 //We calculate the Position Size
 double PositionSize=NormalizeDouble(Equity/100000,2);
 
 //If Equity equals or greater tnan Balance
 if(Equity>=Balance)
 //if we have no open positions
 if(PositionsTotal()==0)
 {
 trade.Buy(PositionSize,NULL,Ask,(Ask-150*_Point),(Ask+100*_Point),NULL);
 
 }
 //Create a chart output
 Comment(
 "Balance :",Balance,"\n",
 "Equity: ",Equity,"\n",
 "Position Size:",PositionSize
 
 );
 
 
   
  }

