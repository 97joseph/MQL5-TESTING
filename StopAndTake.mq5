#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
CPositionInfo pos;
CTrade trade;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   double price = NormalizeDouble(ChartPriceOnDropped(), _Digits);
   double bid=SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask=SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   for(int i=PositionsTotal()-1; i>=0; i--)
   {
      if(pos.SelectByIndex(i)==false)continue;
      if((pos.Type()==POSITION_TYPE_BUY) && (pos.Symbol()==_Symbol) && (price<bid))
         trade.PositionModify(pos.Ticket(), price, pos.TakeProfit());
      if((pos.Type()==POSITION_TYPE_BUY) && (pos.Symbol()==_Symbol) && (price>ask))
         trade.PositionModify(pos.Ticket(), pos.StopLoss(), price);
      
      if((pos.Type()==POSITION_TYPE_SELL) && (pos.Symbol()==_Symbol) && (price<bid))
         trade.PositionModify(pos.Ticket(), pos.StopLoss(), price);
      if((pos.Type()==POSITION_TYPE_SELL) && (pos.Symbol()==_Symbol) && (price>ask))
         trade.PositionModify(pos.Ticket(), price, pos.TakeProfit());
   }
  }
//+------------------------------------------------------------------+
/*When run on the price chart, the script modifies stop loss or take profit of all open orders for the current instrument.

Example: If multiple buy positions are opened on the GBPUSD pair, dragging the script to the chart below the current price causes the stop loss levels of all open positions to be modified, and dragging it above the current price causes the take profit levels to be modified.*/