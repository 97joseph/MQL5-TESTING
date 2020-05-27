#include<Trade\Trade.mqh>
void OnTick()
  {
//---\
  double myAccountBalance=AccountInfoDouble(ACCOUNT_BALANCE);
  double  myAccountProfit=AccountInfoDouble(ACCOUNT_PROFIT);
  double myAccountEquity=AccountInfoDouble(ACCOUNT_EQUITY);
  
  Comment("Account Balance : ",myAccountBalance,"\n","Account Profit :",myAccountProfit);
  
  MqlTradeRequest myrequest;
  MqlTradeResult myresult;
  ZeroMemory(myrequest);
  myrequest.action=TRADE_ACTION_DEAL;
  myrequest.type=ORDER_TYPE_BUY;
  myrequest.symbol=_Symbol;
  myrequest.volume=0.01;
  myrequest.type_filling=ORDER_FILLING_FOK;
  myrequest.price=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
  myrequest.tp=0;
  myrequest.deviation=50;
  
  if(!PositionSelect(_Symbol))//if Open position does not exist
  {
   OrderSend(myrequest,myresult);
  }
   if ((myAccountEquity-myAccountBalance)>10)
   {
   CloseAllOrders();
   }
  }
//+------------------------------------------------------------------+
//Define the close order function
void CloseAllOrders()
{
  CTrade trade;
  int i=PositionsTotal()-1;
  while (i>=0)
  {
  if (trade.PositionClose(PositionGetSymbol(i))) i--;
  }
  
}
