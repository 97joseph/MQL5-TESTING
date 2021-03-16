//+------------------------------------------------------------------+
//|                                                       Logger.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Logger
  {
private:
string logFile;

struct logData
{
   datetime date;
   string Sym;
   ulong ticket;
   ENUM_POSITION_TYPE posType;
   double lot;
   double sl;
   double tp;
   double atr;
   double openPrice;
   double baseline;
   double primary;
   double confirmation;
   double cofirmation2;
   double exit;
   double closePrice;
   double profit;


};

public:
 LogData LOGDATA;

                     Logger();
                    ~Logger();
                    void SaveData();
                    string Logger::CreateLogFile();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Logger::Logger()
  {
    logFile = TerminalInfoString(TERMINAL_DATA_PATH)+"\\logs";
    
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Logger::~Logger()
  {
  }
//+------------------------------------------------------------------+
string Logger::CreateLogFile()
{
   /*
   string fileName = TimeToString(TimeCurrent(),TIME_DATE|TIME_MINUTES);
   
   StringReplace(fileName,".","");
   StringReplace(fileName,":","");
   StringReplace(fileName," ","");
   string rnd = DoubleToString(NormalizeDouble(MathRand()/10,0),5);
   
   fileName = fileName + rnd + ".csv";
   //logFile = logFile+"\\"+fileName;
   logFile = fileName;
  
   if(FileIsExist(logFile))  
      FileDelete(logFile);
   LOGFILE = logFile;
   int file_handle =FileOpen(logFile,FILE_WRITE|FILE_CSV); 
   
   
  
   if(file_handle!=INVALID_HANDLE) 
     { 
         FileWrite(file_handle,
                     "DateTime",
                     "Symbol",
                     "Ticket",
                     "PriceOpen",
                     "PositionType",
                     "Lot",
                     "ATR",
                     "BaseLine",
                     "Primary",
                     "Confirmation",
                     "Confirmation-2",                     
                     "Exit",
                     "StopLoss",
                     "TakeProfit",
                     "ClosePrice",
                     "Profit"
                  ); 
      //--- close the file 
      FileClose(file_handle); 
      
     } 
   else 
      PrintFormat("Failed to open %s file, Error code = %d",fileName,GetLastError()); 
      
      return logFile;
  */
  return "";
  
}
void Logger::SaveData()
  {
   /*
   if(LOGDATA.Sym=="") LOGDATA.Sym = "-";
   //if(LOGDATA.ticket=="") LOGDATA.ticket = 0;
   //if(LOGDATA.openPrice=="") LOGDATA.openPrice = 0;
   //if(LOGDATA.posType=="") LOGDATA.posType = 0;
   //if(LOGDATA.lot=="") LOGDATA.lot = 0;
   //if(LOGDATA.atr=="") LOGDATA.atr = 0;
   //if(LOGDATA.baseline=="") LOGDATA.baseline = 0;
   //if(LOGDATA.primary=="") LOGDATA.primary = 0;
   //if(LOGDATA.confirmation=="") LOGDATA.confirmation = 0;
   //if(LOGDATA.cofirmation2=="") LOGDATA.cofirmation2 = 0;
   //if(LOGDATA.exit=="") LOGDATA.exit = 0;
   //if(LOGDATA.sl=="") LOGDATA.sl = 0;
   //if(LOGDATA.tp=="") LOGDATA.tp = 0;
   
   
   int file_handle=FileOpen(LOGFILE,FILE_READ|FILE_WRITE|FILE_CSV); 
   FileSeek(file_handle,0,SEEK_END);
   if(file_handle!=INVALID_HANDLE) 
     { 
         FileWrite(file_handle,
                     TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS),
                     LOGDATA.Sym,
                     LOGDATA.ticket,
                     LOGDATA.openPrice,
                     LOGDATA.posType,
                     LOGDATA.lot,
                     LOGDATA.atr,
                     LOGDATA.baseline,
                     LOGDATA.primary,
                     LOGDATA.confirmation,
                     LOGDATA.cofirmation2,                     
                     LOGDATA.exit,
                     LOGDATA.sl,
                     LOGDATA.tp,
                     LOGDATA.closePrice,
                     LOGDATA.profit
                     
                 ); 
      //--- close the file 
      FileClose(file_handle); 
      
     } 
   else 
      PrintFormat("Failed to open %s file, Error code = %d",logFile,GetLastError()); 
       FileClose(file_handle); 
  
  */
  }
