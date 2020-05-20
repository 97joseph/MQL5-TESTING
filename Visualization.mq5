from datetime import datetime;
from MetaTrader5 import *;


# import the pandas module for displaying data obtained in the tabular form
import pandas as pd;

pd.set_option('display.max_columns', 500);
 # number of columns to be displayed
pd.set_option('display.width', 1500);
 # max table width to display
# set connection to MetaTrader 5
MT5Initialize();

# wait till MetaTrader 5 connects to trade server
MT5WaitForTerminal();

# get 10 GBPUSD D1 bars from the current day
rates = MT5CopyRatesFrom("GBPUSD", MT5_TIMEFRAME_D1, 0, 10);

# shut down connection to MetaTrader 5
MT5Shutdown();

# display each element of obtained data in a new line
print("Display obtained data 'as is'");
for rate in rates:
print(rate);
# create DataFrame out of the obtained data
rates_frame = pd.DataFrame(list(rates),
columns=['time', 'open', 'low', 'high', 'close', 'tick_volume', 'spread', 'real_volume'])

# display data
print("\nDisplay dataframe with data");
print(rates_frame);
