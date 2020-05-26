#include<Trade\Trade.mqh>

CTrade trade;

void OnTick()
  {
  //Calculate the Ask price and the Bid price
  double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
  double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
  
  //Strng for the signal call
  string signal="";
  
  //create an array for the price data and sort the array from the current candle downwards
  double myIOSMAArray[];
  ArraySetAsSeries(myIOSMAArray,true);
  
  //properties of the iOSMA
  int IOSMADefinition=iOsMA(_Symbol,_Period,12,26,9,PRICE_CLOSE);
  
  //Defined EA,from current candle,for 3 candles 
  CopyBuffer(IOSMADefinition,0,0,3,myIOSMAArray);
  
  //Calculate the current IOSMA value and the last IOSMA value
  double IOSMAValue1=myIOSMAArray[0];
  double IOSMAValue2=myIOSMAArray[1];
  
  //if the value crossed zero line from above
  if((IOSMAValue1<0)&&(IOSMAValue2>0))
  signal="sell";
  
  //if the value crossed the zero line from below
  if((IOSMAValue1>0)&&(IOSMAValue2<0))
  signal="buy;
  
  //Signal for buy and sell conditions
  if(signal="sell" && PositionsTotal()<1)
    trade.Sell(0.10,NULL,Bid,(Bid+300*_Point),(Bid-250*_Point),NULL);
  if(signal="buy"&& PositionsTotal()<1)
    trade.Buy(0.10,NULL,Ask,(Ask-300*_Point),(Ask+250*_Point),NULL); 
  
  
  
   

   
  }