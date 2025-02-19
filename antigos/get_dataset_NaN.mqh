
string ativos[] = {"ABEV3", "AZUL4", "B3SA3", "BBAS3", "BBDC4", "BBSE3", "BEEF3", "BPAC11", "BRAP4", "BRDT3", "BRFS3", "BRKM5", "BRML3", "BTOW3", "CCRO3", 
"CIEL3", "CMIG4", "COGN3", "CPFE3", "CRFB3", "CSAN3", "CSNA3", "CVCB3", "CYRE3", "ECOR3", "EGIE3", "ELET3", "ELET6", "EMBR3", "ENBR3", 
"ENGI11", "EQTL3", "FLRY3", "GGBR4", "GNDI3", "GOAU4", "GOLL4", "HAPV3", "HGTX3", "HYPE3", "IGTA3", "IRBR3", "ITSA4", "ITUB4", "JBSS3", 
"KLBN11", "LAME4", "LREN3", "MGLU3", "MRFG3", "MRVE3", "MULT3", "NTCO3", "PCAR3", "PETR3", "PETR4", "QUAL3", "RADL3", "RAIL3", "RENT3", 
"SANB11", "SBSP3", "SULA11", "SUZB3", "TAEE11", "TIMP3", "TOTS3", "UGPA3", "USIM5", "VALE3", "VIVT4", "VVAR3", "WEGE3", "YDUQ3"};

//string ativos[] = {"AZUL4"};

MqlDateTime _time_arq, _time_current;
string _arq_name;
int _array_size = ArraySize(ativos);

void onGetDataset(int periodos, ENUM_TIMEFRAMES tempoGrafico, string roboName, string priceType = "close") {
   
   _arq_name = roboName + "_" + EnumToString(tempoGrafico) + "_" + IntegerToString(periodos) + "Candles.csv";
   
   if(FileIsExist(_arq_name)){
      datetime lastTime = getLastTime();
           
      int contador = 0;
      for(int d = 0; d < 1000; d++){
         datetime t = iTime(ativos[0], tempoGrafico, d);
         if(t == lastTime) break;
         else contador += 1;
         
         if(contador > 900) Alert("Algo esta errado com o contador");
      }
      
      if(contador > 0) creatOrUpdateDataset(tempoGrafico, priceType, false, contador);
      
   } else {
      creatOrUpdateDataset(tempoGrafico, priceType, true, periodos);
   }
   
   arqExecute();
}

void creatOrUpdateDataset(ENUM_TIMEFRAMES tempoGrafico, string priceType, bool create, int period){

   int h = FileOpen(_arq_name, FILE_ANSI|FILE_READ|FILE_WRITE|FILE_CSV, ";");
   if(create) FileWrite(h, concatSymbols());
   if(!create) FileSeek(h, 0, SEEK_END);
   
   string str;
   for(int i = period-1; i >= 0; i--){
   
      datetime time = iTime(ativos[0], tempoGrafico, i);
      str = TimeToString(time) + ";";
      
      for(int j = 0; j < _array_size; j++){
         
         string price = "";
         if(priceType == "close") price = DoubleToString(iClose(ativos[j], tempoGrafico, i), 2);
         else if(priceType == "open") price = DoubleToString(iOpen(ativos[j], tempoGrafico, i), 2);
         
         if(price == "0.00") price = "NaN";
         
         if(j >= _array_size - 1) str += price;
         else str += price + ";";
      }
      FileWrite(h, str);
   }
   FileClose(h);
   if(create) Print("DataSet criado com sucesso!");
   else Print("DataSet atualizado com sucesso!");
}

string concatSymbols(){

   string str = "Time;";
   for(int i = 0; i < _array_size; i++){
      if(i >= _array_size - 1) str += ativos[i];
      else str += ativos[i] + ";";
   }
   return str;
}

datetime getLastTime(){
   string result[];
   string sep = ";";
   ushort u_sep;
   datetime lastTime = NULL;
   u_sep = StringGetCharacter(sep, 0);
   int h = FileOpen(_arq_name, FILE_READ|FILE_ANSI|FILE_CSV);
   if(h == INVALID_HANDLE) Alert("Nao foi possivel carregar o " + _arq_name + "!!");
   while(!FileIsEnding(h)){
      string str = FileReadString(h);
      if(FileIsEnding(h)){
         StringSplit(str, u_sep, result);
         lastTime = StringToTime(result[0]);         
      }
   }
   FileClose(h);
   if(lastTime == NULL) Alert("Não foi possivel pegar a data no arquivo!");
   return lastTime;
}

void arqExecute(){
   string _arq_name_sinal = "sinal.txt"; 
   int hs = FileOpen(_arq_name_sinal, FILE_ANSI|FILE_WRITE|FILE_READ|FILE_TXT);
   if(hs == INVALID_HANDLE) Alert("Nao foi possivel carregar o " + _arq_name_sinal + "!!");
   FileWrite(hs, "ExecPython");
   FileClose(hs);
}