//+------------------------------------------------------------------+
//|                                       ClosePositionsBySymbol.mq5 |
//|                               Copyright © 2017, Nikolay Kositsin | 
//|                              Khabarovsk,   farria@mail.redcom.ru | 
//+------------------------------------------------------------------+  
#property copyright "Copyright © 2017, Nikolay Kositsin"
#property link "farria@mail.redcom.ru" 
//---- номер версии скрипта
#property version   "1.20" 
//---- показывать входные параметры
#property script_show_inputs
//+----------------------------------------------+
//| ВХОДНЫЕ ПАРАМЕТРЫ СКРИПТА                    |
//+----------------------------------------------+
input uint RTOTAL=4;        // Число повторов при неудачных сделках
input uint SLEEPTIME=1;     // Время паузы между повторами в секундах
input uint  Deviation_=10;  // Отклонение цены
//+------------------------------------------------------------------+ 
//| start function                                                   |
//+------------------------------------------------------------------+
void OnStart()
  {
//----   
   for(uint count=0; count<=RTOTAL && !IsStopped(); count++)
     {
      //---- закрываем все открытые позиции по текущему символу
      int total=PositionsTotal();
      if(!total) return; // все позиции закрыты
      for(int pos=total-1; pos>=0; pos--)
        {
         ulong ticket=ulong(PositionGetTicket(pos));
         if(!PositionSelectByTicket(ticket)) continue;
         string symbol=PositionGetSymbol(pos);
         if(symbol!=Symbol())  continue;
         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
           {
            bool BUY_Close=true;
            BuyPositionClose(BUY_Close,symbol,Deviation_);
           }
         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
           {
            bool SELL_Close=true;
            SellPositionClose(SELL_Close,symbol,Deviation_);
           }
        }
      if(!PositionsTotal()) break;
      Sleep(SLEEPTIME*1000);
     }
//----
  }
//+------------------------------------------------------------------+
//| Закрываем длинную позицию                                        |
//+------------------------------------------------------------------+
bool BuyPositionClose
(
 bool &Signal,         // флаг разрешения на сделку
 const string symbol,  // торговая пара сделки
 uint deviation        // слиппаж
 )
  {
//----
   if(!Signal) return(true);

//---- Объявление структур торгового запроса и результата торгового запроса
   MqlTradeRequest request;
   MqlTradeResult result;
//---- Объявление структуры результата проверки торгового запроса 
   MqlTradeCheckResult check;

//---- обнуление структур
   ZeroMemory(request);
   ZeroMemory(result);
   ZeroMemory(check);

//---- Проверка на наличие открытой BUY позиции
   if(PositionSelect(symbol))
     {
      if(PositionGetInteger(POSITION_TYPE)!=POSITION_TYPE_BUY) return(false);
     }
   else return(false);

   double MaxLot,volume,Bid;
//---- получение данных для расчёта    
   if(!PositionGetDouble(POSITION_VOLUME,volume)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX,MaxLot)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_BID,Bid)) return(true);

//---- проверка лота на максимальное допустимое значение       
   if(volume>MaxLot) volume=MaxLot;

//---- Инициализация структуры торгового запроса MqlTradeRequest для закрывания BUY позиции
   request.type   = ORDER_TYPE_SELL;
   request.price  = Bid;
   request.action = TRADE_ACTION_DEAL;
   request.symbol = symbol;
   request.volume = volume;
   request.sl = 0.0;
   request.tp = 0.0;
   request.deviation=deviation;
 //request.type_filling=ORDER_FILLING_FOK;
   request.position=PositionGetInteger(POSITION_TICKET);

//---- Проверка торгового запроса на корректность
   if(!OrderCheck(request,check))
     {
      Print(__FUNCTION__,"(): Неверные данные для структуры торгового запроса!");
      Print(__FUNCTION__,"(): OrderCheck(): ",ResultRetcodeDescription(check.retcode));
      return(false);
     }
//----     
   string comment="";
   StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): Закрываем Buy позицию по ",symbol," ============ >>>");
   Print(comment);

//---- Отправка приказа на закрывание позиции на торговый сервер
   if(!OrderSend(request,result) || result.retcode!=TRADE_RETCODE_DONE)
     {
      Print(__FUNCTION__,"(): Невозможно закрыть позицию!");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
      return(false);
     }
   else
   if(result.retcode==TRADE_RETCODE_DONE)
     {
      Signal=false;
      comment="";
      StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): Buy позиция по ",symbol," закрыта ============ >>>");
      Print(comment);
      PlaySound("ok.wav");
     }
   else
     {
      Print(__FUNCTION__,"(): Невозможно закрыть позицию!");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
      return(false);
     }
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| Закрываем короткую позицию                                       |
//+------------------------------------------------------------------+
bool SellPositionClose
(
 bool &Signal,         // флаг разрешения на сделку
 const string symbol,  // торговая пара сделки
 uint deviation        // слиппаж
 )
  {
//----
   if(!Signal) return(true);

//---- Объявление структур торгового запроса и результата торгового запроса
   MqlTradeRequest request;
   MqlTradeResult result;
//---- Объявление структуры результата проверки торгового запроса 
   MqlTradeCheckResult check;

//---- обнуление структур
   ZeroMemory(request);
   ZeroMemory(result);
   ZeroMemory(check);

//---- Проверка на наличие открытой SELL позиции
   if(PositionSelect(symbol))
     {
      if(PositionGetInteger(POSITION_TYPE)!=POSITION_TYPE_SELL)return(false);
     }
   else return(false);

   double MaxLot,volume,Ask;
//---- получение данных для расчёта    
   if(!PositionGetDouble(POSITION_VOLUME,volume)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX,MaxLot)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_ASK,Ask)) return(true);

//---- проверка лота на максимальное допустимое значение       
   if(volume>MaxLot) volume=MaxLot;

//---- Инициализация структуры торгового запроса MqlTradeRequest для закрывания SELL позиции
   request.type   = ORDER_TYPE_BUY;
   request.price  = Ask;
   request.action = TRADE_ACTION_DEAL;
   request.symbol = symbol;
   request.volume = volume;
   request.sl = 0.0;
   request.tp = 0.0;
   request.deviation=deviation;
 //request.type_filling=ORDER_FILLING_FOK;
   request.position=PositionGetInteger(POSITION_TICKET);

//---- Проверка торгового запроса на корректность
   if(!OrderCheck(request,check))
     {
      Print(__FUNCTION__,"(): Неверные данные для структуры торгового запроса!");
      Print(__FUNCTION__,"(): OrderCheck(): ",ResultRetcodeDescription(check.retcode));
      return(false);
     }
//----    
   string comment="";
   StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): Закрываем Sell позицию по ",symbol," ============ >>>");
   Print(comment);

//---- Отправка приказа на закрывание позиции на торговый сервер
   if(!OrderSend(request,result) || result.retcode!=TRADE_RETCODE_DONE)
     {
      Print(__FUNCTION__,"(): Невозможно закрыть позицию!");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
      return(false);
     }
   else
   if(result.retcode==TRADE_RETCODE_DONE)
     {
      Signal=false;
      comment="";
      StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): Sell позиция по ",symbol," закрыта ============ >>>");
      Print(comment);
      PlaySound("ok.wav");
     }
   else
     {
      Print(__FUNCTION__,"(): Невозможно закрыть позицию!");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
      return(false);
     }
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| возврат стрингового результата торговой операции по его коду     |
//+------------------------------------------------------------------+
string ResultRetcodeDescription(int retcode)
  {
   string str;
//----
   switch(retcode)
     {
      case TRADE_RETCODE_REQUOTE: str="Реквота"; break;
      case TRADE_RETCODE_REJECT: str="Запрос отвергнут"; break;
      case TRADE_RETCODE_CANCEL: str="Запрос отменен трейдером"; break;
      case TRADE_RETCODE_PLACED: str="Ордер размещен"; break;
      case TRADE_RETCODE_DONE: str="Заявка выполнена"; break;
      case TRADE_RETCODE_DONE_PARTIAL: str="Заявка выполнена частично"; break;
      case TRADE_RETCODE_ERROR: str="Ошибка обработки запроса"; break;
      case TRADE_RETCODE_TIMEOUT: str="Запрос отменен по истечению времени";break;
      case TRADE_RETCODE_INVALID: str="Неправильный запрос"; break;
      case TRADE_RETCODE_INVALID_VOLUME: str="Неправильный объем в запросе"; break;
      case TRADE_RETCODE_INVALID_PRICE: str="Неправильная цена в запросе"; break;
      case TRADE_RETCODE_INVALID_STOPS: str="Неправильные стопы в запросе"; break;
      case TRADE_RETCODE_TRADE_DISABLED: str="Торговля запрещена"; break;
      case TRADE_RETCODE_MARKET_CLOSED: str="Рынок закрыт"; break;
      case TRADE_RETCODE_NO_MONEY: str="Нет достаточных денежных средств для выполнения запроса"; break;
      case TRADE_RETCODE_PRICE_CHANGED: str="Цены изменились"; break;
      case TRADE_RETCODE_PRICE_OFF: str="Отсутствуют котировки для обработки запроса"; break;
      case TRADE_RETCODE_INVALID_EXPIRATION: str="Неверная дата истечения ордера в запросе"; break;
      case TRADE_RETCODE_ORDER_CHANGED: str="Состояние ордера изменилось"; break;
      case TRADE_RETCODE_TOO_MANY_REQUESTS: str="Слишком частые запросы"; break;
      case TRADE_RETCODE_NO_CHANGES: str="В запросе нет изменений"; break;
      case TRADE_RETCODE_SERVER_DISABLES_AT: str="Автотрейдинг запрещен сервером"; break;
      case TRADE_RETCODE_CLIENT_DISABLES_AT: str="Автотрейдинг запрещен клиентским терминалом"; break;
      case TRADE_RETCODE_LOCKED: str="Запрос заблокирован для обработки"; break;
      case TRADE_RETCODE_FROZEN: str="Ордер или позиция заморожены"; break;
      case TRADE_RETCODE_INVALID_FILL: str="Указан неподдерживаемый тип исполнения ордера по остатку "; break;
      case TRADE_RETCODE_CONNECTION: str="Нет соединения с торговым сервером"; break;
      case TRADE_RETCODE_ONLY_REAL: str="Операция разрешена только для реальных счетов"; break;
      case TRADE_RETCODE_LIMIT_ORDERS: str="Достигнут лимит на количество отложенных ордеров"; break;
      case TRADE_RETCODE_LIMIT_VOLUME: str="Достигнут лимит на объем ордеров и позиций для данного символа"; break;
      case TRADE_RETCODE_INVALID_ORDER: str="Неверный или запрещённый тип ордера"; break;
      case TRADE_RETCODE_POSITION_CLOSED: str="Позиция с указанным POSITION_IDENTIFIER уже закрыта"; break;
      default: str="Неизвестный результат";
     }
//----
   return(str);
  }
//+------------------------------------------------------------------+
