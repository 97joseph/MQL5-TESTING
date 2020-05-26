#include<Trade\Trade.mqh>
CTrade trade;

//user input
input int MyTakeProfitValue=100;
input int MyStopLossValue=100;


void OnTick()
  {
double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
double Balance=AccountInfoDouble(ACCOUNT_BALANCE);
double Equity=AccountInfoDouble(ACCOUNT_EQUITY);

if(Equity>=Balance)
trade.Buy(0.10,NULL,Ask,0,(Ask+MyTakeProfitValue*_Point),NULL);
Comment("Balance :",Balance,"\n","Equity: ",Equity,"\n","MyTakeProfitValue : ",MyTakeProfitValue);

  

   
  }
