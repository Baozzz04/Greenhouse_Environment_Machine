//HU?NG D?N G?I-NH?N ? DU?I CÙNG

// SPI(nRF24L01) commands
#define READ_REG        0x00  // Define read command to register
#define WRITE_REG       0x20  // Define write command to register
#define RD_RX_PLOAD     0x61  // Define RX payload register address
#define WR_TX_PLOAD     0xA0  // Define TX payload register address
#define FLUSH_TX        0xE1  // Define flush TX register command
#define FLUSH_RX        0xE2  // Define flush RX register command
#define REUSE_TX_PL     0xE3  // Define reuse TX payload register command
#define NOP             0xFF  // Define No Operation, might be used to read status register
//------------------------
#define RX_DR    0x40
#define TX_DS    0x20
#define MAX_RT   0x10
//-------------------------

#define CONFIG          0x00  // 'Config' register address
#define EN_AA           0x01  // 'Enable Auto Acknowledgment' register address
#define EN_RXADDR       0x02  // 'Enabled RX addresses' register address
#define SETUP_AW        0x03  // 'Setup address width' register address
#define SETUP_RETR      0x04  // 'Setup Auto. Retrans' register address
#define RF_CH           0x05  // 'RF channel' register address
#define RF_SETUP        0x06  // 'RF setup' register address
#define STATUS          0x07  // 'Status' register address
#define OBSERVE_TX      0x08  // 'Observe TX' register address
#define RPD          	0x09  // 'Carrier Detect' register address
#define RX_ADDR_P0      0x0A  // 'RX address pipe0' register address
#define RX_ADDR_P1      0x0B  // 'RX address pipe1' register address
#define RX_ADDR_P2      0x0C  // 'RX address pipe2' register address
#define RX_ADDR_P3      0x0D  // 'RX address pipe3' register address
#define RX_ADDR_P4      0x0E  // 'RX address pipe4' register address
#define RX_ADDR_P5      0x0F  // 'RX address pipe5' register address
#define TX_ADDR         0x10  // 'TX address' register address
#define RX_PW_P0        0x11  // 'RX payload width, pipe0' register address
#define RX_PW_P1        0x12  // 'RX payload width, pipe1' register address
#define RX_PW_P2        0x13  // 'RX payload width, pipe2' register address
#define RX_PW_P3        0x14  // 'RX payload width, pipe3' register address
#define RX_PW_P4        0x15  // 'RX payload width, pipe4' register address
#define RX_PW_P5        0x16  // 'RX payload width, pipe5' register address
#define FIFO_STATUS     0x17  // 'FIFO Status Register' register address
#define FEATURE         0x1D  // 'FEATURE' register address
#define DYNPD           0x1C  // 'DYNAMIC PAYLOAD' register address  
/*----------------------
M?i d?a ch? truy?n-nh?n g?m 5byte
Ch? d? Multireceive thì 1 PRX có th? nh?n du?c cùng lúc t? 6 PTX khác nhau
D? li?u s? trao d?i qua các Pipe, t? Pipe_0 d?n Pipe_5
T? Pipe_2 tr? di, d?a ch? nh?n s? có 4 byte d?u gi?ng d?a ch? c?a Pipe_1

? bên G?I
PTX_0: 5byte (Address1)
PTX_1: 5byte (Address2)
PTX_2: 4byte (Address2) + 1 byte (Address3)
PTX_3: 4byte (Address2) + 1 byte (Address4)
PTX_4: 4byte (Address2) + 1 byte (Address5)
PTX_5: 4byte (Address2) + 1 byte (Address6)

? bên NH?N do ch? có 1 con nên ta quan tâm d?n d?a ch? các pipe nh?n khác nhau
Pipe0_RX_Add: 5byte (Address1)
Pipe1_RX_Add: 5byte (Address2)
Pipe2_RX_Add: 4byte (Address2) + 1 byte (Address3)
Pipe3_RX_Add: 4byte (Address2) + 1 byte (Address4)
Pipe4_RX_Add: 4byte (Address2) + 1 byte (Address5)
Pipe5_RX_Add: 4byte (Address2) + 1 byte (Address6)

----------------------*/
unsigned char Send_Add, Address1, Address2, Address3, Address4;
/*-------SPI---------*/
void SPI_Write(unsigned char Buff);
unsigned char SPI_Read(void);
void RF_Command(unsigned char command);
void RF_Write(unsigned char Reg_Add, unsigned char Value);
void RF_Write_Add(unsigned char Reg_Add, unsigned char Value);
void Common_Config();
/*-------TX_Mode---------*/
void RF_Write_Add_TX_2(unsigned char Reg_Add, unsigned char Address, unsigned char Address2);
void TX_Address(unsigned char Address);
void TX_Address_2(unsigned char Address, unsigned char Address2);
void TX_Mode();
void TX_Config();
void TX_Config_2();
void TX_Send();
/*-------RX_Mode---------*/
void RF_Write_Add_RX_2(unsigned char Reg_Add, unsigned char Address, unsigned char Address2);
void RX_Address(unsigned char Address_Pipe, unsigned char Address);
void RX_Address_2(unsigned char Address_Pipe, unsigned char Address, unsigned char Address2);
void RX_Mode();
void RX_Config();
void RX_Config_4();
void RX_Read();



/*----------------------
C?u trúc d? li?u d?ng typedef s? chuy?n d? li?u struct trong m?ng station_info v?i 
các thu?c tính c?a struct bên trong và gán vào station_receiver cho bên nh?n ho?c
station_send cho bên g?i.
----------------------*/
typedef struct{
    int temp;
    int humid;
    int light;
    int soil;
}station_info;

station_info station_receive;
station_info station_send;
/*----------------------
Ðây là hàm ghi d? li?u vào SPI 
Do không dùng modul SPI c?ng trên các chân I/O c?a AVR
Nên s? d?ng hàm này d? ghi d? li?u vào
Ð?ng th?i d?c giá tr? mà SPI tr? v?, tham v?ng check du?c ACK
----------------------*/
void SPI_Write(unsigned char Buff){
    unsigned char bit_ctr;
    for(bit_ctr=0;bit_ctr<8;bit_ctr++){
        MOSI = (Buff & 0x80);         
        delay_us(5);
        Buff = (Buff << 1);           
        SCK = 1;                      
        delay_us(5);
        Buff |= MISO;           
        SCK = 0;
    }
}
/*----------------------
Ðây là hàm d?c d? li?u ra t? SPI 
Do không dùng modul SPI c?ng trên các chân I/O c?a AVR
Nên s? d?ng hàm này d? d?c d? li?u ra
----------------------*/
unsigned char SPI_Read(void){
    unsigned char Buff=0;
    unsigned char bit_ctr;
    for(bit_ctr=0;bit_ctr<8;bit_ctr++){
        delay_us(5);
        Buff = (Buff << 1);        
        SCK = 1;                            
        delay_us(5);
        Buff |= MISO;             
        SCK = 0;               
    }
    return(Buff);                 
}
/*----------------------
RF_Command dùng d? ghi Command tr?c ti?p vào nRF24L01
----------------------*/
void RF_Command(unsigned char command){
    CSN=0;
    SPI_Write(command);
    CSN=1;
    delay_us(10);
}
/*----------------------
RF_Write dùng d? ghi d? li?u vào thanh ghi c?a nRF24L01
----------------------*/
void RF_Write(unsigned char Reg_Add, unsigned char Value){
    CSN=0;
    SPI_Write(0b00100000|Reg_Add);
    SPI_Write(Value);
    CSN=1;
    delay_us(10);
}
/*----------------------
RF_Write_Add dùng d? ghi d?a ch? cho nRF24L01
L?nh này dùng du?c ? c? PTX và PRX vì truy?n nh?n 1-1
? dây ghi cùng lúc 5 byte d?a ch? gi?ng h?t nhau vào cùng 1 thanh ghi
Thu?ng dùng khi truy?n-nh?n 1-1
----------------------*/
void RF_Write_Add(unsigned char Reg_Add, unsigned char Value){
    CSN=0;
    SPI_Write(0b00100000|Reg_Add);
    SPI_Write(Value);
    SPI_Write(Value);
    SPI_Write(Value);
    SPI_Write(Value);
    SPI_Write(Value);
    CSN=1;
    delay_us(10);
}
/*----------------------
RF_Write_Add_TX_2 dùng d? ghi d?a ch? TRUY?N cho nRF24L01 trong ch? d? Multireceive
Khi g?i b?t d?u t? PTX_2 tr? di thì b?t bu?c 4byte d?a ch? sau ph?i gi?ng d?a ch?
c?a PTX_1 nên ph?i ghi 4 byte d?a ch? sau theo Address2 (là d?a ch? c?a PTX_1)
Chú ý: Address ? dây ng?m d?nh là d?a ch? c?a PTX_2...5
----------------------*/
void RF_Write_Add_TX_2(unsigned char Reg_Add, unsigned char Address, unsigned char Address2){
    CSN=0;
    SPI_Write(0b00100000|Reg_Add);
    SPI_Write(Address);
    SPI_Write(Address2);
    SPI_Write(Address2);
    SPI_Write(Address2);
    SPI_Write(Address2);
    CSN=1;
    delay_us(10);
}
/*----------------------
RF_Write_Add_RX_2 dùng d? ghi d?a ch? NH?N cho nRF24L01 trong ch? d? Multireceive
Khi g?i b?t d?u t? PTX_2 tr? di thì b?t bu?c 4byte d?a ch? sau ph?i gi?ng d?a ch?
c?a PTX_1 nên ph?i ghi 4 byte d?a ch? sau theo Address2 (là d?a ch? c?a PTX_1)
Chú ý: Address ? dây ng?m d?nh là d?a ch? c?a PTX_2...5
Có l? do bên PTX Address du?c ghi vào d?u tiên nên ? PRX Address ph?i du?c ghi vào
cu?i cùng. Theo logic truy?n - nh?n n?i ti?p
----------------------*/
void RF_Write_Add_RX_2(unsigned char Reg_Add, unsigned char Address, unsigned char Address2){
    CSN=0;
    SPI_Write(0b00100000|Reg_Add);
    SPI_Write(Address2);
    SPI_Write(Address2);
    SPI_Write(Address2);
    SPI_Write(Address2);
    SPI_Write(Address);
    CSN=1;
    delay_us(10);
}
/*----------------------
TX_Address dùng d? ghi d?a ch? vào thanh ghi d?a ch? c?a PTX ? ch? d? truy?n nh?n 1-1
ho?c ch? d? Multireceive thì ? các PTX_0 và PTX_1
----------------------*/
void TX_Address(unsigned char Address){
    CSN=0;
    RF_Write(SETUP_AW,0b00000011); //ghi vào d? r?ng d?a ch? -  5byte
    CSN=1;
    delay_us(10);
    CSN=0;       
    RF_Write_Add(TX_ADDR, Address); //thanh ghi d?a ch? truy?n
}
/*----------------------
TX_Address_2 dùng d? ghi d?a ch? vào thanh ghi d?a ch? c?a PTX ? ch? d? Multireceive
L?nh này b?t d?u ghi ? các PTX_2 tr? di d?n PTX_5
Ð? r?ng d?a ch? cung là 5byte
----------------------*/
void TX_Address_2(unsigned char Address, unsigned char Address2){
    CSN=0;
    RF_Write(SETUP_AW,0b00000011);
    CSN=1;
    delay_us(10);
    CSN=0;       
    RF_Write_Add_TX_2(TX_ADDR, Address, Address2);  
}
/*----------------------
RX_Address dùng d? ghi d?a ch? vào thanh ghi d?a ch? c?a PRX ? ch? d? truy?n nh?n 1-1
ho?c ch? d? Multireceive thì ? các Pipe_0 và Pipe_1
Ð? r?ng d?a ch? là 5byte
----------------------*/
void RX_Address(unsigned char Address_Pipe, unsigned char Address){
    CSN=0;
    RF_Write(SETUP_AW,0b00000011);
    CSN=1;
    delay_us(10);
    CSN=0;       
    RF_Write_Add(Address_Pipe, Address);  
}
/*----------------------
RX_Address_2 dùng d? ghi d?a ch? vào thanh ghi d?a ch? c?a PRX ? ch? d? Multireceive
L?nh này b?t d?u ghi ? các Pipe_2 tr? di d?n Pipe_5
Ð? r?ng d?a ch? cung là 5byte
Address2 ng?m hi?u là d?a ch? c?a pipe 1
Address ng?m hi?u là d?a ch? c?a Pipe t? 2 - Pipe 5
----------------------*/
void RX_Address_2(unsigned char Address_Pipe, unsigned char Address, unsigned char Address2){
    CSN=0;
    RF_Write(SETUP_AW,0b00000011);
    CSN=1;
    delay_us(10);
    CSN=0;       
    RF_Write_Add_RX_2(Address_Pipe, Address, Address2);  //ghi vao pipe number, d?a ch? và d?a ch? pipe 1
}
/*----------------------
Config cho nRF24L01 ? ch? d? ho?t d?ng
M?c d?nh là ch? d? truy?n d? li?u, thanh ghi CONFIG 0x1E
Flush TX và RX d? xoá h?t d? li?u trong b? d?m
----------------------*/
void Common_Config(){
    CE=1;
	delay_us(700);
	CE=0; 
    CSN=1;
    SCK=0; 
    delay_us(100);
    RF_Write(STATUS,0b01111110); //STATUS 0x7E; clear all IRQ flag
    RF_Command(0b11100010);    //0xE2; flush RX
	RF_Command(0b11100001);    //Flush TX 0xE1
    RF_Write(CONFIG,0b00011111); //0x1E; truy?n d? li?u
    delay_ms(2);
	RF_Write(RF_CH,0b00000010); //RF_CH 0x05 Chanel 0 RF = 2400 + RF_CH* (1or 2 M)
	RF_Write(RF_SETUP,0b00000111); //RF_SETUP 0x07 = 1M, 0dBm
    RF_Write(FEATURE, 0b00000100); //0x1D Dynamic payload length
	RF_Write(EN_AA, 0b00000000); //0x1D Dynamic payload length
}
/*----------------------
Ðua nRF24L01 v? ch? d? truy?n d? li?u
Lúc này c?n xoá h?t các thanh ghi trong IRQ và dua chân CE ? m?c th?p
----------------------*/
void TX_Mode(){
    CE=0;
    RF_Write(CONFIG,0b00011110);
    delay_us(130);    //nrf can de khoi dong vao rx mode hoac txmode
}
/*----------------------
Ðua nRF24L01 v? ch? d? nh?n d? li?u
Lúc này c?n xoá h?t các thanh ghi trong IRQ và dua chân CE lên m?c cao
----------------------*/
void RX_Mode(){
    RF_Write(CONFIG,0b00011111);
    CE=1;
    delay_us(130);    //nrf can de khoi dong vao rx mode hoac txmode
}
/*----------------------
Config cho nRF24L01 ? ch? d? TRUY?N d? li?u 1-1 ho?c ch? d? Multireceive
thì config cho các PTX_0 và PTX_1
Xoá h?t d? li?u trong thanh ghi IRQ
Flush h?t d? li?u ? b? d?m nh?n và truy?n.
Cài d?t dynamic payload ? Pipe_0
Enable Pipe_0 d? truy?n d? li?u
----------------------*/
void TX_Config(){
    RF_Write(STATUS,0b01111110); //xoá IRQ flag
    RF_Command(0b11100001); //Flush TX 0xE1
    TX_Address(Send_Add);   //Ghi d?a ch? g?i d? li?u vào nRF24L01
	RF_Write(DYNPD,0b00000001); //Ð?t ch? d? dynamic paypload ? pipe 0
	RF_Write(EN_RXADDR,0b00000001); //Enable Pipe 0
}
/*----------------------
TX_Config_2()
Config cho nRF24L01 ? ch? d? TRUY?N d? li?u Multireceive
Dùng cho các PTX t? PTX_2 d?n PTX_5
Xoá h?t d? li?u trong thanh ghi IRQ
Flush h?t d? li?u ? b? d?m nh?n và truy?n.
G?i di thì dùng Pipe_0 ? PTX nên ch? cài d?t dynamic payload ? Pipe_0
Enable Pipe_0 d? truy?n d? li?u
----------------------*/
void TX_Config_2(){
    RF_Write(STATUS,0b01111110); //xoá IRQ flag
    RF_Command(0b11100001); //Flush TX 0xE1
    TX_Address_2(Send_Add, Address2); //Ghi d?a ch? g?i d? li?u vào nRF24L01   
    RF_Write(DYNPD,0b00000001); //Ð?t ch? d? dynamic paypload ? pipe 0
    RF_Write(EN_RXADDR,0b00000001); //Enable Pipe 0
}
/*----------------------
RX_Config()
Config cho nRF24L01 ? ch? d? NH?N d? li?u 1-1
Xoá h?t d? li?u trong thanh ghi IRQ
Flush h?t d? li?u ? b? d?m nh?n và truy?n.
M? các Pipe t? 0 và cài d?t ch? d? dynamic payload
? Pipe_0 d?a ch? du?c ghi vào theo 5 byte Address1
----------------------*/
void RX_Config(){
    RF_Write(STATUS,0b01111110); //xoá IRQ flag
    RF_Command(0b11100010); //Flush RX
    RF_Write(DYNPD,0b00000001); //Ð?t ch? d? dynamic paypload ? pipe 0
    RF_Write(EN_RXADDR,0b00000001); //Enable RX ? Pipe 0
    RX_Address(RX_ADDR_P0, Address1);
}
/*----------------------
RX_Config_4()
Config cho nRF24L01 ? ch? d? NH?N d? li?u Multireceive (4 Pipe)
Xoá h?t d? li?u trong thanh ghi IRQ
Flush h?t d? li?u ? b? d?m nh?n và truy?n.
M? các Pipe t? 0 d?n 4 và cài d?t ch? d? dynamic payload
? Pipe_0 d?a ch? du?c ghi vào theo 5 byte Address1
? Pipe_1 d?a ch? du?c ghi vào theo 5 byte Address2
? Pipe_2 d?a ch? du?c ghi vào theo 4 byte Address2 và 1 byte Address3
? Pipe_3 d?a ch? du?c ghi vào theo 4 byte Address2 và 1 byte Address4
----------------------*/
void RX_Config_4(){
    RF_Write(STATUS,0b01111110); //xoá IRQ flag
    RF_Command(0b11100010); //0xE2 = Flush RX
    RF_Write(DYNPD,0b00001111); //Ð?t ch? d? dynamic paypload ? pipe 0-4
    RF_Write(EN_RXADDR,0b00001111); //Enable RX ? Pipe 0 - pipe 4
    RX_Address(RX_ADDR_P0, Address1);
    RX_Address(RX_ADDR_P1, Address2);
    RX_Address_2(RX_ADDR_P2, Address3, Address2);
    RX_Address_2(RX_ADDR_P3, Address4, Address2);
}
/*----------------------
RX_Config_6() 
Config cho nRF24L01 ? ch? d? NH?N d? li?u Multireceive (6 Pipe)
Xoá h?t d? li?u trong thanh ghi IRQ
Flush h?t d? li?u ? b? d?m nh?n và truy?n.
M? các Pipe t? 0 d?n 4 và cài d?t ch? d? dynamic payload
? Pipe_0 d?a ch? du?c ghi vào theo 5 byte Address1
? Pipe_1 d?a ch? du?c ghi vào theo 5 byte Address2
? Pipe_2 d?a ch? du?c ghi vào theo 4 byte Address2 và 1 byte Address3
? Pipe_3 d?a ch? du?c ghi vào theo 4 byte Address2 và 1 byte Address4
? Pipe_4 d?a ch? du?c ghi vào theo 4 byte Address2 và 1 byte Address5
? Pipe_5 d?a ch? du?c ghi vào theo 4 byte Address2 và 1 byte Address6
----------------------*/

/*----------------------
TX_Send()
Config cho nRF24L01 ? ch? d? TRUY?N d? li?u ? ch? d? 1-1
Ho?c Multireceive nhung ? các PTX_0 và PTX_1
Xoá h?t d? li?u trong thanh ghi IRQ
Flush h?t d? li?u ? b? d?m truy?n.
Ghi d? li?u c?n g?i vào payload truy?n
Sau khi truy?n di thì xoá h?t các IRQ
Ghi d?a ch? g?i d? li?u vào nRF24L01 - KHÔNG HI?U CH? NÀY
Sau khi g?i d? li?u di thì FLUSH h?t b? d?m G?I
----------------------*/
void TX_Send(){
    TX_Address(Send_Add); //Ghi d?a ch? g?i d? li?u vào nRF24L01
    CSN=1;
    delay_us(10);
    CSN=0;
    SPI_Write(0b11100001); //0xE1=Define flush TX register command
    CSN=1;
    delay_us(10);
    CSN=0;
    SPI_Write(0b10100000); //0xA0 = Define TX payload register address
    SPI_Write(station_send.temp); //ghi d? li?u vào payload
    SPI_Write(station_send.humid);
    SPI_Write(station_send.light);
    SPI_Write(station_send.soil);
    CSN=1;
    CE=1;
    delay_us(500);
    CE=0;
    RF_Write(0x07,0b01111110); //STATUS, 0x7E-clear IRQ flag (Tam test 0x70 van chay)
    TX_Address(Send_Add); //Ghi d?a ch? g?i d? li?u vào nRF24L01
    RF_Command(0b11100001);//Flush TX 0xE1  
}
/*----------------------
TX_Send_2()
Config cho nRF24L01 ? ch? d? TRUY?N d? li?u Multireceive t? PTX_2 và PTX_5
Xoá h?t d? li?u trong thanh ghi IRQ
Flush h?t d? li?u ? b? d?m truy?n.
Ghi d? li?u c?n g?i vào payload truy?n
Sau khi truy?n di thì xoá h?t các IRQ
Ghi d?a ch? g?i d? li?u vào nRF24L01 - KHÔNG HI?U CH? NÀY
Sau khi g?i d? li?u di thì FLUSH h?t b? d?m G?I
----------------------*/

/*----------------------
RX_Read()
Ð?c d? li?u t? buffer c?a b? NH?N d? li?u
Ð?c t? b? d?m RX các giá tr? du?c luu vào khi nh?n du?c
Sau khi d?c xong thì clear h?t các thanh ghi IRQ
và Flush b? d?m nh?n
----------------------*/
void RX_Read(){
    CE=0;
    CSN=1;
    delay_us(10);
    CSN=0;
    SPI_Write(0b01100001); //0x61 = Define RX payload register address
    delay_us(10);              
    station_receive.temp = SPI_Read();
    station_receive.humid = SPI_Read();     
    station_receive.light = SPI_Read(); 
    station_receive.soil = SPI_Read(); 
    CSN=1;
    CE=1;
    RF_Write(STATUS,0b01111110); // 0x7E-clear IRQ flag
    RF_Command(0b11100010); //0xE2 = Flush RX
}



/*------------
// Chuong trình g?i dành cho tr?m 1 
Send_Add = 0xA1;;  //Ðây chính là Send_Add lúc khai báo à ???
Common_Config();
TX_mode();
TX_config();
TX_send();

// Chuong trình g?i dành cho tr?m 2 
Send_Add = 0xA2;
Common_Config();
TX_mode();
TX_config();
TX_send();

// Chuong trình g?i dành cho tr?m 3 
Send_Add=0xA3;
Address2=0xA2;
Common_Config();
TX_mode();
TX_config_2();
TX_send_2();

// Chuong trình g?i dành cho tr?m 4 
Send_Add=0xA4;
Address2=0xA2;
Common_Config();
TX_mode();
TX_config_2();
TX_send_2();
// Chuong trình g?i dành cho tr?m 5 
Address2=0xA2;
Address5=0xA5;
Common_Config();
TX_mode();
TX_config_2();
TX_send_2();
// Chuong trình g?i dành cho tr?m 6 
Address2=0xA2;
Address6=0xA6;
Common_Config();
TX_mode();
TX_config_2();
TX_send_2();
// Chuong trình nh?n dành cho 4 tr?m
Address1 = 0xA1;
Address2 = 0xA2;
Address3 = 0xA3;
Address4 = 0xA4;
Common_Config();
RX_Mode();
RX_Config_4();
if(IRQ == 0){
        RX_Read();
            }
// Chuong trình nh?n dành cho 6 tr?m
Address1 = 0xA1;
Address2 = 0xA2;
Address3 = 0xA3;
Address4 = 0xA4;
Address5 = 0xA5;
Address6 = 0xA6;
Common_Config();
RX_Mode();
RX_Config_6();
if(IRQ == 0){
        RX_Read();
            }
--------------*/