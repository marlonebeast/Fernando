//+------------------------------------------------------------------+
//|                                                robôtrader3.mq5  |
//|                    Copyright 2024, SeuNome                        |
//|                        https://www.seusite.com                    |
//+------------------------------------------------------------------+
#property strict

// Enumerações personalizadas
enum CustomTradeRequestActions
{
   Custom_TRADE_ACTION_DEAL           = 1, // Executar negociação
};

enum CustomOrderType
{
   Custom_ORDER_TYPE_BUY              = 0, // Ordem de compra
   Custom_ORDER_TYPE_SELL             = 1, // Ordem de venda
};

// Variáveis globais
input double lotSize = 0.01; // Tamanho do lote
input int takeProfit = 250; // Take Profit em pontos

double lastBuyPrice = 0;
double lastSellPrice = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // Colocar a lógica de abertura das ordens aqui
   OpenBuyOrder();
   Sleep(5000); // Esperar 5 segundos
   OpenSellOrder();

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Função para abrir uma ordem de compra                             |
//+------------------------------------------------------------------+
void OpenBuyOrder()
{
   double price = SymbolInfoDouble(_Symbol, SYMBOL_BID); // Preço de compra
   double sl = 0; // Stop Loss (0 para não definido)
   double tp = price + takeProfit * _Point; // Take Profit
   
   // Abrir a ordem de compra
   MqlTradeRequest request = {1};
   MqlTradeResult result = {0};
   request.action = CustomTradeRequestActions::Custom_TRADE_ACTION_DEAL;
   request.type = CustomOrderType::Custom_ORDER_TYPE_BUY;
   request.symbol = _Symbol;
   request.volume = lotSize;
   request.price = price;
   request.sl = sl;
   request.tp = tp;
   request.deviation = 3;
   request.type_filling = ORDER_FILLING_FOK;
   request.magic = 0;
   request.type_time = ORDER_TIME_GTC; // Adicionando tipo de tempo (Good Till Canceled)
   if (OrderSend(request, result) == false)
   {
      Print("Erro ao enviar ordem de compra: ", GetLastError());
   }
   else
   {
      lastBuyPrice = price;
   }
}

//+------------------------------------------------------------------+
//| Função para abrir uma ordem de venda                             |
//+------------------------------------------------------------------+
void OpenSellOrder()
{
   double price = SymbolInfoDouble(_Symbol, SYMBOL_ASK); // Preço de venda (usando ask)
   double sl = 0; // Stop Loss (0 para não definido)
   double tp = price - takeProfit * _Point; // Take Profit
   
   // Abrir a ordem de venda
   MqlTradeRequest request = {1};
   MqlTradeResult result = {0};
   request.action = CustomTradeRequestActions::Custom_TRADE_ACTION_DEAL;
   request.type = CustomOrderType::Custom_ORDER_TYPE_SELL;
   request.symbol = _Symbol;
   request.volume = lotSize;
   request.price = price;
   request.sl = sl;
   request.tp = tp;
   request.deviation = 3;
   request.type_filling = ORDER_FILLING_FOK;
   request.magic = 0;
   request.type_time = ORDER_TIME_GTC; // Adicionando tipo de tempo (Good Till Canceled)
   if (OrderSend(request, result) == false)
   {
      Print("Erro ao enviar ordem de venda: ", GetLastError());
   }
   else
   {
      lastSellPrice = price;
   }
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Colocar a lógica de finalização aqui
}
