//+------------------------------------------------------------------+
//|                                                      Robotrader |
//|                        Copyright 2024, SeuNome                   |
//|                                        https://www.seusite.com   |
//+------------------------------------------------------------------+
#property strict

// Enumerações personalizadas
enum CustomTradeRequestActions
{
   Custom_TRADE_ACTION_DEAL           = 1, // Executar negociação
   Custom_TRADE_ACTION_PENDING        = 2, // Colocar ordem pendente
   Custom_TRADE_ACTION_SLTP           = 3, // Modificar Stop Loss e Take Profit
   Custom_TRADE_ACTION_MODIFY         = 4, // Modificar a ordem
   Custom_TRADE_ACTION_REMOVE         = 5, // Remover a ordem
   Custom_TRADE_ACTION_CLOSE_BY       = 6, // Fechar por
   Custom_TRADE_ACTION_CLOSE          = 7, // Fechar
   Custom_TRADE_ACTION_BALANCE        = 8, // Crédito/Débito
   Custom_TRADE_ACTION_CREDIT         = 9, // Crédito
   Custom_TRADE_ACTION_REBATE         = 10, // Rebate
   Custom_TRADE_ACTION_NETTING        = 11, // Fechar todas as posições opostas
   Custom_TRADE_ACTION_CLOSE_PARTIAL  = 12  // Fechar uma parte da posição
};

enum CustomOrderType
{
   Custom_ORDER_TYPE_BUY              = 0, // Ordem de compra
   Custom_ORDER_TYPE_SELL             = 1, // Ordem de venda
   Custom_ORDER_TYPE_BUY_LIMIT        = 2, // Ordem de compra pendente
   Custom_ORDER_TYPE_SELL_LIMIT       = 3, // Ordem de venda pendente
   Custom_ORDER_TYPE_BUY_STOP         = 4, // Ordem de compra stop
   Custom_ORDER_TYPE_SELL_STOP        = 5, // Ordem de venda stop
   Custom_ORDER_TYPE_BALANCE          = 6, // Ordem de crédito/débito
   Custom_ORDER_TYPE_CREDIT           = 7, // Ordem de crédito
   Custom_ORDER_TYPE_REBATE           = 8  // Ordem de rebate
};

// Variáveis globais
input double lotSize = 0.01; // Tamanho do lote
input int takeProfit = 250; // Take Profit em pontos
input int maxSpread = 30; // Spread máximo para abrir ordens

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // Colocar a lógica de abertura das ordens aqui
   if (SymbolInfoInteger(_Symbol, SYMBOL_SPREAD) <= maxSpread)
   {
      OpenBuyOrder();
      Sleep(5000); // Esperar 5 segundos
      OpenSellOrder();
   }
   else
   {
      Print("Spread muito alto. Não é possível abrir ordens.");
   }

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Função para abrir uma ordem de compra                             |
//+------------------------------------------------------------------+
void OpenBuyOrder()
{
   double price = SymbolInfoDouble(_Symbol, SYMBOL_ASK); // Preço de compra (usando ask)
   double sl = 0; // Stop Loss (0 para não definido)
   double tp = price + takeProfit * _Point; // Take Profit
   
   // Abrir a ordem de compra
   MqlTradeRequest request = {};
   MqlTradeResult result = {};
   request.action = ENUM_TRADE_REQUEST_ACTIONS::TRADE_ACTION_DEAL;
   request.type = ENUM_ORDER_TYPE::ORDER_TYPE_BUY;
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
}

//+------------------------------------------------------------------+
//| Função para abrir uma ordem de venda                             |
//+------------------------------------------------------------------+
void OpenSellOrder()
{
   double price = SymbolInfoDouble(_Symbol, SYMBOL_BID); // Preço de venda (usando bid)
   double sl = 0; // Stop Loss (0 para não definido)
   double tp = price - takeProfit * _Point; // Take Profit
   
   // Abrir a ordem de venda
   MqlTradeRequest request = {};
   MqlTradeResult result = {};
   request.action = ENUM_TRADE_REQUEST_ACTIONS::TRADE_ACTION_DEAL;
   request.type = ENUM_ORDER_TYPE::ORDER_TYPE_SELL;
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
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Colocar a lógica de finalização aqui
}
