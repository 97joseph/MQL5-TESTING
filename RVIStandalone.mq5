#include <Trade\Trade.mqh>

//Create an instance of Ctrade

void OnTick()
  {

 //Create  a string for the signal
 string signal = "";
 //Get the Ask price
 double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits); 
 //Get the Bid price
 double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
 
 //Create an array for the price data
 double myPriceArray0[];
 
 //Create another array for the price data
 double myPriceArray1[];
 
 //Define the properties for the RVI EA
 int RVIDefinition=iRVI(_Symbol,_Period,3);
 
 //sort Array0 from  the current candle downwards
 ArraySetAsSeries(myPriceArray0,true);
 
 //sort Array1 from the current candle  downwards
 ArraySetAsSeries(myPriceArray1,true);
 
 //Defined EA ,first buffer,Current Candle,3 candles,store in Array0
 CopyBuffer(RVIDefinition,0,0,3,myPriceArray0);
 
 //Defined EA,second buffer,current Cnadle,3 candles,store in Array1
 CopyBuffer(RVIDefinition,1,0,3,myPriceArray1);
 
 //calculate the current value for line0
 double RVIValue0=(NormalizeDouble(myPriceArray0[0],3));
 
 //calculate the current value for line 1
 double RVIValue1=(NormalizeDouble(myPriceArray1[0],3));
 
 //create a buy signal
 if (RVIValue0<RVIValue1) {
   if((RVIValue0<0)&&(RVIValue1<0))
   {
   signal="buy";
   }
   
 //Create a sell signal
 if(RVIValue0>RVIValue1)
   if((RVIValue0>0) && (RVIValue1>0))
   {
   signal="sell";
   }
   
   //sell  10 microlot
   if(signal=="sell" && PositionsTotal()<1)
    trade.Sell(0.10,NULL,Bid,0,(Bid-140*_Point),NULL);
   
   //buy 10 microlot
   if(signal=="buy" && PositionsTotal()<1)
    trade.Buy(0.10,NULL,Ask,0,(Ask+150*_Point),NULL); 
   
   Comment ("Signal: ",signal);
   
 
                    
                                                               

     
  }
  }
