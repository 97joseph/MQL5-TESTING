//I am trying to calculate the maximum allowed position size before opening a trade.
  
    // For now, let's go with 2%
      input double MAX_RISK_PERCENT_OF_TRADE = 2.0;

      // Capital at risk, in dollars
      double capitalAtRisk = AccountEquity() * ( MAX_RISK_PERCENT_OF_TRADE / 100 );
    
      // Deduct brokerage on the buy and sell
      // OANDA is purely spread, no fixed fee
      double maximumPermissibleRisk = capitalAtRisk - spreadCost;
 
      double lotSize = maximumPermissibleRisk / valuePerPip / stopLossPips;
  