
#include <get_dataset.mqh>

enum priceType {
   close, // Close
   open // Open
};

input string _nome_robo = "Robo_acoes_"; // Nome do Robo
input ENUM_TIMEFRAMES _tempo_grafico = PERIOD_D1; // Tempo Grafico
input int _periodos = 200; // Periodo
input priceType _price_type = close; // Price Type

int OnInit() {

   onGetDataset(_periodos, _tempo_grafico, _nome_robo, EnumToString(_price_type));

   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {

}

void OnTick() {

}