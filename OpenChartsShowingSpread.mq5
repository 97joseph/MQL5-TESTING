#property script_show_inputs  true
input ENUM_TIMEFRAMES timeFrame = PERIOD_H1; //Timeframe
input string tplName = "Momentum.tpl";       //Template
input uint ptsSpread = 20;                   //Spread Filter
int symIndex = 0;
int symSpread = 0;
string symName = "";
long chartID = 0;

void OnStart()
{
   for(symIndex = 0; symIndex < SymbolsTotal(false); symIndex++)
   {
      symName = SymbolName(symIndex, false);
      if(SymbolInfoInteger(symName, SYMBOL_SELECT) == false) SymbolSelect(symName, true);
   }
   Sleep(1000);
   for(symIndex = 0; symIndex < SymbolsTotal(false); symIndex++)
   {
      symName = SymbolName(symIndex, false);
      symSpread = SymbolInfoInteger(symName, SYMBOL_SPREAD);
      if(symSpread > ptsSpread) 
      {
         SymbolSelect(symName, false);
         continue;
      }
      chartID = ChartOpen(symName, timeFrame);
      ChartApplyTemplate(chartID, "//Profiles//Templates//" + tplName);
      ChartSetInteger(chartID, CHART_SHIFT, 0, true);
   }
   

}
/*First script selects symbols having spread below specified value on the marketwatch, then opens corresponding charts by appyling timeframe and template stated.
To Open Charts;

Double-click or drag-drop OpenCharts on a chart.
Enter inputs. (Timeframe, Template, Spread)
Click Ok.
*/