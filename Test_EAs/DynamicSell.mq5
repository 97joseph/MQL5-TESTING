#include<Trade\Trade.mqh>

//Create an instance of CTrade
CTrade trade;

void OnTick()
  {

    //We calculate the Bid price
    double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
    
    //We calculate the Equity
    double Equity=AccountInfoDouble(ACCOUNT_EQUITY);
    
    //We calculate the Balance
    double Balance=AccountInfoDouble(ACCOUNT_BALANCE);
    
    //We calculate the Position Size
    double PositionSize=NormalizeDouble(Equity/100000,2);
    
    //if Equity at least equals Balance
    if(Equity>=Balance)
    //if we have no open positions
    if(PositionsTotal()==0)
    {
    trade.Sell(PositionSize,NULL,Bid,(Bid+150*_Point),(Bid-150*_Point),NULL);
    
    }
    
 //Create a chart output
  Comment(
    "Balance :",Balance,"\n",
    "Equity :",Equity,"\n",
    "Position Size: ",PositionSize
  
  );
}