
void OnTick()
  {
 string signal="";
 
 //Array for the prices
 double MovingAverageArray1[],MovingAverageArray2[],MovingAverageArray3[],MovingAverageArray4[];
 
 //properties for the four exponential growth EMA
 
 int MovingAverageDefinition1=iMA(_Symbol,_Period,50,0,MODE_EMA,PRICE_CLOSE);
  int MovingAverageDefinition2=iMA(_Symbol,_Period,100,0,MODE_EMA,PRICE_CLOSE);
   int MovingAverageDefinition3=iMA(_Symbol,_Period,150,0,MODE_EMA,PRICE_CLOSE);
    int MovingAverageDefinition4=iMA(_Symbol,_Period,200,0,MODE_EMA,PRICE_CLOSE);
    
    
 //Sort the price array from the current candle downwards
 ArraySetAsSeries(MovingAverageArray1,true);
  ArraySetAsSeries(MovingAverageArray2,true);
   ArraySetAsSeries(MovingAverageArray3,true);
    ArraySetAsSeries(MovingAverageArray4,true);
    
//Fill each of the arrays ,one line,current candle ,3 candles,store result
CopyBuffer(MovingAverageDefinition1,0,0,3,MovingAverageArray1);
CopyBuffer(MovingAverageDefinition2,0,0,3,MovingAverageArray2);
CopyBuffer(MovingAverageDefinition3,0,0,3,MovingAverageArray3);
CopyBuffer(MovingAverageDefinition4,0,0,3,MovingAverageArray4);

//Calculate the MA1 for the current candle
double MovingAverageValue1=MovingAverageArray1[0];
double MovingAverageValue2=MovingAverageArray2[0];
double MovingAverageValue3=MovingAverageArray3[0];
double MovingAverageValue4=MovingAverageArray4[0];

//Sell signal
if(MovingAverageValue1 < MovingAverageValue2)
if(MovingAverageValue2 < MovingAverageValue3)
if(MovingAverageValue3 < MovingAverageValue4)
  {signal="SELL";}

//Buy signal 
if(MovingAverageValue1 > MovingAverageValue2)
if(MovingAverageValue2 > MovingAverageValue3)
if(MovingAverageValue3 > MovingAverageValue4)
  {signal="BUY";}
  
  //Chart output
Comment("Signal : " ,signal,"\n",  
         "MovingAverageValue1: ",MovingAverageValue1,"\n",
         "MovingAverageValue2: ",MovingAverageValue2,"\n",
         "MovingAverageValue3: ",MovingAverageValue3,"\n",
         "MovingAverageValue4: ",MovingAverageValue4,"\n",
      );
  
   
  }
