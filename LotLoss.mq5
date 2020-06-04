
input int vLoss = 50;   //Risk Money
input int pLoss = 500;  //Stop-Loss Points

void OnStart()
{   
   double pValue = SymbolInfoDouble(NULL, SYMBOL_TRADE_TICK_VALUE_PROFIT);
   double Lots = vLoss / (pLoss * pValue);
   
   if(Lots < 0.01)
   {
      Print("Error: under micro lots.");
      return;
   }
   
   string Message = "Point Value: " + DoubleToString(pValue, 2) + "\n" +
                    "Point: " + DoubleToString(_Point, _Digits) + "\n" +
                    "Lots: " + DoubleToString(Lots, 2);
   
   MessageBox(Message, "LotLoss v1.0", MB_ICONINFORMATION|MB_OK);
   
}
/*Simple risk management tool, that calculates required lot size according to amount of money trader affords to lose and stop-loss in points.

INPUTS

Risk-Money: money to sacrifice.
Stop-Loss Points: stop-loss in points.
EXAMPLE

AUDJPY Sell Order 
Risk-Money: 1000 USD
Open Price: 73.706
Stop-Loss: 76.130
Stop-Loss Points: 76.130 - 73.706 = 2.424 (2424 points)
Lots: 0.45
You lose 1000 USD, if you hit stop-loss with 0.45 lots position.
*/