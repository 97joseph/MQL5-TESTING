#include<Trade\ Trade.mqh>
CTrade trade;

void OnTick()
  {
  double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
  double Balance=AccountInfoDouble(ACCOUNT_BALANCE);
  double Equity=AccountInfoDouble(ACCOUNT_EQUITY);
 //if we have no open positions
 if(PositionsTotal()==0 && OrdersTotal()==0){
 trade.SellStop(0.10,Bid-100*_Point,_Symbol,0,Bid-300*_Point,ORDER_TIME_GTC,0,0);
  
   
  }
