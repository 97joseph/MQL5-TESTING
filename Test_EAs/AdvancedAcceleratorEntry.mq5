
string CheckEntry()
  {
 string signal="";
 //Create an array for several prices
 double myPriceArray[];
 //Define the properties of the iAC EA
 int iACDefinition=iAC(_Symbol,_Period);
 //sort the array from the current candle downwards
 ArraySetAsSeries(iACDefinition,true);

//Defined MA1,one line current candle,3 candles,store result
 CopyBuffer(iACDefinition,0,3,myPriceArray);

//Get the value from the current candle
 float iACValue=myPriceArray[0];

//if the iACValue is above the zero line
//overbought condition
 if(iACValue>0)
 signal="sell";

//if the iACValue is below the zero line
//oversold condition
 if(iACValue<0)
 signal="buy";

//return signal to main module
 return signal;

 
 
   
  }
