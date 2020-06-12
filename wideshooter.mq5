//+------------------------------------------------------------------+
//|                                                     WideShootrer |
//|                                           Copyright 2012,Karlson |
//+------------------------------------------------------------------+
#property copyright   "2012, Karlson."
#property link        "https://login.mql5.com/ru/users/Karlson"
#property description "WideShootrer"
#property version "1.00"
//-------------------------------------------------------------------+
double High[],Low[];
int bars=1500,KF=1; // ����� ����� ���������� 1500 ����� �� ������ ���� ������� �������
//-------------------------------------------------------------------+
void OnStart()
  {
   if(_Digits==5 || _Digits==3) {KF=10;} else {KF=1;}

// ���������� ������ ����� ���.�� ���� ����� ������ ��������

   int first_bar=(int)ChartGetInteger(0,CHART_FIRST_VISIBLE_BAR);

// ���������� ������� ���������� �� ������� ����� - ����������� ��� ����������� ������ ���������

   int vis_bar=(int)ChartGetInteger(0,CHART_VISIBLE_BARS);Print("�� ������ ������� ���������� �����=",vis_bar);

// �������� ���� � ������ �� ���������� � ������ ���� � 1500 ����� ��� ��������� ���-��� �������

   if(first_bar<bars) {bars=first_bar;} // ���� ������ ������ ����� ��� ��������� �����,����� ����� ��� ��� ���� ������ �� �������� �������

   int ch=CopyHigh(_Symbol,_Period,first_bar-bars,bars,High);
   int cl=CopyLow(_Symbol,_Period,first_bar-bars,bars,Low);

// ���������� ��� ��� �� ����� ���������� � ������������� ���� ��� ����� ����

   double min_price=Low[ArrayMinimum(Low,0,bars)];

   double max_price=High[ArrayMaximum(High,0,bars)];

// ����������� ����� � ��������� ���� ���

   ChartSetInteger(0,CHART_SCALEFIX,0,1);
   ChartSetDouble(0,CHART_FIXED_MAX,max_price+20*KF*_Point);
   ChartSetDouble(0,CHART_FIXED_MIN,min_price-20*KF*_Point);
   ChartSetInteger(0,CHART_AUTOSCROLL,false);

// ������� ������� ���� � ������� ������� ��� ����������� ����� �����

   MqlDateTime day;

   TimeToStruct(TimeCurrent(),day);

   string file=_Symbol+(string)day.year+"_"+(string)day.mon+"_"+(string)day.day+"_"+(string)day.hour+"_"+(string)day.min+"_"+(string)day.sec+".png";

// ��������� ������ � ������ �������� ������

   int screen_width=1000*bars/vis_bar;Print("������ ������=",screen_width);

   int scr_height=(int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS);

// ������� ��������

   ChartScreenShot(0,file,screen_width,scr_height,ALIGN_LEFT);

   if(GetLastError()>0) {Print("Error  (",GetLastError(),") ");} ResetLastError();

  }

//+------------------------------------------------------------------+
