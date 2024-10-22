
#include <global_cointegration.mqh>

string arr = "ABEV3;AZUL4;B3SA3;BBAS3;BBDC4;BBSE3;BEEF3;BPAC11;BRAP4;BRDT3;BRFS3;BRKM5;BRML3;BTOW3;CCRO3;CIEL3;CMIG4;COGN3;CPFE3;CRFB3;CSAN3;CSNA3;CVCB3;CYRE3;ECOR3;"+
             "EGIE3;ELET3;ELET6;EMBR3;ENBR3;ENGI11;EQTL3;FLRY3;GGBR4;GNDI3;GOAU4;GOLL4;HAPV3;HGTX3;HYPE3;IGTA3;IRBR3;ITSA4;ITUB4;JBSS3;KLBN11;LAME4;LREN3;MGLU3;MRFG3;"+
             "MRVE3;MULT3;NTCO3;PCAR3;PETR3;PETR4;QUAL3;RADL3;RAIL3;RENT3;SANB11;SBSP3;SULA11;SUZB3;TAEE11;TIMP3;TOTS3;UGPA3;USIM5;VALE3;VIVT4;VVAR3;WEGE3;YDUQ3";

enum priceType {
   close, // Close
   open // Open
};

enum Estrategia {
   SwingTrade_ACOES, // SwingTrade_ACOES
   DayTrade_WIN // DayTrade_WIN
};

input string _robonome = "- - - -"; // Nome do Robo
input ENUM_TIMEFRAMES _tempo_grafico = PERIOD_M10; // Tempo Grafico
input int _periodos = 500; // Periodo
input priceType _price_type = close; // Tipo de Preço
input Estrategia _estrategia = DayTrade_WIN; // Estrategia

string _nome_robo = "";

int OnInit() {
   _nome_robo = _robonome;
   int second = getSeconds(_tempo_grafico);
   if(second == -1){
      Alert("Não é permitido usar tempo grafico mensal!");
      return INIT_FAILED;
   }
   EventSetTimer(second);
   
   if(_nome_robo == "- - - -" || _nome_robo == ""){
      _nome_robo = EnumToString(_estrategia);
   }
   
   if(_estrategia == DayTrade_WIN) arr = _Symbol + ";" + arr;
   onGetDatasetWin(_periodos, _tempo_grafico, _nome_robo, EnumToString(_price_type), arr);

   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
   EventKillTimer();
}

void OnTick() {

}

void OnTimer(){
   onGetDatasetWin(_periodos, _tempo_grafico, _nome_robo, EnumToString(_price_type), arr);
}