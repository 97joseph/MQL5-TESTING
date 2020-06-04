void OnStart()
{
   int pTotal = PositionsTotal();   
   ulong pTicket;
   double pLot, pVolume, pBid, pAsk;
   string pSymbol;
   MqlTradeRequest tReq;
   MqlTradeResult tRes;
   MqlTradeCheckResult tChk;
   
   for(int i = pTotal - 1; i >= 0; i--)
   {
      pTicket = PositionGetTicket(i);      
      pSymbol = PositionGetSymbol(i);
      if(!PositionSelectByTicket(pTicket)) continue;
      if(PositionGetInteger(POSITION_MAGIC) != 999) continue;
      if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
      {
         ZeroMemory(tReq);
         ZeroMemory(tRes);
         ZeroMemory(tChk);
         if(pVolume > pLot) pVolume = pLot;
         tReq.action = TRADE_ACTION_SLTP;
         tReq.symbol = pSymbol;
         tReq.sl = PositionGetDouble(POSITION_SL);
         tReq.tp = PositionGetDouble(POSITION_PRICE_OPEN);
         tReq.deviation = 5;
         tReq.position = PositionGetInteger(POSITION_TICKET);
      
         if(!OrderCheck(tReq, tChk))
         {
            Print("ERROR: order check. " + pSymbol + tChk.retcode);
         }
         
         if(!OrderSend(tReq, tRes) || tRes.retcode != TRADE_RETCODE_DONE)
         {
            Print("ERROR: order send. " + pSymbol + tRes.retcode);
         }
      }
      
      if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
      {
         ZeroMemory(tReq);
         ZeroMemory(tRes);
         ZeroMemory(tChk);
         if(pVolume > pLot) pVolume = pLot;         
         tReq.action = TRADE_ACTION_SLTP;
         tReq.symbol = pSymbol;
         tReq.sl = PositionGetDouble(POSITION_SL);
         tReq.tp = PositionGetDouble(POSITION_PRICE_OPEN);
         tReq.deviation = 5;
         tReq.position = PositionGetInteger(POSITION_TICKET);
         
         if(!OrderCheck(tReq, tChk))
         {
            Print("ERROR: order check. " + pSymbol + tChk.retcode);
         }         
 
         if(!OrderSend(tReq, tRes) || tRes.retcode != TRADE_RETCODE_DONE)
         {
            Print("ERROR: order send. " + pSymbol + tRes.retcode);
         }
      }
   }
}   

