//+------------------------------------------------------------------+
//|                                                 NoSlipCloser.mq5 |
//|                                                   Javad Sarafraz |
//|                                            jsarafraz.a@gmail.com |
//+------------------------------------------------------------------+
#property service
#property copyright "Javad Sarafraz"
#property link      "jsarafraz.a@gmail.com"
#property description "jsarafraz.a@gmail.com"
#property description "\n(+98) 933 45 40 146"
#property version   "1.00"
//+------------------------------------------------------------------+
input int delayPoint=20;//Delay (Point)
input int sleepMilli=200;//Sleep Time(milliseconds)
input string closedCmnt="No Slippage Closer";//closed positions comment
//+------------------------------------------------------------------+
void OnStart()
  {
   while(true)
     {
      for(int i=0; i<PositionsTotal(); i++)
        {
         bool close=false;
         MqlTradeRequest rq= {};
         MqlTradeResult rst= {};
         ulong ptkt=PositionGetTicket(i);
         double pvol=PositionGetDouble(POSITION_VOLUME);
         double psl=PositionGetDouble(POSITION_SL);
         double ptp=PositionGetDouble(POSITION_TP);
         long ptyp=PositionGetInteger(POSITION_TYPE);
         string psym=PositionGetString(POSITION_SYMBOL);
         if(ptyp==0)//Buy
           {
            if((SymbolInfoDouble(psym,SYMBOL_BID)>ptp+delayPoint*SymbolInfoDouble(psym,SYMBOL_POINT))
               || (SymbolInfoDouble(psym,SYMBOL_ASK)<psl-delayPoint*SymbolInfoDouble(psym,SYMBOL_POINT)))
              {
               rq.order=ORDER_TYPE_SELL;
               rq.price=SymbolInfoDouble(psym,SYMBOL_BID);
              }
           }
         else//Sell
           {
            if((SymbolInfoDouble(psym,SYMBOL_BID)>psl+delayPoint*SymbolInfoDouble(psym,SYMBOL_POINT))
               || (SymbolInfoDouble(psym,SYMBOL_ASK)<ptp-delayPoint*SymbolInfoDouble(psym,SYMBOL_POINT)))
              {
               rq.order=ORDER_TYPE_BUY;
               rq.price=SymbolInfoDouble(psym,SYMBOL_ASK);
              }
           }
         if(close)
           {
            rq.action=TRADE_ACTION_DEAL;
            rq.position=ptkt;
            rq.symbol=psym;
            rq.volume=pvol;
            rq.comment=closedCmnt;
            ResetLastError();
            if(!OrderSend(rq,rst))
              {
               Alert("---> NoSlipCloser Failed to close ",pvol," ",psym,"! Ticket:",ptkt," Error:",GetLastError()," Retcode:",rst.retcode);
              }
           }
        }
      Sleep(sleepMilli);
     }
  }
//+------------------------------------------------------------------+
