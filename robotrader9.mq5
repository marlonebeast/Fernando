//+------------------------------------------------------------------+
//|                                                      MyRobot.mq5 |
//|                        Copyright 2024, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

input double lotSize = 0.01; // Tamanho do lote
input int takeProfit = 250;  // Pontos de take profit
input int threshold = 40;    // Limite mínimo de Fred para abrir ordens

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
  
}
//+------------------------------------------------------------------+
//| Expert tick function                                            |
//+------------------------------------------------------------------+
void OnTick()
{
   double fred = 0.0; // aqui você deve inserir a lógica para obter o valor de Fred
   
   // Verificar se o valor de Fred está abaixo do limite
   if(fred <= threshold)
   {
      // Se sim, não abrir ordens
      return;
   }
   
   // Se o valor de Fred for maior que o limite, abrir uma ordem de compra
   double price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double stopLoss = 0.0; // Sem stop loss
   
   // Abrir a ordem de compra
   MqlTradeRequest request = {};
   request.action = TRADE_ACTION_DEAL; 
   request.type = ORDER_TYPE_BUY; 
   request.symbol = _Symbol; 
   request.volume = lotSize; 
   request.price = price; 
   request.sl = stopLoss; 
   request.tp = price + threshold * Point; // Corrigido para definir o take profit adequadamente
   request.type_filling = ORDER_FILLING_FOK;
   request.magic = 0;
   
   MqlTradeResult result = {};
   int ticket = OrderSend(request, result);
   
   // Verificar se a ordem foi aberta com sucesso
   if(ticket < 0)
   {
      Print("Erro ao abrir ordem de compra: ", GetLastError());
   }
   else
   {
      Print("Ordem de compra aberta com sucesso! Ticket: ", ticket);
   }
}
//+------------------------------------------------------------------+
