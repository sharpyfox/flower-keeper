#include <EtherCard.h>

// *******************************************************************
// DEFINE
// *******************************************************************

#define FEED    "89489"                                               // Идентификатор приложения
#define APIKEY  "DuEKET_N9sKpxolqa9JUEJ7y8AOSAKxMN1hGaWJRNlVqYz0g"    // ключ к API

// *******************************************************************
// Константы
// *******************************************************************

// MAC-адрес устройства
const byte mymac[] = { 0x74,0x69,0x69,0x2D,0x30,0x31 };
// ethernet interface ip address
static byte myip[] = { 192,168,137,150 };
// gateway ip address
static byte gwip[] = { 192,168,137,1 };
// remote website ip address and port
static byte hisip[] = {  216,52,233,121 };

// URL api для работы с потоками данных
const char website[] PROGMEM = "api.cosm.com";

// Количество сенсоров
const byte SensorsCount = 3;

// Периодичность отправки в секундах
const byte PushTimeout = 10;

// *******************************************************************
// Глобальные переменные
// *******************************************************************

byte Ethernet::buffer[700]; // максимальный размер буфера
uint32_t timer;
Stash stash;
float HumidityValues[SensorsCount] = {0, 0, 0};
uint32_t hum;

// *******************************************************************
// Функция, получающая данные с датчика влажности
// *******************************************************************
float moistureValue(int aPinNumber){
  const int NUMBER_OF_MEASUREMENTS = 5;
  int zValue = 0;
  int zMax = 0;
  int zMin = 1000;  
  for (int zIndex = 0; zIndex < NUMBER_OF_MEASUREMENTS; zIndex++) {
    int zCurValue = analogRead(aPinNumber);
    if (zCurValue > zMax ) {
      zMax = zCurValue;
    }
    if (zCurValue < zMin) {
      zMin = zCurValue;
    } 
    zValue += zCurValue;
    //delay(10);
  }
  return (zValue - zMin - zMax) / (NUMBER_OF_MEASUREMENTS - 2) / 10;
}

// *******************************************************************
// Метод, читающий данные с аналоговых входов
// *******************************************************************
void ReadHumidity () {
  HumidityValues[0] = moistureValue(0);
  HumidityValues[1] = moistureValue(1);
  HumidityValues[2] = moistureValue(2);
}

void PushData () {
  Serial.println("Push data in cloud");

  Stash::cleanup();  
  byte zMessage = stash.create();
  byte zIndex;
  
  for (byte zIndex = 0; zIndex < 3; zIndex++)
  {
    stash.print(zIndex + 1);
    stash.print(",");
    stash.println(HumidityValues[zIndex]);
  }
  
  stash.save();
    
  // generate the header with payload - note that the stash size is used,
  // and that a "stash descriptor" is passed in as argument using "$H"
  Stash::prepare(PSTR("PUT /v2/feeds/$F.csv HTTP/1.1" "\r\n"
                        "Host: api.cosm.com" "\r\n"
                        "X-ApiKey: $F" "\r\n"
                        "User-Agent: " "\r\n"
                        "Content-Length: $D" "\r\n"
                        "Content-Type: text/csv" "\r\n"
                        "Connection: close" "\r\n"
                        "\r\n"
                        "$H" "\r\n"                        
                        ),
            PSTR(FEED), PSTR(APIKEY), stash.size(), zMessage);
    

  // send the packet - this also releases all stash buffers once done
  byte zResult = ether.tcpSend();
}

// *******************************************************************
// Инициализация работы
// *******************************************************************
void setup () {
  hum = 1036800;
  
  Serial.begin(9600); // порт используется для отладки
  
  Serial.println("[  FlowerKeeper Setup start  ]");
  
  if (ether.begin(sizeof Ethernet::buffer, mymac, 10) == 0) 
    Serial.println( "Failed to access Ethernet controller");
  
  if (!ether.dhcpSetup()) {
    Serial.println("DHCP failed");
    ether.staticSetup(myip, gwip);
    Serial.println("Static ip setup completed");
  }
  else {
    ether.printIp("Assigned IP:  ", ether.myip);
    ether.printIp("Assigned GateWay:  ", ether.gwip);  
    ether.printIp("Assigneb DNS server: ", ether.dnsip);  
  }
  
  
  if (!ether.dnsLookup((char*)website)) {
    Serial.println("DNS failed");
    ether.copyIp(ether.hisip, hisip);
  }
  
  ether.printIp("Cosmo server IP: ", ether.hisip);
  Serial.println("[  FlowerKeeper Setup end  ]");
}

// *******************************************************************
// Петля
// *******************************************************************
void loop () {
  ether.packetLoop(ether.packetReceive());
  
  if (millis() > timer) {    
    timer = millis() + PushTimeout * 1000;                                         // отправка новых данных на сервер каждые 10 секунд
    
    ReadHumidity();
    PushData();
  }
}
