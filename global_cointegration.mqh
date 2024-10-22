
MqlDateTime _time_arq, _time_current;
string _arq_name;
string _robo_name;

string sep = ";";
ushort u_sep = StringGetCharacter(sep, 0);
string _arr[];

void onGetDatasetWin(int periodos, ENUM_TIMEFRAMES tempoGrafico, string roboName, string priceType = "close", string arrWin = "") {
   
   _arq_name = roboName + "//" + EnumToString(tempoGrafico) + "_" + priceType + "_" + IntegerToString(periodos) + "Candles.csv";
   _robo_name = roboName;
   
   StringSplit(arrWin, u_sep, _arr);
   int _arr_size = ArraySize(_arr);
   
   if(FileIsExist(_arq_name)){
      datetime lastTime = getLastTime();
           
      int contador = 0;
      for(int d = 0; d < 1000; d++){
         datetime t = iTime(_arr[0], tempoGrafico, d);
         if(t == lastTime) break;
         else contador += 1;
         
         if(contador > 900) Alert("Algo esta errado com o contador");
      }
      
      if(contador > 0) creatOrUpdateDataset(tempoGrafico, priceType, false, contador, _arr_size);
      else Print("Arquivo já esta atualizado!!");
      
   } else {
      creatOrUpdateDataset(tempoGrafico, priceType, true, periodos, _arr_size);
   }
   
   arqExecute();
}

void creatOrUpdateDataset(ENUM_TIMEFRAMES tempoGrafico, string priceType, bool create, int period, int _arr_size){

   if(create) Print(_robo_name + " ->> create iniciado!");
   else Print(_robo_name + " ->> update iniciado!");

   int h = FileOpen(_arq_name, FILE_ANSI|FILE_READ|FILE_WRITE|FILE_CSV, ";");
   if(create) FileWrite(h, concatSymbols(_arr_size));
   if(!create) FileSeek(h, 0, SEEK_END);
   
   string str;
   for(int i = period-1; i >= 0; i--){
   
      datetime time = iTime(_arr[0], tempoGrafico, i);
      str = TimeToString(time) + ";";
      
      for(int j = 0; j < _arr_size; j++){
         
         string price = "";
         if(priceType == "close") price = DoubleToString(iClose(_arr[j], tempoGrafico, i), 2);
         else if(priceType == "open") price = DoubleToString(iOpen(_arr[j], tempoGrafico, i), 2);
         
         if(price == "0.00") price = "NaN";
         
         if(j >= _arr_size - 1) str += price;
         else str += price + ";";
      }
      FileWrite(h, str);
   }
   FileClose(h);
   if(create) Print(_robo_name + " ->> criado com sucesso!");
   else Print(_robo_name + " ->> atualizado com sucesso!");
}

string concatSymbols(int _arr_size){

   string str = "Time;";
   for(int i = 0; i < _arr_size; i++){
      if(i >= _arr_size - 1) str += _arr[i];
      else str += _arr[i] + ";";
   }
   return str;
}

datetime getLastTime(){
   string result[];
   datetime lastTime = NULL;
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
   string _arq_name_sinal = _robo_name + "//comunication.txt"; 
   int hs = FileOpen(_arq_name_sinal, FILE_ANSI|FILE_WRITE|FILE_READ|FILE_TXT);
   if(hs == INVALID_HANDLE) Alert("Nao foi possivel carregar o " + _arq_name_sinal + "!!");
   FileWrite(hs, "ExecPython");
   FileClose(hs);
}

int getSeconds(ENUM_TIMEFRAMES _timeF){
   int sec = 0;
   switch(_timeF){
      case PERIOD_M1:
        sec = 60;break;
      case  PERIOD_M2:
        sec = 120;break;
      case  PERIOD_M3:
        sec = 180;break;
      case  PERIOD_M4:
        sec = 240;break;
      case  PERIOD_M5:
        sec = 300;break;
      case  PERIOD_M6:
        sec = 360;break;
      case  PERIOD_M10:
        sec = 600;break;
      case  PERIOD_M12:
        sec = 720;break;
      case  PERIOD_M15:
        sec = 900;break;
      case  PERIOD_M20:
        sec = 1200;break;
      case  PERIOD_M30:
        sec = 1800;break;
      case  PERIOD_H1:
        sec = 3600;break;
      case  PERIOD_H2:
        sec = 7200;break;
      case  PERIOD_H3:
        sec = 10800;break;
      case  PERIOD_H4:
        sec = 14400;break;
      case  PERIOD_H6:
        sec = 21600;break;
      case  PERIOD_H8:
        sec = 28800;break;
      case  PERIOD_H12:
        sec = 43200;break;
      case  PERIOD_D1:
        sec = 86400;break;
      case  PERIOD_W1:
        sec = 604800;break;        
      default:
        sec = -1;break;
   }
   return sec;
}