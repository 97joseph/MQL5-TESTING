#include<Trade\Trade.mqh>

CTrade trade;

void OnTick()
  {
 //Calculate the Bid price and the Ask price
 double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
 double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
 
 //Create a string for the signal
 string signal="";
 
 //Create an array for the price data
 double RSIArrayCurrent[],RSIArray30[],RSIArray60[];
 
 //Define the properties for the RSI
 int RSIDefinitionCurrent=iRSI(_Symbol,_Period,14,PRICE_CLOSE);
 
 //sort the price data  from the current candle downwards
 ArraySetAsSeries(RSIArrayCurrent,true);
 
 //Defined EA,from  current candle ,for 3 candles ,save in array
 CopyBuffer(RSIDefinitionCurrent,0,0,3,RSIArrayCurrent);
 
 //Calculate the current RSI value
 double RSIValueCurrent=NormalizeDouble(RSIArrayCurrent[0],2);
 
 //Define the properties for the RSI
 int RSIDefinition30=iRSI(_Symbol,PERIOD_M30,14,PRICE_CLOSE);
 
 //sort the array from the current candle downwards
 ArraySetAsSeries(RSIArray30,true);
 
 //Defined  EA from current candle downwards,for 3 candles ,save in array
 CopyBuffer(RSIDefinition30,0,0,3,RSIArray30);
 
 //Calculate the current RSI value
 double RSIValue30=NormalizeDouble(RSIArray30[0],2);
 
 //Define the properties for the RSI
 int RSIDefinition60=iRSI(_Symbol,PERIOD_H1,14,PRICE_CLOSE);
 
 //sort the array from the current candle downwards
 ArraySetAsSeries(RSIArray60,true);
 
 //Defined  EA from current candle downwards,for 3 candles ,save in array
 CopyBuffer(RSIDefinition60,0,0,3,RSIArray60);
 
 //Calculate the current RSI value
 double RSIValue60=NormalizeDouble(RSIArray60[0],2);
 
 
 //Calculate the buy and sell conditions
 if(RSIValueCurrent>70)
 if(RSIValue30>70)
 if(RSIValue60>70)
 signal="sell";
 
 if(RSIValue30<30)
 if(RSIValue30<30)
 if(RSIValue60<30)
 signal="buy";
 
 //Sell and buy conditions met
 if(signal=="sell" && PositionsTotal()<1)
 trade.Sell(0.10,NULL,Bid,(Bid+200*_Point),(Bid-150*_Point),NULL);
 
 if(signal=="buy" && PositionsTotal()<1)
  trade.Buy(0.10,NULL,Ask,(Ask+200*_Point),(Ask-150*_Point),NULL);
 
 //Chart output
 Comment("RSI Value CURRENT: ",RSIValueCurrent,"\n",
         "RSI Value 30 MIN : ",RSIValue30,"\n",
         "RSI Value 60 MIN : ",RSIValue60,"\n",
         "The signal is now: ",signal
         );
 
 
 
 
 
   
  }
